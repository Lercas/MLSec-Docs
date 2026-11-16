<a id="mlsec-executive-summary"></a>

# MLSec Executive Summary

> Актуализировано 13.11.2026: применимость, пилот, evidence и экономика. Числа бюджета — учебный сценарий, не предложение цены / данные компании. PPTX/XLSX не обновлялись и не подтверждают эту редакцию Markdown.


> **Версия**: 1.1 · **Дата**: 2026-05-29 · **Длина**: 3-5 страниц

<a id="1-pocemu-sejcas"></a>

## 1. Почему сейчас

AI может участвовать в customer support, fraud detection, рекомендациях, code assistants и внутренних процессах. Inventory устанавливает, что реально работает в конкретной компании, какие данные читает и какие действия выполняет. Правовые требования проверяются по роли / обработке / объекту:
- **EU AI Act**: запрещённые практики — с 2 фев. 2025; обязательства для GPAI — с 2 авг. 2025; transparency Art. 50 и enforcement-полномочия по GPAI — с 2 авг. 2026; high-risk Annex III — с 2 дек. 2027, Annex I — с 2 авг. 2028 (Omnibus действует с 27.07.2026).
- **Россия, ЦБ 716-П**: управление операционным риском в применимом субъектном scope. Реестр моделей и independent validation — предлагаемые внутренние MRM-контроли, не универсальное требование «гл. 5 про AI».
- **152-ФЗ ст. 21 ч. 3.1**: при событии, подпадающем под эту часть, уведомление РКН в течение 24 часов и результаты расследования в течение 72 часов с установленного законом момента; это не уведомление субъектов и не любой DLP alert. Применимость — [18](../18-ru-compliance-deep.md).
- **187-ФЗ / Приказ ФСТЭК 239**: значимые объекты КИИ с AI.
- **Маркировка контента**: определить применимый опубликованный акт / пункт и тип контента. Неподтверждённая дата законопроекта не используется как действующая обязанность; EU Art. 50 и C2PA рассматриваются отдельно.

Приоритет определяют конкретные exposure, требования и impact. Сроки закона не являются прогнозом неизбежного инцидента или величины санкции.

<a id="2-pat_-kategorij-riska-aiml"></a>

## 2. Пять категорий риска AI/ML

**Классы рисков, которые команды ИБ часто недооценивают**:

1. **Неразрешённая передача данных**. Сотрудник отправляет внутренний документ внешнему AI-провайдеру. Training, retention, feedback и субподрядчики зависят от продукта / договора / настроек; передача не означает автоматическое обучение. Например, [Anthropic commercial policy](https://privacy.claude.com/en/articles/7996868-is-my-data-used-for-model-training) различает default и добровольно переданные feedback данные (проверено 13.11.2026). Это не разрешение отправлять любые данные.
2. **Prompt injection и jailbreak**. Пользователь скрывает инструкцию в input или во внешнем документе, LLM исполняет → утечка system prompt, обход контроля, опасные действия.
3. **Supply chain моделей**. Pretrained модель с backdoor, подмена в CI/CD, неподписанный artifact.
4. **Agent breach**. Autonomous AI-агент (типа Replit Agent) выполняет опасное действие (удаление БД, коммит prod-ключей, транзакция без утверждения).
5. **Compliance пробел**. Проверить применимость правил исключительно автоматизированных решений и существенных последствий: GDPR Art. 22 / 152-ФЗ ст. 16 не сводятся к одному explanation и не запрещают любое рекомендательное применение.

Эти категории — краткая карта для руководителя, не полная таксономия и не взаимно исключающие причины потерь.

<a id="3-standartnye-kontroli-i-zacem"></a>

## 3. Стандартные контроли и зачем

**Data layer**:
- Классификация K0-K4 для всех ML-датасетов.
- Privacy review по разрешённой обработке; DP — при подходящей задаче, с механизмом, adjacency и privacy accounting. Внутренний K3 не задаёт универсальную обязанность DP.
- Data Card и audit trail.

**Model layer**:
- Реестр моделей (MRM) с классификацией рисков Tier 1–4.
- Cosign подписи и Sigstore Model Transparency.
- SBOM и ML-BOM.
- Независимые behavioral / bias evaluation в CI; scanner не гарантирует отсутствие backdoor.
- Adversarial testing (ART), fairness evaluation (Fairlearn) и red team (garak, promptfoo) по согласованному scope.

**Runtime**:
- Единый LLM-gateway (Rilio или аналог).
- DLP pre-call и post-call (Presidio) и injection-сканер (LlamaFirewall или Lakera).
- Валидированные фильтры prompt attacks и контроль раскрытия контекста; canary / совпадения — частичные сигналы, tool / renderer / egress проверяются отдельно.
- Rate limit и budget cap (FinOps).
- Stop/revoke с согласованным RTO, проверкой active / queued / retry paths и reconciliation внешних эффектов.

**Policy**:
- OPA / Rego для deployment и runtime access.
- Gatekeeper в Kubernetes.
- Ежеквартальный compliance drill.

**Observability**:
- SIEM rules для ML-specific сигналов (Sigma/SPL/KUMA).
- OpenTelemetry GenAI semantic conventions.
- Dashboards с DLP, drift, cost, safety.

**IR**:
- 5 playbook-ов под типы инцидентов (extraction, injection, agent breach, shadow AI, general).
- Tabletop раз в квартал.
- Notification SOP (РКН 24ч первичное + 72ч результаты расследования, ФинЦЕРТ, НКЦКИ/ГосСОПКА).

<a id="4-cto-my-predlagaem-vnedrit_-roadmap-na-12-mesazev"></a>

## 4. Что мы предлагаем внедрить (roadmap на 12 месяцев)

<a id="q1-fundamental-visibility"></a>

### Q1: Fundamental visibility
- Реестр моделей (MRM) с классификацией рисков.
- Data classification и Data Card шаблоны.
- Выбранная точка enforcement и отдельная проверка обходных маршрутов / Shadow AI.
- Базовые SIEM rules (Sigma).
- Kill-switch L0-L4.
- **Выход**: учтённый scope use cases, проверенный enforcement / stop и явные blind spots.

<a id="q2-gate-signing"></a>

### Q2: Gate + signing
- OPA policy для deployment (model / data / supply chain).
- Cosign подписи + internal Sigstore MT.
- SBOM и ML-BOM в CI.
- Adversarial + bias suite автоматически.
- Prompt registry и PromptOps.
- **Выход**: проверен допуск выбранного scope; обходы через admin/batch/fallback и emergency paths тестируются отдельно.

<a id="q3-hardening-i-zero-trust"></a>

### Q3: Hardening и zero-trust
- Vector DB security (RLS, encrypted payload, BYOK).
- mTLS для всех ML-сервисов.
- Vault для секретов.
- PET по threat model и разрешённой обработке; DP — только с заданным механизмом / accounting.
- Voice / multimodal защита (если применимо).
- **Выход**: проверенные сценарии supply chain / lateral access и документированные gaps.

<a id="q4-continuous-i-compliance"></a>

### Q4: Continuous и compliance
- Регулярный red team в изолированной среде; production-проверки только в согласованном scope.
- Tabletop exercises раз в квартал.
- Маркировка / C2PA 2.5 там, где применимо; отдельно проверяются integrity, trust и disclosure.
- Compliance audits (ФСТЭК, ЦБ, DPIA).
- MLSec Capability Assessment: baseline и target по проверяемым контролям / gaps.
- **Выход**: наблюдаемые контроли и evidence для применимого audit scope; полнота проверяется отдельно.

<a id="5-investizii-ucebnyj-primer"></a>

## 5. Инвестиции (учебный пример)

| Категория | Q1 | Q2 | Q3 | Q4 | Итого |
|---|---|---|---|---|---|
| Инструменты (open-source + commercial) | 8-12 | 7-12 | 5-10 | 5-10 | **25-44** |
| Inhouse команда (2 MLSec FTE) | 5 | 5 | 5 | 5 | **20** |
| Обучение (AI Literacy, OWASP LLM Top 10, MITRE ATLAS) | 2 | 1 | 1 | 1 | **5** |
| Audit / certification | 2 | 3 | 3 | 4 | **12** |
| Red team / pentest | 1 | 2 | 2 | 3 | **8** |
| **Итого, млн руб** | **18-22** | **18-23** | **16-21** | **18-23** | **70-89** |

Суммы — авторский пример планирования, не рыночный benchmark и не расчёт от порога выручки. Q1–Q4 означают кварталы с начала согласованной программы. 70–89 млн руб — до резерва; при условных 10% резерва итог 77–97,9 млн руб. Реальный бюджет включает интеграцию, вычисления, tools, поддержку, review и лицензии без двойного учёта FTE.

<a id="6-vozvrat-investizij-ozenka-otdel_no-ot-rezul_tata"></a>

## 6. Возврат инвестиций: оценка отдельно от результата

**Измеримая польза:** принятые бизнес-задачи, время пользователя и исправлений, качество и полная стоимость результата. Сравнивать с текущим процессом / non-AI вариантом на сопоставимой выборке; сокращение tokens не равно экономии бизнеса. Высвобождённое время не становится cash saving без подтверждённого использования ресурса.

**Сценарные потери:** диапазоны частоты / ущерба до и после контроля с источником и уверенностью. Штраф требует применимого состава и условий; максимальная санкция не является ожидаемой потерей, а чужой deepfake-кейс не задаёт вероятность для компании. Один инцидент с fraud, leak и downtime нельзя трижды прибавить как независимые убытки.

**Пилот и решение:** до запуска зафиксировать candidate/baseline revisions, budget cap, duration, population и критерии. Отдельно показать API/protocol, correctness/policy, operations и customer utility. Safety или обязательный правовой fail блокирует расширение независимо от экономии. При отсутствии подтверждённой пользы — доработка / остановка, а не автоматически успешное внедрение.

Методика и ограничения: [roi-calculator.md](roi-calculator.md). Существующий [XLSX](roi-calculator.md) не обновлён; его формулы / результат не являются проверкой новой методики.

<a id="7-klucevye-resenia-dla-soveta"></a>

## 7. Ключевые решения для совета

1. **Назначить ответственность и независимый review**: отделить создание системы от принятия её risk/evaluation решений, не предписывая всем одну оргструктуру.
2. **Назначить MLSec Lead / владельца scope** и обосновать необходимую загрузку, а не универсальный минимум FTE.
3. **Утвердить ограниченный пилот**: scope, потолок расходов, дату review и условия продолжения; пример Q1 18–22 млн руб не является ценой пилота.
4. **Включить MLSec KPI** в quarterly scorecard CIO/CISO.
5. **Запустить ежеквартальный MLSec-report** в совет.

<a id="8-al_ternativa-vnedreniu-i-uslovia-ostanovki"></a>

## 8. Альтернатива внедрению и условия остановки

Сравнивать с текущими средствами ИБ и запланированными изменениями, а не с вымышленной компанией «без защиты». Варианты: минимальные обязательные меры, ограничение use case / данных / tools, ручное выполнение, пилот, масштабирование. У каждого — цена, остаточный риск, ограничения и owner.

Не прогнозировать первый штраф через 6 месяцев или неизбежную блокировку клиентов через год. Неизвестные exposure — задача inventory; отсутствие инцидентов не доказывает отсутствие риска. Review фиксирует одно из решений: stop, исправить / повторить пилот, продолжить в scope или расширить по evidence. Источники подхода — [README](README.md).

---

**Следующие шаги**: согласовать [quick-start-ciso.md](quick-start-ciso.md) и 90-дневный план.
