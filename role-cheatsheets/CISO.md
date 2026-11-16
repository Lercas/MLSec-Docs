<a id="ciso-cheatsheet-mlsec-za-10-sagov"></a>

# CISO Cheatsheet. MLSec за 10 шагов

Краткая карта действий CISO в первый год программы MLSec. Полные процедуры: главы 13-22 + executive-материалы.

<a id="bystryj-start"></a>

## Быстрый старт

- Готовые материалы для совета: [executive/one-pager.md](../executive/one-pager.md), [executive/summary.md](../executive/summary.md), [executive/board-deck.md](../executive/board-deck.md) (+ pptx), [executive/quick-start-ciso.md](../executive/quick-start-ciso.md), [executive/roi-calculator.xlsx](../executive/roi-calculator.md).
- Regulatory timeline: [continuous/regulatory-timeline.md](../continuous/regulatory-timeline.md).
- Industry cases: [continuous/incident-log.md](../continuous/incident-log.md).

<a id="top-10-prioritetov"></a>

## Топ-10 приоритетов

1. **Инвентаризация ИИ-активов (30 дней)**. Завести реестр систем с owner, Tier, данными, провайдерами и интеграциями; связать его с AI-BOM компонентов и версий. Формат BOM и его schema version фиксировать отдельно. Сюда же Shadow AI аудит: что реально используется в разработке, маркетинге, поддержке. Используйте шаблон [templates/AI-BOM-EXAMPLE.json](../templates/AI-BOM-EXAMPLE.json). См. главу [14. Governance](../14-model-risk-governance.md).

2. **Tiering систем (Tier 1-4)**. Внутренняя шкала: Tier 1 — наивысшая критичность, Tier 4 — низкая; оценка по влиянию на безопасность, ПДн, финансы, репутацию. Это не категория КИИ, УЗ или класс данных K0-K4. Tier 1-2 идут под усиленный MRM и independent validation. См. [02. System Design](../02-stage0-ml-system-design.md).

3. **AI Use Policy (60 дней)**. Матрица K0-K4 (классы данных) × разрешённые модели (open-weight, self-hosted, российские провайдеры, зарубежное облако). Привязать к 152-ФЗ, ПП 1119/127, категориям КИИ. Шаблон: [templates/AI-USE-POLICY-TEMPLATE.md](../templates/AI-USE-POLICY-TEMPLATE.md). См. [14. Governance](../14-model-risk-governance.md).

4. **LLM Gateway как единая точка контроля**. Определить разрешённые маршруты с DLP, rate limit, kill-switch и аудитом; проверить реальные пути каждого продукта. DNS/PAC сами по себе не доказывают блокировку обхода: нужен отрицательный egress-тест. Правила PromptOps в [25. PromptOps](../25-prompt-ops.md). См. [01. Архитектура](../01-overview-architecture.md), [11. Чат-боты](../11-chatbot-conversational-security.md).

5. **Kill-switch 5 уровней**. L0 глобальный, L1 пользователь, L2 модель, L3 cloud egress, L4 агент. Тренировать процедуру ежеквартально через [guides/red-team-exercises.md](../guides/red-team-exercises.md) сценарий S3. См. [10. LLM-агенты](../10-llm-agent-protection.md).

6. **AI Incident Response (90 дней)**. Выбрать сценарии по своим системам, назначить first responder, определить минимальные артефакты, сроки retention и chain of custody. Матрица уведомлений должна содержать применимое основание, событие, начало отсчёта, адресата и owner; список ведомств не заменяет проверку обязанности. Готовые IR-runbook: [playbooks/](../playbooks/). См. [15. IR](../15-ai-incident-response.md).

7. **Tabletop-учения**. Минимум 2 в год. Готовые сценарии: [templates/TABLETOP-SCENARIOS.md](../templates/TABLETOP-SCENARIOS.md) и [guides/red-team-exercises.md](../guides/red-team-exercises.md) (6 сценариев). См. [15. IR](../15-ai-incident-response.md).

8. **Threat Modeling для ИИ-систем**. STRIDE-AI + OWASP LLM Top 10 2025 + MITRE ATLAS (в т.ч. русский перевод [23-mitre-atlas-ru.md](../23-mitre-atlas-ru.md)). Обязательно для всех Tier 1-2 на этапе дизайна. Шаблон: [templates/THREAT-MODEL-TEMPLATE.md](../templates/THREAT-MODEL-TEMPLATE.md). См. [09. Threat Modeling](../09-threat-modeling.md).

9. **AI Literacy по ролям**. Разная глубина для руководителей, ML-инженеров, разработчиков, compliance. Фокус на prompt injection, ПДн, shadow AI, responsible use, deepfake awareness. См. [21. Люди и процесс](../21-people-process.md). Для deepfake training используйте кейсы из [continuous/incident-log.md](../continuous/incident-log.md) (Arup, Replit).

10. **Метрики и отчётность для правления**. Полнота реестра систем и связанных BOM, % систем с пройденным Threat Modeling, количество DLP-инцидентов, time-to-detect и time-to-contain, бюджетные аномалии, MTTP для CVE. ROI-калькулятор: [executive/roi-calculator.xlsx](../executive/roi-calculator.md). См. [22. FinOps](../22-finops-ai.md), [15. IR](../15-ai-incident-response.md).

<a id="klucevye-regulatornye-ssylki"></a>

## Ключевые регуляторные ссылки

152-ФЗ, 187-ФЗ, 242-ФЗ, ПП 1119 и 127, Приказы ФСТЭК 117 (ранее 17) / 21 / 31 / 239, Положения ЦБ 716-П / 850-П (ранее 787-П) / 821-П, Приказ ФСБ 378, ГОСТ Р 57580, ГОСТ Р 71476-2024, EU AI Act (2024/1689). Детальный разбор: [18. Российская специфика](../18-ru-compliance-deep.md). Живой timeline deadline-ов: [continuous/regulatory-timeline.md](../continuous/regulatory-timeline.md). Матрицы соответствия: [compliance-matrices/](../compliance-matrices/).

<a id="dla-starta-vnesnego-testirovania"></a>

## Для старта внешнего тестирования

- Red Team сценарии (внутренние): [guides/red-team-exercises.md](../guides/red-team-exercises.md).
- Bug Bounty (внешние исследователи): [guides/bug-bounty-ai.md](../guides/bug-bounty-ai.md) (требует MLSec 2.5+).

<a id="otraslevye-akzenty"></a>

## Отраслевые акценты

| Отрасль | Основной плейбук |
|---|---|
| Банки / НФО | [industries/banking.md](../industries/banking.md) |
| Госсектор | [industries/govtech.md](../industries/govtech.md) |
| Healthcare | [industries/healthcare.md](../industries/healthcare.md) |
| Промышленность / КИИ | [industries/industrial.md](../industries/industrial.md) |
| Retail / E-commerce | [industries/retail.md](../industries/retail.md) |
| Телеком | [industries/telecom.md](../industries/telecom.md) |

<a id="cto-pokazat_-pravleniu-na-pervom-otcete"></a>

## Что показать правлению на первом отчёте

- Ландшафт ИИ-систем (реестр, владельцы, связанные AI-BOM, Tier distribution).
- Ключевые риски, critical gaps, неизвестные состояния и maturity score (по [MATURITY-ASSESSMENT.md](../MATURITY-ASSESSMENT.md) / xlsx).
- Дорожная карта на 12 месяцев с бюджетом (см. [executive/board-deck.md](../executive/board-deck.md) слайды 9-13).
- ROI и NPV (из [executive/roi-calculator.xlsx](../executive/roi-calculator.md)): расчёт по своим затратам, сценариям ущерба и чувствительности; универсального срока окупаемости нет.
- Инциденты и near-miss за квартал (агрегация из [continuous/incident-log.md](../continuous/incident-log.md) + внутренние).
