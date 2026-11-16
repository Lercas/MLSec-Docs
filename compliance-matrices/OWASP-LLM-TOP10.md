<a id="matriza-sootvetstvia-owasp-top-10-for-llm-applications-2025"></a>

# Матрица соответствия: OWASP Top 10 for LLM Applications 2025

> Сопоставление десяти ключевых рисков LLM-приложений (OWASP LLM Top 10 v2025) с главами MLSec Recommendations, практиками и артефактами.

> **Редакционный статус, 13.11.2026:** ниже сохранена матрица именно редакции **2025** и её идентификаторы. Текущая публикация OWASP: [GenAI LLM Top 10 2026](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/). Матрица 2025 не является подтверждённым покрытием редакции 2026: при аудите фиксируйте версию и проверяйте изменения требований отдельно.

Проверено 13.11.2026: названия/ID ниже сверены с [официальным перечнем 2025](https://genai.owasp.org/llm-top-10/); публикация 2026 датирована 03.08.2026. Столбец «Практики» — наша трактовка, а не обязательные OWASP продукты / слои. Переход к кодам 2026 — в разделе [«Соответствие редакций 2025 → 2026»](#sootvetstvie-redakzij-2025-2026) ниже.

<a id="sootvetstvie-redakzij-2025-2026"></a>

## Соответствие редакций 2025 → 2026

Проверено 16.11.2026 по исходникам редакции 2026 в репозитории проекта: [перечень `2026/README.md`](https://github.com/GenAI-Security-Project/GenAI-LLM-Top10/blob/main/2026/README.md), [предисловие `LLM00_Preface.md`](https://github.com/GenAI-Security-Project/GenAI-LLM-Top10/blob/main/2026/final/LLM00_Preface.md) и [`LLM08_HiddenContextExposure.md`](https://github.com/GenAI-Security-Project/GenAI-LLM-Top10/blob/main/2026/final/LLM08_HiddenContextExposure.md). По предисловию OWASP в 2026 году ни одна категория не удалена и не добавлена: новые риски включены в существующие пункты, изменились порядок и одно название. Сам OWASP построчной таблицы перехода не публикует; соответствие ниже составлено нами по названиям и описаниям категорий.

| 2025 | 2026 | Что изменилось по тексту OWASP | Что пересмотреть в нашей оценке |
|------|------|-------------------------------|----------------------------------|
| LLM01:2025 Prompt Injection | LLM01:2026 Prompt Injection | Охват расширен на cross-modal атаки | Тесты injection через изображения, аудио и документы ([глава 26](../26-multimodal-cv-security.md)) |
| LLM02:2025 Sensitive Information Disclosure | LLM02:2026 Sensitive Information Disclosure | Без изменения позиции | — |
| LLM06:2025 Excessive Agency | LLM03:2026 Excessive Agency | Поднялась с 6-го на 3-е место | Приоритет контролей агентных действий в плане работ |
| LLM03:2025 Supply Chain | LLM04:2026 Supply Chain | Охватывает нарушение доверия при продвижении (promotion) артефакта модели | Admission и проверка подписанта при promotion ([глава 04](../04-stage2-model-operations.md)) |
| LLM04:2025 Data and Model Poisoning | LLM05:2026 Data and Model Poisoning | Включает подрыв fine-tuning | Контроль датасетов и конфигураций дообучения, LoRA/адаптеры |
| LLM10:2025 Unbounded Consumption | LLM06:2026 Unbounded Consumption | Поднялась на четыре позиции | Бюджеты и лимиты ([глава 22](../22-finops-ai.md)) |
| LLM09:2025 Misinformation | LLM07:2026 Misinformation | Новая позиция | — |
| LLM07:2025 System Prompt Leakage | LLM08:2026 Hidden Context Exposure | Переименована и расширена: кроме system prompt — инструкции разработчика, policy-текст из RAG/конфигураций/профилей, схемы tools и иные скрытые материалы контекста | Инвентаризировать всё, что приложение подкладывает в контекст; секреты и полномочия — вне контекста |
| LLM08:2025 Vector and Embedding Weaknesses | LLM09:2026 Vector and Embedding Weaknesses | Новая позиция | — |
| LLM05:2025 Improper Output Handling | LLM10:2026 Improper Output Handling | Опустилась с 5-го на 10-е место; охватывает небезопасный код, массово генерируемый ассистентами | Проверка сгенерированного кода ([глава 20](../20-code-assistants-security.md)); позиция в списке не снижает тяжесть уязвимостей класса XSS/SQLi |

Как пользоваться: коды 2025 в главах и таблице ниже переводятся в 2026 по этой таблице. Для трёх расширенных пунктов (LLM01, LLM04/05, LLM08:2026) одного переименования кода недостаточно: проверьте, покрывают ли ваши контроли новый охват. Место в рейтинге OWASP отражает распространённость и оценку сообщества, а не тяжесть конкретной уязвимости у вас.

<a id="tabliza-sootvetstvia"></a>

## Таблица соответствия

| ID | Риск | Главы | Практики | Артефакты |
|----|------|-------|----------|-----------|
| LLM01:2025 | **Prompt Injection** | [07](../07-red-teaming-testing-methods.md), [10](../10-llm-agent-protection.md), [12](../12-detection-protection-cicd-llm.md) | Разделение untrusted content / инструкций, независимая авторизация executor, input/output guardrails и adversarial tests; DLP — дополнительный сигнал, не гарантия от injection | [THREAT-MODEL-TEMPLATE](../templates/THREAT-MODEL-TEMPLATE.md), [TABLETOP-SCENARIOS сценарий 1](../templates/TABLETOP-SCENARIOS.md) |
| LLM02:2025 | **Sensitive Information Disclosure** | [03](../03-stage1-data-operations.md), [12](../12-detection-protection-cicd-llm.md), [18](../18-ru-compliance-deep.md) | Data minimization, scoped DLP, document/session ACL и output controls; DP только с определённым механизмом / accounting; в логах metadata и redaction вместо raw detected_value | [PIA-TEMPLATE](../templates/PIA-TEMPLATE.md), [RKN-152FZ](../templates/regulator-notifications/RKN-152FZ.md) |
| LLM03:2025 | **Supply Chain** | [04](../04-stage2-model-operations.md), [05](../05-stage3-model-deployment.md), [14](../14-model-risk-governance.md) | AI-BOM, pinned base/adapter/tokenizer/runtime, verified provenance / signer / subject и admission; безопасная сериализация ограничивает code loading, но не доказывает отсутствие backdoor | [AI-BOM-EXAMPLE.json](../templates/AI-BOM-EXAMPLE.json), [TABLETOP-SCENARIOS сценарий 3](../templates/TABLETOP-SCENARIOS.md) |
| LLM04:2025 | **Data and Model Poisoning** | [03](../03-stage1-data-operations.md), [04](../04-stage2-model-operations.md), [07](../07-red-teaming-testing-methods.md), [05](../05-stage3-model-deployment.md) | Provenance / permitted use, quarantine→promotion, независимый holdout, preprocessing/split manifests, poisoning tests и отзыв; подпись / checksum подтверждают конкретные байты, не чистоту данных | [TABLETOP-SCENARIOS сценарий 2](../templates/TABLETOP-SCENARIOS.md) |
| LLM05:2025 | **Improper Output Handling** | [10](../10-llm-agent-protection.md), [12](../12-detection-protection-cicd-llm.md) | Schema validation + независимые authorization / destination checks; context-aware HTML escaping, parameterized SQL, безопасные tool arguments. Валидный JSON ещё не безопасен для исполнения | [THREAT-MODEL-TEMPLATE](../templates/THREAT-MODEL-TEMPLATE.md) |
| LLM06:2025 | **Excessive Agency** | [10](../10-llm-agent-protection.md), [14](../14-model-risk-governance.md) | Least privilege, scoped delegation и approvals по action+args, sandbox/egress, idempotency и stop/revoke для очередей / retries; проверить фактический внешний эффект | [AI-USE-POLICY-TEMPLATE](../templates/AI-USE-POLICY-TEMPLATE.md) раздел 6.2 |
| LLM07:2025 | **System Prompt Leakage** | [10](../10-llm-agent-protection.md), [12](../12-detection-protection-cicd-llm.md) | Не хранить secrets / authority в system prompt; server-side policy и credentials вне model context. Prompt confidentiality / pattern filters — вспомогательные меры, обфускация не граница доверия | [THREAT-MODEL-TEMPLATE](../templates/THREAT-MODEL-TEMPLATE.md) |
| LLM08:2025 | **Vector and Embedding Weaknesses** | [03](../03-stage1-data-operations.md), [10](../10-llm-agent-protection.md) | Серверный tenant scope, document ACL до retrieval и перед выдачей, freshness / revoke для cache/memory, индекс только из допущенных источников; embeddings не считаются анонимными по умолчанию | [AI-BOM-EXAMPLE.json](../templates/AI-BOM-EXAMPLE.json) (rag-knowledge-base@1.5) |
| LLM09:2025 | **Misinformation** | [07](../07-red-teaming-testing-methods.md), [10](../10-llm-agent-protection.md), [12](../12-detection-protection-cicd-llm.md) | Проверка утверждений и доступности подтверждающего источника, abstention, domain-specific evaluation / human review. Citation и provenance не доказывают истинность | [TABLETOP-SCENARIOS сценарий 1](../templates/TABLETOP-SCENARIOS.md) |
| LLM10:2025 | **Unbounded Consumption** | [12](../12-detection-protection-cicd-llm.md), [14](../14-model-risk-governance.md) | Общий run/team budget, reservation/reconciliation, retries/subagents/batch, tool/CPU/time caps, отмена и reconciliation внешних расходов; rate limit по IP недостаточен | [TABLETOP-SCENARIOS сценарий 5](../templates/TABLETOP-SCENARIOS.md) |

<a id="svodnaa-karta-predlagaemyh-svazej"></a>

## Сводная карта предлагаемых связей

| Компонент методики | Связанные риски 2025; требует evidence |
|--------------------|---------------------|
| Gateway / DLP как часть системы контролей | LLM01, LLM02, LLM05, LLM07, LLM09, LLM10 |
| AI-BOM + cosign + SLSA | LLM03, LLM04 |
| RAG tenant isolation + ACL | LLM02, LLM08 |
| Agent sandbox + HITL | LLM06 |
| Red teaming (Garak, PyRIT) | LLM01, LLM04, LLM09 |
| Budget + rate limit | LLM10 |

<a id="gap-analiz-dla-organizazii"></a>

## Gap-анализ для организации

Для каждого риска сначала задать asset, actor capability и attack path; затем выбрать контроль и проверить его. Количество установленных компонентов не показывает долю закрытых атак. Пример оформления:

| LLM ID | Реализовано | В работе | Не покрыто | Комментарий |
|--------|:-----------:|:--------:|:----------:|-------------|
| LLM01 | | | | |
| LLM02 | | | | |
| ... | | | | |

<a id="proveraemoe-evidence-i-ostavsiesa-aspekty"></a>

## Проверяемое evidence и оставшиеся аспекты

| ID источника 2025 | Наш пример применения / контроль | Positive + negative / failure evidence | Что не закрыто этим тестом |
|---|---|---|---|
| LLM01 / LLM06 | Внешний документ просит отправить CRM-выгрузку через tool; executor проверяет ресурс/получателя | Разрешённый запрос проходит; injected документ / изменённый recipient / expired queued grant отвергнуты; нет внешнего receipt / egress | Другие tools, alternate provider и delayed side effect требуют отдельной проверки |
| LLM02 / LLM08 | Отзыв document access распространяется на index, cache, memory | Сначала разрешённое чтение, затем revoke; stale ACL, cache hit, session reuse и restore не раскрывают canary | Ни этот тест, ни DLP не оценивают memorization обученных весов |
| LLM03 / LLM04 | Допускается только approved dataset + целый model bundle | Неверный subject/signer, revoked corpus, изменённый adapter и contaminated holdout не получают прежний pass | Подлинный подписанный source может содержать poisoning |
| LLM05 / LLM07 | Модельный output не задаёт policy / credentials | Корректный JSON с запрещённым resource ID отвергнут; prompt leakage не раскрывает secrets, которых в prompt нет | Проверить downstream SQL/HTML/tool sinks отдельно |
| LLM09 / LLM10 | Пользовательская корректность и расходы измеряются независимо | Unsupported citation вызывает отказ/review; retry/tool/subagent budget не превышается при concurrency и timeout | Экономия tokens не доказывает customer utility |

Для каждого отчёта фиксируются source edition, target digest, corpus/tool/policy revisions, тестовая среда, reviewer и blind spots. Новую модель нельзя признать покрытой отчётом со старым именем endpoint. Практика evidence: [01 §3.4–3.6](../01-overview-architecture.md), [16](../16-ml-attacks-rag-multimodal.md), [24](../24-vector-db-security.md), [22](../22-finops-ai.md), [33](../33-ai-agents-security-overlay.md).

**Переход 2025→2026:** создать отдельную запись source edition; сравнить текст и границы риска, затем заново связать attack paths / evidence. Сохранить прежний 2025 ID у старых отчётов. Если текст 2026 не проверен, статус новой связи `unmapped`, даже когда название выглядит знакомым. Ни номер, ни статус реализации автоматически не наследуются.

<a id="sm-takje"></a>

## См. также

- [OWASP Top 10 for LLM Applications 2025 (историческая редакция матрицы)](https://genai.owasp.org/llm-top-10/)
- Глава [07. Red Teaming](../07-red-teaming-testing-methods.md)
- Глава [12. Detection/Protection (Gateway and DLP)](../12-detection-protection-cicd-llm.md)
- [MITRE-ATLAS.md](MITRE-ATLAS.md) - пересекается по тактикам атак
