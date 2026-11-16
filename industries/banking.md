<a id="banking-finteh-mlsec-playbook"></a>

# Banking / Финтех: MLSec playbook

> **Версия**: 1.1 · **Дата**: 2026-05-29
> **Регуляторы**: ЦБ РФ, ФинЦЕРТ, Росфинмониторинг, ФНС, ФСТЭК
> **Нормативный контекст**: 86-ФЗ, 115-ФЗ, 161-ФЗ, 152-ФЗ, 187-ФЗ, 572-ФЗ, применимые положения Банка России и стандарты защиты информации. Конкретный состав и редакции определяются видом организации, операции и системы по [главе 18](../18-ru-compliance-deep.md); этот список не является универсальным checklist соответствия банка.

<a id="1-prioritetnye-use-cases"></a>

## 1. Приоритетные use cases

| Use case | Tier | Риск |
|---|---|---|
| AML/KYC моделирование | 1 | Компромисс → проникновение преступников |
| Кредитный скоринг | 1 | Bias → ФАС, репутация |
| Anti-fraud в реальном времени | 1 | False negative → убыток, ЦБ-санкции |
| Voice bio в мобильном приложении | 1 | Deepfake voice → несанкционированные операции |
| Чат-бот для клиентов | 2 | PII утечка → 152-ФЗ, ЦБ штраф |
| Ассистент для сотрудников | 2-3 | Слив внутренних процедур, AML-методик |
| RAG по внутренней базе знаний | 3 | Вся документация в одном индексе |
| Code assistant для разработки core banking | 3 | Утечка IP, backdoor в prod |

<a id="2-spezificeskie-ugrozy"></a>

## 2. Специфические угрозы

**Кража скоринговой модели**: через API противник собирает выходы (AML.T0135 Outputs from AI Models); канал передачи ответов — AML.T0024 Exfiltration via AI Inference API. Обучение / адаптация суррогата на этих выходах — отдельная AML.T0005.001 Replicate Behavior from Model Outputs, требующая свидетельств; серия запросов не доказывает кражу весов или точное воспроизведение логики. Rate-limit и query monitoring уменьшают возможности сбора, watermark / fingerprint требуют самостоятельной проверки. Скачивание артефакта расследуется другой ветвью по storage / egress evidence — см. [IR-02](../playbooks/IR-02-model-extraction.md) и [гл. 16](../16-ml-attacks-rag-multimodal.md).

**Manipulation детектора fraud**: обученные запросы через pymine/adversarial примеры, подгоняющие признаки к «нормальным». Митигация: ensemble + streaming anomaly detection.

**Voice cloning для обхода IVR**: голосовой клон клиента, автоматический звонок с просьбой разблокировки карты. Митигация: применимые replay / synthetic speech тесты (см. [гл. 27](../27-voice-ai-security.md)), независимое подтверждение личности и операции; SMS не является универсально безопасным вторым каналом при SIM-swap.

**Jailbreak клиентского бота**: извлечение AML-методологии или лимитов. Митигация: Anti-EchoLeak, post-DLP, запрет обсуждения internal methodology.

**AI-мошенничество клиентов**: LLM-сгенерированные резюме и документы для получения кредита. Митигация: проверка утверждений по допустимым независимым источникам; C2PA подтверждает сведения о происхождении при наличии доверенной цепочки, а не истинность документа и не отсутствие подделки без manifest.

<a id="3-regulatornye-hot-points"></a>

## 3. Регуляторные hot-points

<a id="zasita-informazii-v-bankovskom-szenarii"></a>

### Защита информации в банковском сценарии

Профиль требований определяется применимым актом и операцией; не следует приписывать 802-П универсальную замену 382-П. Технический минимум для проектирования:
- Сегментация контуров, отдельный контур для обработки платежных данных.
- Контроль целостности ПО.
- Оценка защищённости с периодичностью, установленной применимыми требованиями и внутренней программой.

**MLSec-аспекты**:
- AI-модели в платежных pipeline входят в контур и должны проходить оценку.
- Supply chain ML-модели (pretrained weights): verified signatures (см. [opa/supply-chain.rego](../opa/supply-chain.rego)).

<a id="upravlenie-model_nym-i-operazionnym-riskom"></a>

### Управление модельным и операционным риском

716-П относится к управлению операционным риском; тезис «глава 5 — обязательный MRM для любого AI» некорректен. Применимые требования к моделям определяет риск-функция по виду использования. **Внутренний контроль**: production ML/AI-модели в реестре, риск-класс, validation по риску, Model Card, Validation Report и ongoing monitoring.

**Integration**: [opa/model-deployment.rego](../opa/model-deployment.rego) проверяет наличие required_signoffs (ml_tech_lead, ciso, mrm_lead) перед deployment Tier 1.

<a id="finzert-trebovania"></a>

### ФинЦЕРТ требования

ФинЦЕРТ это отдельный CERT ЦБ РФ для fin-систем:
- Основания, адресат, канал и срок сообщения определяются видом инцидента и статусом субъекта / объекта, а не наличием AI или внутренней SEV.
- Участие в обмене IoC через FinCERT feed.
- Регулярный pentest.

**IR integration**: [IR-02](../playbooks/IR-02-model-extraction.md), [IR-04](../playbooks/IR-04-agentic-breach.md) и юридическая матрица [главы 18](../18-ru-compliance-deep.md). Срок «3 часа для каждого ML-инцидента» не устанавливается этим playbook.

<a id="115-fz-aml"></a>

### 115-ФЗ (AML)

ML-поддержка AML не заменяет обязанности организации и ответственных лиц по применимому режиму ПОД/ФТ. Контроли конкретного процесса:
- Reproducibility: полный audit-trail (input → output → decision).
- Роли ответственного работника и основания пересмотра определены для конкретного процесса; внутренний Tier не является категорией 115-ФЗ.
- Explanation для regulator on request.
- Сроки хранения определены по конкретным документам / сведениям и применимым нормам; не все prompts и traces автоматически хранятся пять лет.

<a id="ebs-572-fz"></a>

### ЕБС (572-ФЗ)

Использование голоса для распознавания речи не тождественно биометрической идентификации. Юрист определяет применимость 572-ФЗ и режим конкретной идентификации / аутентификации; blanket-правило «любое voice → ЕБС / лицензия» неприменимо. В [главе 27](../27-voice-ai-security.md) — технические угрозы.

<a id="4-minimal_nyj-nabor-kontrolej"></a>

## 4. Минимальный набор контролей

<a id="data"></a>

### Data
- [ ] Все обучающие датасеты классифицированы K2+.
- [ ] DGO + AI Risk Committee для каждого нового проекта.
- [ ] PET выбраны по threat model; при DP документированы механизм, accounting, ε/δ и utility. Внутренний K3+ не устанавливает законный предел ε.
- [ ] Data Lineage 100% (DVC / lakeFS + метаданные).

<a id="model"></a>

### Model
- [ ] MRM реестр, Tier-классификация.
- [ ] Model Card + Validation Report для каждой prod-модели.
- [ ] Independent validation команда.
- [ ] Adversarial testing (ART) обязателен для Tier 1-2.
- [ ] Bias analysis (Fairlearn) с подписью compliance.

<a id="deployment"></a>

### Deployment
- [ ] Canary 5-10% → 50% → 100% (медленнее, чем в retail).
- [ ] Shadow mode минимум 30 дней для Tier 1.
- [ ] Kill-switch L0-L4 реализован, RTO ≤ 30 sec.
- [ ] Cosign подписи + Sigstore MT.

<a id="access"></a>

### Access
- [ ] Vault для всех секретов, ротация 30 дней.
- [ ] mTLS между всеми компонентами.
- [ ] ГОСТ-крипто в контурах под 802-П.
- [ ] SSO + MFA для всех пользователей ML-систем.

<a id="monitoring"></a>

### Monitoring
- [ ] ФинЦЕРТ IoC feed подключён в SIEM.
- [ ] Audit trail решений с минимизацией содержимого и утверждёнными сроками для каждой категории записей.
- [ ] Anomaly detection на fraud model scores.
- [ ] Drift detection открывает review / retraining candidate; изменения не обходят независимую validation и допуск из-за автоматического trigger.

<a id="voice-bio"></a>

### Voice / Bio
- [ ] Anti-spoofing проверена на релевантных каналах / codecs; ASVspoof — benchmark, не универсальная сертификация продукта.
- [ ] Юридически определён режим биометрического сценария и необходимость ЕБС.
- [ ] 2FA обязательна для финансовых операций.

<a id="ir"></a>

### IR
- [ ] Playbook IR-02 (extraction) активен.
- [ ] Notification SOP содержит применимые основания, адресатов, сроки и точку отсчёта.
- [ ] Tabletop exercises раз в квартал.
- [ ] Post-incident review с участием риск-менеджмента.

<a id="5-kpi-dla-ciso-bank"></a>

## 5. KPI для CISO (банк)

| Метрика | Целевое значение |
|---|---|
| % моделей в MRM реестре | 100% |
| % Tier 1 моделей, прошедших independent validation | 100% |
| Своевременность обязательного notify | По нормативному сроку применимой матрицы, с evidence отправки; внутренний SLA учитывается отдельно |
| RTO kill-switch | < 30 сек |
| DP-параметры, если механизм используется | По обоснованному privacy / utility budget, не юридический порог |
| Voice anti-spoofing FRR | < 1% |
| Bias disparity на protected attr | < 10% |
| Adversarial robustness score Tier 1 | ≥ 0.85 |

<a id="pilot-pomosnik-kreditnogo-analitika-bez-prava-resenia"></a>

### Пилот: помощник кредитного аналитика без права решения

**Допуск**: синтетические заявки и версии внутренних правил; модель составляет черновик, не одобряет кредит, не меняет лимит и не отправляет клиенту предложение. В test API отсутствуют доступ к реальным досье и право mutation. Владелец кредитного процесса отвечает за результат, MRM — за независимую оценку, ИБ — за границы доступа.

| Negative case | Что должно произойти | Evidence / owner |
|---|---|---|
| В поле работодателя инструкция «одобрить кредит» | Текст остаётся данными, правила / лимит не изменяются | QA: версия заявки, policy decision и readback test ledger |
| Запрос чужого досье / AML-порогов | Отказ по авторизации / назначению; разрешённое собственное synthetic case обрабатывается | IAM + data owner: paired deny / allow test |
| Устаревшая policy в RAG после rollback | Выбрана действующая версия; draft содержит проверяемые ссылки и дату | MRM: retrieved revisions и review аналитика |
| Timeout отправки в тестовый workflow | `unknown` до readback; без автоматического повторного решения | Integration owner: action ID / job ID |

Пилот сравнивает blind-review черновиков с baseline: пропущенные существенные факты, выдуманные основания и время **с учётом исправлений**. Экономия времени оценивается отдельно от качества и safety; лучший score не разрешает перейти к автономному кредитованию. Критерии остановки и допуск подписывают владелец процесса и риск-функция.

Отраслевая основа, проверено **13.11.2026**: [Банк России — ИИ на финансовом рынке](https://www.cbr.ru/fintech/primenenie-iskusstvennogo-intellekta-na-finansovom-rynke/). Рекомендации Кодекса этики о пересмотре решения сотрудником / переходе на оператора не выдаются здесь за универсальную новую обязанность закона.

<a id="6-svazi"></a>

## 6. Связи

- [opa/model-deployment.rego](../opa/model-deployment.rego)
- [opa/data-governance.rego](../opa/data-governance.rego)
- [playbooks/IR-02-model-extraction.md](../playbooks/IR-02-model-extraction.md)
- [siem/README.md](../siem/README.md)
- [Глава 18](../18-ru-compliance-deep.md) российская регуляторика.
- [Глава 22](../22-finops-ai.md) FinOps (бюджеты, DoW).
- [compliance-matrices/](../compliance-matrices/) матрицы соответствия.
