<a id="arhitekturnye-diagrammy-mlsec"></a>

# Архитектурные диаграммы MLSec

Сводка архитектурных схем в Mermaid для review, онбординга и пояснений. Редакция 13.11.2026. Схемы описывают контракты и предлагаемые границы контроля; они не подтверждают, что конкретный deployment реализован или проверен.

<a id="1-mlsec-lifecycle-5-etapov"></a>

## 1. MLSec Lifecycle (5 этапов)

Пять проектных Stage 0–4 соответствуют главам 02–06. Это другая ось, чем пять функциональных блоков главы 01: Data → Model → Red Team/Validation → Deployment → Operations. Design задаёт границы, а validation/red teaming проверяет несколько этапов. Номер Stage не подставляется вместо номера блока. Source/configured, verified, released, running и operated подтверждаются разным evidence.

```mermaid
flowchart LR
    S0["Stage 0: Design<br/>границы, владельцы,<br/>intended use / threat model"]
    S1["Stage 1: Data<br/>допущенный dataset release"]
    S2["Stage 2: Model<br/>bundle + evaluation evidence"]
    S3["Stage 3: Deployment<br/>release decision + active revisions"]
    S4["Stage 4: Operations<br/>SLO, drift, IR / recovery"]
    GOV["Governance и владельцы<br/>policy / risk / evidence"]
    RT["Red Team / Validation<br/>positive, negative, failure cases"]
    AG["Agents overlay 31–36<br/>tools, delegation, memory, effects"]
    S0 --> S1 --> S2 --> S3 --> S4
    S4 -. "изменения / отзыв / повторная оценка" .-> S0
    GOV --- S0 & S1 & S2 & S3 & S4
    RT --- S1 & S2 & S3 & S4
    AG --- S0 & S3 & S4
```

Подробнее: [01. Обзор и архитектура](01-overview-architecture.md).

<a id="2-zelevaa-arhitektura-s-llm-gateway"></a>

## 2. Целевая архитектура с LLM Gateway

Схема выбранного защищённого маршрута, а не утверждение о перехвате всех запросов. Отдельно проверяются direct API, batch, tools, fallback и очереди. Identity/route admission не заменяет action authorization: consequential action с неизвестным обязательным разрешением не исполняется. Для остальных операций допустимый режим при отказе задаёт конкретная operation policy, а не cloud/on-prem.

```mermaid
flowchart TB
    CLIENT["Пользователь / приложение / агент"]
    CONTROL["Control plane<br/>approved policy / identity / revisions<br/>stop / revoke"]
    AUTH["Доверенная identity<br/>tenant / session / delegation"]
    ADMIT{"Admission маршрута<br/>scope / data / budget"}
    INPUT["Обязательные pre-call checks"]
    CACHE{"Кандидат cache hit?"}
    RIGHTS{"Текущие source ACL<br/>tenant / revisions / TTL?"}
    CONTEXT["Сброс stale cache<br/>контекст по текущим правам"]
    ROUTE["Разрешённый model route<br/>current retrieval ACL / fallback scope"]
    MODEL["Model inference<br/>ответ / предложение действия"]
    OUTPUT["Output / schema / data checks<br/>включая cache response"]
    RESPONSE["Разрешённый ответ"]
    EXEC{"Executor перед эффектом<br/>current grant / exact args<br/>approval / budget / revoke"}
    TOOL["Tool / очередь / удалённый job"]
    EFFECT["Readback / receipt<br/>completed / pending / unknown<br/>owner сверки"]
    DENY["Отказ / hold<br/>по operation policy"]
    STORE["Разрешённая запись cache<br/>tenant / source revisions / TTL"]
    AUDIT["Audit metadata<br/>attempt / decision / outcome<br/>redacted references"]
    CLIENT --> AUTH --> ADMIT
    CONTROL --> ADMIT & EXEC
    ADMIT -- "допуск" --> INPUT
    INPUT -- "пройдено" --> CACHE
    INPUT -- "отказ / обязательный unknown" --> DENY
    ADMIT -- "нет допуска" --> DENY
    CACHE -- "hit" --> RIGHTS
    CACHE -- "miss" --> ROUTE
    RIGHTS -- "да" --> OUTPUT
    RIGHTS -- "нет / устарело" --> CONTEXT --> ROUTE
    ROUTE --> MODEL --> OUTPUT
    OUTPUT -- "разрешённый ответ" --> RESPONSE
    OUTPUT -- "action proposal" --> EXEC
    OUTPUT -- "не пройден обязательный контроль" --> DENY
    OUTPUT -. "если разрешено" .-> STORE
    EXEC -- "разрешено сейчас" --> TOOL --> EFFECT
    EXEC -- "нет / unknown" --> DENY
    ADMIT & EXEC & EFFECT & DENY --> AUDIT
```

Подробнее: [01 §3.4–3.6](01-overview-architecture.md), [12. Контроли](12-detection-protection-cicd-llm.md), [33. Action boundary](33-ai-agents-security-overlay.md).

<a id="3-6-slojnyj-dlp"></a>

## 3. 6-слойный DLP

Шесть сигналов — пример, не обязательный продуктовый стек или процент защищённости. Зависимые extraction/normalization выполняются до fan-out; async не гарантирует CPU-параллелизм. Общий parser/model/timeout создаёт коррелированные gaps. Обязательный контроль данных и admission consequential action не считается пройденным при unknown; ограниченное чтение допускается только по заранее утверждённой policy. Повторная проверка masked payload имеет лимит попыток / бюджета; незавершённая проверка не становится ALLOW. Output и executor проверяются отдельно от pre-call DLP.

```mermaid
flowchart LR
    INPUT["Запрос / документы / attachments"]
    PREP["Обязательное извлечение<br/>и нормализация"]
    subgraph SCAN[Пример параллелизуемых сигналов]
        L0["L0: Injection patterns"]
        L1["L1: Secrets / formats"]
        L2["L2: PII / NER"]
        L3["L3: Text classifiers"]
        L4["L4: Corporate patterns"]
        L5["L5: Semantic signals"]
    end
    COLLECT["Сбор вердиктов<br/>полнота / deadline / policy"]
    COMPLETE{"Есть обязательное<br/>evidence операции?"}
    FAIL["Unknown / error / timeout<br/>consequential action: deny / hold<br/>чтение: утверждённая policy"]
    POLICY{"Policy decision"}
    DENY["BLOCK / отказ"]
    MASK["MASK<br/>пересборка + повторная проверка"]
    OUT["Разрешённый route<br/>не разрешение tool action"]
    INPUT --> PREP
    PREP --> L0 & L1 & L2 & L3 & L4 & L5
    L0 & L1 & L2 & L3 & L4 & L5 --> COLLECT --> COMPLETE
    COMPLETE -- "нет" --> FAIL
    COMPLETE -- "да" --> POLICY
    POLICY -- "BLOCK" --> DENY
    POLICY -- "MASK" --> MASK --> PREP
    POLICY -- "ALLOW" --> OUT
```

Подробнее: [12 §3.1](12-detection-protection-cicd-llm.md), [01. Gateway](01-overview-architecture.md).

<a id="4-kill-switch-5-urovnej"></a>

## 4. Kill-switch 5 уровней

L0–L4 обозначают области воздействия, не вложенную иерархию: user/model/provider/agent scopes пересекаются. Владелец выбирает одну или несколько областей по ситуации; не каждый alert вызывает общий stop. Код HTTP, флаг в Redis или stopped не доказывает прекращение эффекта. Проверяется отказ на фактическом пути; уже принятый внешний job требует readback / поддерживаемой отмены и сверки, а не слепого retry.

```mermaid
flowchart TB
    TRIGGER["Инцидент / риск / budget<br/>наблюдаемый триггер"]
    OWNER["Owner / IR-on-call<br/>scope / основание / policy revision"]
    L0["L0: общий stop новых запусков"]
    L1["L1: subject / user scope"]
    L2["L2: model / deployment scope"]
    L3["L3: provider / egress scope"]
    L4["L4: agent / workflow / run scope"]
    REVOKE["Применить ограничения<br/>grants / sessions / dispatch"]
    VERIFY["Проверить фактический отказ<br/>children / queue / retry / resume"]
    EFFECTS["Реестр внешних effects<br/>pending / cancelled / completed / unknown"]
    AUDIT["Минимальные evidence refs<br/>время / исход / ответственный"]
    TRIGGER --> OWNER
    OWNER --> L0 & L1 & L2 & L3 & L4
    L0 & L1 & L2 & L3 & L4 --> REVOKE --> VERIFY --> EFFECTS --> AUDIT
```

Подробнее: [34. Runtime / revoke](34-ai-agents-runtime-procedure.md), [35. Инциденты](35-ai-agents-incident-playbook.md), [15. Реестр последствий](15-ai-incident-response.md).

<a id="5-data-pipeline-security"></a>

## 5. Data pipeline security

Схема допуска конкретного выпуска данных. K0–K4 — внутренняя чувствительность, Tier — критичность; УЗ ИСПДн и категория КИИ определяются отдельно. K4/гостайна вне общего AI-контура. Clean PII scan, маскирование, checksum и подпись по отдельности не доказывают анонимность или разрешение обучения. Labels / preprocessing могут изменить свойства данных и требуют проверки.

```mermaid
flowchart LR
    SRC["Источники / права / provenance"]
    USE{"Разрешены цель<br/>и условия использования?"}
    CLS{"Класс данных K<br/>Tier системы и правовой режим отдельно"}
    OUTSIDE["K4 / гостайна<br/>вне общего AI-контура"]
    Q["Quarantine<br/>нет допуска к training"]
    PREP["Versioned preprocessing / split<br/>labels / source manifests"]
    CHECK["Schema / quality / privacy checks<br/>обработка PII по допустимой цели"]
    PROMOTE{"Dataset release<br/>проверен и допущен?"}
    MANIFEST["Approved manifest<br/>digests / permitted use / policy"]
    CURRENT{"Текущий допуск<br/>нет отзыва?"}
    TRAIN["Training pinned release<br/>не latest filename"]
    REVOKE["Отзыв / tombstones"]
    DERIV["Производные / cache / restore<br/>проверка и owner решения"]
    SRC --> USE
    USE -- "нет / unknown" --> Q
    USE -- "да" --> CLS
    CLS -- "K4" --> OUTSIDE
    CLS -- "допустимый scope" --> PREP --> CHECK --> PROMOTE
    PROMOTE -- "нет / unknown" --> Q
    PROMOTE -- "да" --> MANIFEST --> CURRENT
    CURRENT -- "да" --> TRAIN
    CURRENT -- "нет / unknown" --> Q
    REVOKE --> CURRENT & DERIV
```

Подробнее: [03. Data Operations](03-stage1-data-operations.md).

<a id="6-ai-incident-response-flow"></a>

## 6. AI Incident Response flow

Сдерживание, сбор доказательств и квалификация уведомлений идут параллельно: активная утечка и часы уведомления не ждут полного RCA / recovery. Адресат и срок выбираются по событию, объекту и актуальному пункту акта; уведомление субъектов не является автоматической заменой сообщения РКН. Retraining — только обоснованная remediation; rollback не отменяет внешний платёж, отправку или экспорт.

```mermaid
flowchart TB
    DET["Detect<br/>DLP / SIEM / user / cost / drift"]
    TRI["Triage<br/>объект / событие / impact<br/>run / release / owner"]
    CON["Contain<br/>новые действия / grants / queue"]
    LEGAL["Параллельно: применимость уведомлений<br/>акт / пункт / триггер / due_at / owner"]
    NOTIFY["Выбранные адресаты<br/>initial / follow-up / квитанция"]
    EFFECTS["Внешние effects ledger<br/>pending / completed / cancelled / unknown"]
    INV["Forensics с минимизацией<br/>references / chain of custody"]
    ERD["Адресная remediation<br/>data / model / config / credentials"]
    DEC["Решение о возврате<br/>остаточный риск / внешние исходы"]
    TEST{"Deny + полезный positive case<br/>current ACL / no replay?"}
    REC["Recovery<br/>новый release / re-approval<br/>контроль работы"]
    RET["Retrospective<br/>изменение controls / playbook"]
    DET --> TRI
    TRI --> CON & LEGAL
    LEGAL --> NOTIFY
    CON --> EFFECTS & INV
    INV --> ERD --> DEC
    INV -. "уточнение фактов" .-> LEGAL
    EFFECTS --> DEC --> TEST
    TEST -- "нет / критичный unknown" --> CON
    TEST -- "да" --> REC --> RET
```

Подробнее: [15. AI Incident Response](15-ai-incident-response.md), [18. Применимость и уведомления](18-ru-compliance-deep.md), [35. Re-approval](35-ai-agents-incident-playbook.md).

<a id="7-karta-standartov-i-glav"></a>

## 7. Карта стандартов и глав

Выбранные тематические связи, не crosswalk полного соответствия. Статус и версия источника сохраняются в evidence: OWASP 2025 IDs не переименовываются автоматически в 2026; ATLAS content и data-format различаются; IPD — draft, не замена final RMF. ISO 42001 относится к AIMS, а не к сертификации каждого model output. Законы применяются по конкретному scope.

```mermaid
flowchart LR
    subgraph SOURCES[Источники разных типов]
        OWASP["OWASP: guidance<br/>LLM 2025 mapping / 2026 отдельно<br/>Agentic 2026 / Guide V2"]
        ATLAS["MITRE ATLAS: catalog<br/>content 2026.10 / format 6.1.0"]
        NIST["NIST: final framework / profile<br/>AI RMF 1.0 / AI 600-1<br/>AI 100-2 taxonomy"]
        DRAFT["SP 2400-102 E2026<br/>Initial Public Draft 09.11.2026"]
        ISO["ISO 42001: AIMS<br/>ISO 23894: risk guidance"]
        EU["EU AI Act<br/>редакция / role / use / date"]
        RU["РФ: конкретный акт / редакция<br/>обработка / субъект / объект / событие"]
    end
    subgraph CHAPTERS[Выбранные тематические связи]
        C01["01. Architecture / evidence"]
        C09["09. Threat model"]
        C14["14. Governance"]
        C15["15. IR"]
        C16["16. ML / RAG attacks"]
        C17["17. Privacy / PET"]
        C18["18. Правовая применимость"]
        AG["31–36. Agent overlays"]
    end
    CRYPTO["SP 800-232: final Ascon crypto<br/>constrained devices, не AML taxonomy"]
    DEVICE["Отдельный криптографический scope<br/>если применим проекту"]
    OWASP --> C09 & C16 & AG
    ATLAS --> C09 & C15 & C16
    NIST --> C01 & C14 & C17
    DRAFT -. "research / review" .-> C09 & AG
    ISO --> C14
    EU --> C14 & C18
    RU --> C18 & C15
    CRYPTO --> DEVICE
```

Источники и версии: [31](31-ai-agents-overview.md), [матрицы](compliance-matrices/README.md). [NIST SP 800-232](https://csrc.nist.gov/pubs/sp/800/232/final) — final 13.08.2025, Ascon AEAD/hash/XOF для constrained devices; выделен отдельно. Проверено 13.11.2026.

<a id="8-roli-i-dostup-k-prozessam"></a>

## 8. Роли и доступ к процессам

```mermaid
flowchart LR
    subgraph L1[Реализация и владельцы]
        OWNER["Владелец сценария / продукта"]
        DATA["Data / model owners"]
        CONNECTOR["Владелец коннектора"]
        ML["ML / developer team"]
        PLATFORM["Platform / MLOps"]
    end
    subgraph L2[Review и применимость]
        SECURITY["MLSec / risk review"]
        LEGAL["Legal / Compliance"]
        FIN["FinOps / CFO"]
    end
    RELEASE["Решение release / scope<br/>версии / evidence / accountable owner"]
    RESP["IR Manager / on-call<br/>containment / effects / recovery"]
    ECON["Baseline / расходы / customer utility<br/>отдельно от сценарного risk reduction"]
    EVID["Проверенные результаты + gaps<br/>дата / subject / reviewer / limits"]
    AUDIT["Независимый внутренний / внешний audit<br/>assurance первой и второй линий"]
    OWNER & DATA & CONNECTOR & ML & PLATFORM --> RELEASE
    SECURITY & LEGAL --> RELEASE
    PLATFORM & CONNECTOR --> RESP
    LEGAL --> RESP
    FIN & OWNER --> ECON
    RELEASE & RESP & ECON --> EVID --> AUDIT
```

Стрелки показывают участие и evidence handoff, не ACL и не готовую RACI для любой организации. Для каждого решения назначаются accountable owner и исполнители; независимый review отделяется от реализации. Release approval не заменяет актуальные права отдельного action. Одностраничники: [role-cheatsheets/](role-cheatsheets/); агентные подписи и полномочия — [36](36-ai-agents-production-checklist.md).

---

<a id="kak-ispol_zovat_-diagrammy"></a>

## Как использовать диаграммы

1. В презентациях для правления: диаграммы 1, 2, 4 и 6 - покрывают governance, архитектуру, kill-switch и IR.
2. В онбординге новых сотрудников службы ИБ: диаграммы 2, 3 и 5 - защитный контур и data pipeline.
3. В пояснительных записках: диаграммы 2, 3, 4 — выбранные границы контроля. Их дополняют применимым требованием, конкретным subject/policy revision, тестами и evidence; схема не является аттестацией или подтверждением соответствия.
4. В архитектурных review: диаграммы 1, 2 - lifecycle и целевая архитектура.

<a id="proverka-i-lokal_noe-ispol_zovanie"></a>

## Проверка и локальное использование

Версию Mermaid закрепляют в проекте. Grammar parse, визуальная компоновка и работающий enforcement проверяются отдельно: успешный parser не доказывает layout, полноту аудита или отсутствие внешнего эффекта. Для приёмки каждой схемы выбирают разрешённый positive case, запрещённый / unknown case и отказ обязательного контроля, затем сопоставляют observable outcome с policy.

Экспорт изображений или PDF выполняется отдельным локальным шагом после review содержания и renderer; эта редакция не содержит проверенного универсального export recipe.
