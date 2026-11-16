<a id="model-card-sablon"></a>

# Model Card. Шаблон

> Шаблон Model Card для ML/AI-модели. Совместим с требованиями EU AI Act (ст. 11, 13, Annex IV), NIST AI RMF (Map, Measure), ISO/IEC 42001 (п. 8.4). Заполните все разделы; при неприменимости укажите «неприменимо» с обоснованием. Model Card обновляется при каждом новом релизе модели и подписывается ML Tech Lead и MLSec Analyst.

---

<a id="1-identifikazia-modeli"></a>

## 1. Идентификация модели

| Поле | Значение |
|---|---|
| Название модели | {MODEL_NAME} |
| Идентификатор | {MODEL_ID} |
| Версия | {VERSION} |
| Хеш артефакта (SHA-256) | {SHA256} |
| Подпись (Sigstore/cosign) | {COSIGN_REF} |
| Tier (1-4) | {TIER} |
| Классы данных (K0-K4) | {DATA_CLASSES} |
| Владелец (команда) | {OWNER_TEAM} |
| ML Tech Lead | {ML_LEAD} |
| MLSec Analyst (ревьюер) | {MLSEC_REVIEWER} |
| DPO (если в scope ПДн) | {DPO} |
| Дата создания | {YYYY-MM-DD} |
| Дата последнего ревью | {YYYY-MM-DD} |
| Следующее плановое ревью | {YYYY-MM-DD} |
| Репозиторий | {REPO_URL} |
| Реестр моделей | {REGISTRY_URL} |

---

<a id="2-naznacenie-i-oblast_-primenenia"></a>

## 2. Назначение и область применения

- **Задача**: {классификация / регрессия / генерация текста / генерация изображений / эмбеддинги / RAG / агент / рекомендации / иное}.
- **Бизнес-назначение**: {зачем модель нужна, какой бизнес-процесс обслуживает}.
- **Целевая аудитория**: {внутренние сотрудники / клиенты B2C / клиенты B2B / API для партнёров / иное}.
- **Область применения (разрешённая)**: {конкретные use-case}.
- **Область НЕ применения (запрещено)**: {use-case, которые прямо запрещены, см. AI Use Policy}.
- **Категория EU AI Act**: {минимальный риск / ограниченный риск / высокорисковая / запрещённая / GPAI}.
- **High-risk по Annex III**: {да/нет, какая категория}.
- **Применимость в ЕС-юрисдикции**: {да / нет / частично}.

---

<a id="21-pasport-szenaria-i-granizy-dopuska"></a>

### 2.1. Паспорт сценария и границы допуска

Заполняйте по сценарию, а не переносите общий допуск базовой модели на все её применения. Ссылки на существующие registry/runbook достаточны; повторять их содержимое здесь не нужно.

| Поле | Значение |
|------|----------|
| Scenario ID / версия / владелец | {SC-… / revision / команда} |
| Вход → выход → внешний эффект | {обращение → черновик → отправки нет без отдельного подтверждения} |
| Принципал и предел делегации | {tenant/user/service; инструменты, ресурсы, лимиты, срок} |
| Контракт release bundle | {model/provider revision + adapter + tokenizer + prompt + tool schema + policy revisions} |
| Допуск / evidence | {verified / pending / failed; ссылка на тест этого bundle; дата} |
| Неизвестные сведения провайдера | {например, digest API-весов недоступен; provider ID зафиксирован; кто принимает ограничение} |

**Синтетический пример:** `SC-SUPPORT-DRAFT-01/2.1`: модель составляет черновик, но не выбирает дополнительные CRM-поля и не отправляет письмо сама. Разрешение `crm.read` ограничено tenant и тикетом; `mail.send` выполняет backend после проверки конкретного approval. Fallback на другого провайдера требует проверки той же tool schema, передачи данных и качества; это не автоматическое наследование допуска. Для code-agent дополнительно укажите границы checkout/setup/hooks и отдельную identity публикации ([20](../20-code-assistants-security.md)).

<a id="3-arhitektura-modeli"></a>

## 3. Архитектура модели

- **Тип архитектуры**: {Transformer / CNN / RNN / Gradient Boosting / Linear / Ensemble / LLM fine-tune / LoRA / RAG-pipeline / иное}.
- **Base model (если fine-tune / LoRA)**: {название + версия + источник (HF ID, собственная)}.
- **Base model hash + подпись**: {SHA-256 + cosign ref}.
- **Параметры (число, активные)**: {total / active}.
- **Контекст (tokens)**: {context window, если LLM}.
- **Размер артефакта**: {MB / GB}.
- **Формат**: {SafeTensors / ONNX / PyTorch .pt / TF SavedModel / иное}.
- **Адаптеры**: {список LoRA / adapter модулей с хешами}.
- **Embeddings (если используются)**: {модель + размерность + индекс в vector DB}.
- **Промпт-шаблон (если LLM)**: {версия, ссылка на prompt registry}.

---

<a id="4-dannye-obucenia"></a>

## 4. Данные обучения

| Поле | Значение |
|---|---|
| Датасет(ы) | {название, версия, хеш} |
| Источники | {корпоративные / публичные / партнёрские / синтетика} |
| Классы данных | {K0-K4 по каждому источнику} |
| Объём обучающей выборки | {количество примеров / токенов} |
| Объём валидационной | {количество} |
| Объём тестовой | {количество} |
| PII присутствует | {да/нет, если да: как обработано} |
| Анонимизация применялась | {Presidio / Natasha / k-anonymity / DP / иное} |
| Правовое основание (ПДн) | {согласие / законный интерес / договор / 152-ФЗ ст. 6} |
| DPIA проведена | {да/нет, ссылка} |
| Период сбора данных | {YYYY-MM-DD : YYYY-MM-DD} |
| Географический охват | {РФ / СНГ / ЕС / глобальный / иное} |
| Языки | {ru / en / multi} |
| Data Card ссылка | {ссылка на DATA-CARD.md каждого датасета} |
| Data lineage | {OpenLineage / Marquez / ручная схема} |
| Проверка на poisoning | {да/нет, метод, дата} |

---

<a id="5-prozess-obucenia"></a>

## 5. Процесс обучения

- **Дата запуска обучения**: {YYYY-MM-DD}.
- **Окружение**: {контейнер, базовый образ + хеш, К8s namespace, isolation level}.
- **Вычислительный ресурс**: {GPU type, количество, часы, суммарная энергозатратность}.
- **Фреймворк**: {PyTorch X.Y / TF X.Y / JAX / иное}.
- **Гиперпараметры ключевые**: {lr, batch size, epochs, optimizer, scheduler}.
- **Adversarial training применён**: {да/нет, метод (FGSM/PGD/TextAttack), детали}.
- **Fine-tune технология (если)**: {full / LoRA / QLoRA / DoRA / иное}.
- **Data augmentation**: {да/нет, какое}.
- **Seed**: {random seed}.
- **Воспроизводимость**: {да/нет, условия}.
- **Код обучения**: {ссылка на commit в репозитории}.
- **Артефакт commit**: {git SHA кода, использованного для обучения}.

---

<a id="6-metriki-kacestva"></a>

## 6. Метрики качества

<a id="61-bazovye-metriki"></a>

### 6.1. Базовые метрики

| Метрика | Train | Validation | Test | Baseline / целевое |
|---|---|---|---|---|
| Accuracy | | | | |
| Precision | | | | |
| Recall | | | | |
| F1 | | | | |
| AUC-ROC | | | | |
| MAE / MSE | | | | |
| BLEU / ROUGE / BERTScore | | | | |
| Perplexity (LLM) | | | | |
| Custom business metric | | | | |

<a id="62-slice-analysis-po-segmentam"></a>

### 6.2. Slice analysis (по сегментам)

| Сегмент | Метрика | Значение | Комментарий |
|---|---|---|---|
| {по возрастным группам} | | | |
| {по гео} | | | |
| {по полу} | | | |
| {по языку} | | | |

<a id="63-bias-i-fairness-dla-modelej-o-ludah"></a>

### 6.3. Bias и Fairness (для моделей о людях)

| Метрика | Значение | Порог | Результат |
|---|---|---|---|
| Statistical Parity Difference | | < 0.10 | {pass/fail} |
| Equal Opportunity Difference | | < 0.10 | {pass/fail} |
| Disparate Impact | | 0.8-1.25 | {pass/fail} |
| Average Odds Difference | | < 0.10 | {pass/fail} |

Инструмент: {Fairlearn / AI Fairness 360 / Aequitas}. Отчёт: {ссылка}.

---

<a id="7-bezopasnost_-i-ustojcivost_"></a>

## 7. Безопасность и устойчивость

<a id="71-adversarial-testing"></a>

### 7.1. Adversarial testing

| Атака | Метод | Параметры | Успешность атаки (ASR) | Порог | Результат |
|---|---|---|---|---|---|
| FGSM | ε=0.03 | | | < 20% | {pass/fail} |
| PGD | ε=0.03, k=40 | | | < 30% | {pass/fail} |
| C&W | | | | < 25% | {pass/fail} |
| TextAttack (BERT) | | | | < 30% | {pass/fail} |
| DeepFool | | | | | {pass/fail} |

Инструмент: {ART / TextAttack / Counterfit}. Отчёт: {ссылка}.

<a id="72-red-teaming-dla-llm-agentov"></a>

### 7.2. Red Teaming для LLM / агентов

| Категория | Тест-суит | Количество атак | Success rate | Порог | Результат |
|---|---|---|---|---|---|
| Prompt injection (прямой) | Garak / Promptfoo | | | < 5% | {pass/fail} |
| Prompt injection (косвенный) | кастомный | | | < 10% | {pass/fail} |
| Jailbreak | Garak DAN / Skeleton Key / Crescendo / Many-Shot | | | < 5% | {pass/fail} |
| Data extraction | Garak / кастомный | | | 0 | {pass/fail} |
| System prompt leak | Garak / кастомный | | | < 2% | {pass/fail} |
| Toxic output | PyRIT | | | < 1% | {pass/fail} |
| Bias exploitation | PyRIT | | | < 2% | {pass/fail} |
| Hallucination (factuality) | TruthfulQA / кастомный | | | < 10% | {pass/fail} |
| Regurgitation (обучающих данных) | кастомный | | | 0 | {pass/fail} |
| Agentic: нарушение HITL | кастомный | | | 0 | {pass/fail} |
| Agentic: tool misuse | кастомный | | | 0 | {pass/fail} |
| Agentic: infinity loop | кастомный | | | 0 | {pass/fail} |

Инструменты: {Garak / PyRIT / Promptfoo / HiddenLayer AIShield}. Отчёт: {ссылка}.

<a id="73-privacy-ataki"></a>

### 7.3. Privacy-атаки

| Атака | Метод | ASR | Результат |
|---|---|---|---|
| Membership Inference | ART MIA / shadow models | | {pass/fail} |
| Model Inversion | ART | | {pass/fail} |
| Model Extraction (через API) | ART / кастомный | | {pass/fail} |
| Attribute Inference | ART | | {pass/fail} |

---

<a id="74-orakul-effekta-i-uslovia-vosproizvedenia"></a>

### 7.4. Оракул эффекта и условия воспроизведения

Числа в таблицах выше — примеры внутренних порогов, не универсальные нормативы. Зафиксируйте свой порог до запуска и храните рядом baseline легитимных задач. Для каждого теста: `test_id`, bundle/dataset revisions, принципал и начальное состояние, попытка, **наблюдаемый запрещённый эффект**, результат, owner, evidence_ref. Ответ модели и статус guardrail — вспомогательные сигналы; для действий проверяйте состояние целевой системы, outbox/egress и фоновые jobs. Неизвестный outcome — `inconclusive`, не `pass`.

| Синтетическая проверка | Успех защиты подтверждает | Что не считается доказательством |
|-------------------------|---------------------------|---------------------------------|
| Подмена адресата после approval | Backend отклонил изменённый action digest; mock-mailbox пуст | Фраза «отправка запрещена» |
| RAG-документ просит выгрузить соседний tenant | ACL запретил чтение; в retrieval/cache и egress нет чужих данных | Только нулевой ASR по текстовым ответам |
| Тайм-аут при списании бюджета | Readback/idempotency показывает один эффект и учтённые расходы | Слепой повтор операции после timeout |

Для неприменимых атак укажите причину (`N/A: сервис не обучает модель и не публикует weights`), а не нулевой риск. Методики — [04](../04-stage2-model-operations.md), [07](../07-red-teaming-testing-methods.md), [33](../33-ai-agents-security-overlay.md).

<a id="8-poverhnost_-atak-i-trust-boundaries"></a>

## 8. Поверхность атак и trust boundaries

- **Источник входных данных**: {untrusted user input / trusted internal / hybrid}.
- **Trust boundary**: {опишите границы trust, см. главу 09 Threat Modeling}.
- **Внешние зависимости**: {LLM-провайдер / vector DB / MCP tools / cloud API}.
- **Действия, которые модель может инициировать**: {только ответ / запись в БД / внешний API / платежи / отправка писем / иное}.
- **HITL требуется для**: {список необратимых операций}.
- **Lethal Trifecta присутствует**: {да/нет, митигация}.

---

<a id="9-guardrails-i-runtime-zasita"></a>

## 9. Guardrails и runtime защита

- **Gateway**: {LLM Gateway / прямой доступ / иное}.
- **Pre-call DLP**: {Regex / Presidio / LLM-classifier / корпоративные patterns}.
- **Post-call DLP / анти-эхолик**: {да/нет, детали}.
- **Guardrails**: {NeMo Guardrails / LlamaFirewall / Guardrails AI / Invariant}.
- **Rate limit**: {per user / per team, конкретные значения}.
- **Budget / per-request cost cap**: {значение}.
- **Kill-switch уровни поддержаны**: {L0/L1/L2/L3/L4}.
- **Аудит-логирование**: {OTel GenAI / собственный формат, ретенция}.

---

<a id="10-razvertyvanie"></a>

## 10. Развёртывание

- **Окружение**: {dev / staging / prod}.
- **Cloud / on-prem**: {AWS / GCP / Azure / Yandex Cloud / Сбер / Selectel / on-prem}.
- **Регион**: {для ПДн: только РФ по 242-ФЗ}.
- **Serving**: {KServe / vLLM / TGI / Triton / собственный}.
- **SLA (latency p50 / p95 / p99)**: {ms}.
- **SLO (uptime)**: {%}.
- **Canary-стратегия**: {да/нет, % трафика, критерии rollback}.
- **Rollback-версия**: {ссылка на предыдущую Model Card}.

---

<a id="11-monitoring-v-produktive"></a>

## 11. Мониторинг в продуктиве

- **Метрики производительности**: {Prometheus / OTel, список ключевых метрик}.
- **Дрифт (данных)**: {Evidently AI / WhyLogs, частота, пороги}.
- **Дрифт (концептуальный)**: {метод, частота, пороги}.
- **Quality drift detection**: {да/нет, метод}.
- **Переаттестация**: {периодичность, ответственный, критерии}.
- **SIEM-интеграция**: {ELK / MaxPatrol / KUMA / QRadar}.
- **Обратная связь**: {human feedback / thumbs up/down / incident tickets}.

---

<a id="111-izmenenie-otzyv-i-retirement"></a>

### 11.1. Изменение, отзыв и retirement

| Триггер | Решение владельца / evidence |
|---------|----------------------------|
| Новый provider, регион, retention или subcontractor | Пересмотреть PIA/контракт и разрешённые классы данных до переключения |
| Новые права tool, prompt/tool schema, adapter или corpus | Повторить затронутые quality/security-тесты; указать совместимый rollback bundle |
| Отзыв подписи/лицензии, supply-chain alert | Найти зависимые scenario_id по AI-BOM, остановить новые задания, проверить уже запущенные |
| Снятие модели/сценария | {owner/date}; отозвать credentials/delegations, остановить очереди, проверить provider/cache/index copies и retention exceptions |

Для retirement храните ссылку на readback отзыва и закрытия задач, а не только заявку. Для rollback укажите доступность старого провайдера и совместимость схемы; отключённая модель не возвращается автоматически при ошибке новой. Бюджет, лимиты retry и незавершённые платные jobs учитываются отдельно ([22](../22-finops-ai.md), [34](../34-ai-agents-runtime-procedure.md), [35](../35-ai-agents-incident-playbook.md)).

<a id="12-ogranicenia-i-izvestnye-problemy"></a>

## 12. Ограничения и известные проблемы

- **Известные ограничения**: {список}.
- **Not in scope**: {что модель НЕ делает хорошо}.
- **Известные ошибки**: {трекер + ID}.
- **Известные bias**: {перечень, митигация, остаточный риск}.
- **Устаревание знаний (для LLM)**: {cutoff date, актуализация через RAG / дообучение}.

---

<a id="13-compliance-i-regulatorika"></a>

## 13. Compliance и регуляторика

- **EU AI Act**: {классификация, обязательства, ст. 11 documentation status}.
- **152-ФЗ**: {применимо / неприменимо, ссылка на DPIA / реестр обработки}.
- **187-ФЗ (КИИ)**: {применимо / неприменимо, категория}.
- **242-ФЗ (локализация)**: {выполняется / требуется миграция}.
- **716-П (Банк России)**: {для финсектора}.
- **GDPR**: {применимо если ЕС-пользователи, DPIA, ссылка}.
- **NIST AI RMF maturity**: {Govern / Map / Measure / Manage статус}.
- **ISO/IEC 42001**: {в scope AIMS / вне scope}.
- **MITRE ATLAS mapping**: {применимые техники + митигации}.
- **OWASP LLM Top 10 2025**: {анализ каждого пункта или N/A}.
- **OWASP Agentic Top 10 (для агентов)**: {ASI01-10 mapping}.

---

<a id="14-prozracnost_-dla-pol_zovatelej-eu-ai-act-st-13"></a>

## 14. Прозрачность для пользователей (EU AI Act ст. 13)

- **Уведомление о взаимодействии с AI**: {как реализовано}.
- **Watermarking сгенерированного контента**: {да/нет, метод: C2PA / SynthID / иное}.
- **Право на human review**: {как реализовано}.
- **Канал обратной связи**: {email / форма / тикет-система}.

---

<a id="15-sign-off"></a>

## 15. Sign-off

| Роль | Имя | Дата | Статус |
|---|---|---|---|
| ML Tech Lead | | | {approved / conditional / rejected} |
| MLSec Analyst | | | |
| Product Owner | | | |
| DPO (если ПДн) | | | |
| ML SecOps Board | | | |
| AI Risk Committee (для Tier 1) | | | |

---

<a id="16-istoria-versij"></a>

## 16. История версий

| Версия | Дата | Автор | Ключевые изменения |
|---|---|---|---|
| 1.0 | | | первоначальный релиз |
| | | | |

---

<a id="17-ssylki"></a>

## 17. Ссылки

- Репозиторий кода: {URL}
- Реестр моделей: {URL}
- Data Card(ы): {URL}
- Threat Model: {URL}
- DPIA: {URL}
- AI-BOM (CycloneDX): {URL}
- Отчёты тестирования: {URL}
- Runbook для SOC: {URL}

---

*Шаблон v1.2, обновлён 13.11.2026. Связан с [главой 01](../01-overview-architecture.md), [главой 04](../04-stage2-model-operations.md), [главой 09](../09-threat-modeling.md), [главой 14](../14-model-risk-governance.md).*
