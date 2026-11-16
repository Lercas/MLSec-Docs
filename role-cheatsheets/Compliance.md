<a id="compliance-urist-auditor-cheatsheet"></a>

# Compliance / юрист / аудитор Cheatsheet

> Тематическая актуализация: 13.11.2026. Основания и первичные источники — в [главе 18](../18-ru-compliance-deep.md); сроки EU AI Act — по [календарю Еврокомиссии](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai). Применимость к конкретному оператору подтверждает владелец правового анализа.


Что проверять и фиксировать по российскому и международному регулированию для ИИ-систем.

<a id="jivoj-timeline-srokov"></a>

## Живой timeline сроков

Актуальные deadline-ы: [continuous/regulatory-timeline.md](../continuous/regulatory-timeline.md). Обновляется ежемесячно.

<a id="top-12-prioritetov"></a>

## Топ-12 приоритетов

1. **152-ФЗ и классификация ПДн**. Определить категории ПДн, субъектов, операции и основание; УЗ 1-4 по ПП 1119 обосновать отдельно с учётом актуальных угроз. Проверить обязанность уведомления об обработке и исключения, включить ИИ-сценарии в документы оператора. Шаблоны: [templates/regulator-notifications/](../templates/regulator-notifications/). См. [18. Российская специфика](../18-ru-compliance-deep.md), [03. Data Operations](../03-stage1-data-operations.md).

2. **Локализация и трансграничная передача**. По 152-ФЗ отдельно проверить операции при сборе ПДн граждан РФ (ч. 5 ст. 18), исключения и передачу за рубеж (ст. 12). Уведомление о намерении передачи — отдельная процедура, не универсальное разрешение; учитывать получателей, ограничения и фактические endpoints. См. [18. Российская специфика](../18-ru-compliance-deep.md).

3. **187-ФЗ КИИ**. Категорирование объектов КИИ. Подключение к ГосСОПКА через НКЦКИ. Уведомления об инцидентах в срок, установленный регулятором. См. [15. IR](../15-ai-incident-response.md), [18. Российская специфика](../18-ru-compliance-deep.md).

4. **Положения ЦБ для банков и НФО**. 716-П (управление операционным риском), 850-П (ранее 787-П, операционная надёжность кредитных организаций), 821-П (защита информации при переводах денежных средств; для ИБ КО — 683-П), 802-П, 672-П. ГОСТ Р 57580. ФинЦЕРТ как центр реагирования. Отраслевой плейбук: [industries/banking.md](../industries/banking.md). См. [18. Российская специфика](../18-ru-compliance-deep.md).

5. **Приказы ФСТЭК**. 117 (ранее 17; защита ГИС, в силе с 01.03.2026, впервые включает требования к защите при использовании ИИ), 21 (ИСПДн), 31 (АСУ ТП), 239 (КИИ). Привязка требований к ИИ-системам, аттестация если применимо. Чеклист: [templates/FSTEK-AUDIT-CHECKLIST.md](../templates/FSTEK-AUDIT-CHECKLIST.md). Матрица: [compliance-matrices/FSTEK-ORDERS.md](../compliance-matrices/FSTEK-ORDERS.md). См. [18. Российская специфика](../18-ru-compliance-deep.md).

6. **Криптография по применимому режиму**. Обосновать необходимость СКЗИ, класс, исполнение и условия эксплуатации по модели угроз; приказ ФСБ 378 проверять для ИСПДн с использованием СКЗИ. Сертификат продукта, аттестация системы и реестр ПО — разные свидетельства. Сам факт внешнего канала не выбирает конкретное СКЗИ. См. [08. Access](../08-access-secrets-management.md), [18](../18-ru-compliance-deep.md).

7. **ГОСТ Р 71476-2024** «Искусственный интеллект. Концепции и терминология искусственного интеллекта» (=ISO/IEC 22989:2022). Терминологическая база для документации Tier 1-2 систем. См. [18. Российская специфика](../18-ru-compliance-deep.md).

8. **Маркировка AI-контента**. Отделить действующие обязанности от проектов; перед решением сохранить официальный статус, редакцию и дату вступления конкретного акта. Техническую provenance (например, C2PA с закреплённой версией) проверять отдельно: manifest / watermark не доказывают истинность контента. Статус: [continuous/regulatory-timeline.md](../continuous/regulatory-timeline.md). См. [29. Watermarking](../29-watermarking-attribution.md), [18](../18-ru-compliance-deep.md).

9. **EU AI Act phased enforcement**. Prohibited practices + AI literacy — с 02.02.2025; обязанности для GPAI — с 02.08.2025; transparency Art.50 — с 02.08.2026; high-risk Annex III — с 02.12.2027, Annex I — с 02.08.2028 после Digital Omnibus (действует с 27.07.2026); переходный срок GPAI, размещённых до 02.08.2025, — 02.08.2027. Маппинг: [compliance-matrices/EU-AI-ACT.md](../compliance-matrices/EU-AI-ACT.md). Роль provider / deployer и территориальную применимость определить по фактическим операциям; одного наличия EU-пользователей недостаточно для выбора роли. См. [14. Governance](../14-model-risk-governance.md).

10. **ISO / NIST / OWASP соответствие**. ISO/IEC 42001:2023 AIMS, NIST AI RMF 1.0 (добровольно), OWASP LLM Top 10 2025. Матрицы: [compliance-matrices/ISO-42001.md](../compliance-matrices/ISO-42001.md), [NIST-AI-RMF.md](../compliance-matrices/NIST-AI-RMF.md), [OWASP-LLM-TOP10.md](../compliance-matrices/OWASP-LLM-TOP10.md). См. [14. Governance](../14-model-risk-governance.md).

11. **Automated decision-making (GDPR Art. 22, 152-ФЗ ст. 16)**. Проверить область действия, исключения и гарантии каждого режима отдельно; назначить порядок рассмотрения возражений и вмешательства человека, если применимо. Интерпретируемость помогает анализу, но не заменяет правовое основание: [30. Interpretability](../30-interpretability-for-security.md).

12. **AI Incident Response и уведомления**. Для события проверить основание, объект, адресата, начало отсчёта и срок; не выводить обязанность уведомить субъектов / все ведомства из слова «утечка». ГосСОПКА: действующий порядок ФСБ №547; финансовый канал проверять параллельно. Retention определить по классу артефакта, цели и legal hold. Шаблоны: [templates/regulator-notifications/](../templates/regulator-notifications/). См. [15. IR](../15-ai-incident-response.md).

<a id="obazatel_nye-artefakty-v-organizazii"></a>

## Обязательные артефакты в организации

- Политика обработки ПДн (с учётом ИИ).
- Положение об обработке ПДн работниками.
- Приказы о назначении ответственных (в т.ч. Юрист).
- AI Use Policy (класс данных × тип модели): [templates/AI-USE-POLICY-TEMPLATE.md](../templates/AI-USE-POLICY-TEMPLATE.md).
- Реестр ИИ-систем с owner, назначением, ролями обработки и связями на AI-BOM компонентов: [пример BOM](../templates/AI-BOM-EXAMPLE.json).
- Журналы и retention-политика.
- Матрица уведомлений регуляторов: [templates/regulator-notifications/](../templates/regulator-notifications/).
- Результаты Threat Modeling и Red Teaming (для внутреннего аудита): [guides/red-team-exercises.md](../guides/red-team-exercises.md).
- PIA по внутренней политике; DPIA по применимому праву и условиям обработки. Tier сам по себе не создаёт правовую обязанность DPIA.

<a id="otraslevaa-spezifika"></a>

## Отраслевая специфика

Используйте соответствующий плейбук:
- Банки и НФО: [industries/banking.md](../industries/banking.md).
- Госсектор: [industries/govtech.md](../industries/govtech.md).
- Healthcare: [industries/healthcare.md](../industries/healthcare.md).
- Промышленность (КИИ): [industries/industrial.md](../industries/industrial.md).
- Retail / e-commerce: [industries/retail.md](../industries/retail.md).
- Телеком: [industries/telecom.md](../industries/telecom.md).

<a id="regularnaa-rabota"></a>

## Регулярная работа

- Ежегодный внутренний аудит соответствия.
- Ежеквартальная проверка актуальности лицензионных ограничений open-source моделей и датасетов (ML-BOM diff).
- Ежемесячная сверка [continuous/regulatory-timeline.md](../continuous/regulatory-timeline.md).
- Ежемесячная сводка [continuous/incident-log.md](../continuous/incident-log.md) для обновления угрозовой модели.
- Пересмотр оценки при изменении целей, данных, получателей, retention или рисков; периодичность и owner закреплены в политике.
- Карточка evidence: акт / пункт / редакция → операция / объект → owner → документ / тест. Нет актуальной проверки — `pending`, а не «соответствует».
