<a id="bug-bounty-dla-ai-llm-sistem"></a>

# Bug Bounty для AI / LLM систем

> **Версия**: 1.1 · **Дата**: 2026-05-29 · **Audience**: CISO, Product Security, Legal · **Срок запуска**: 3 месяца · **Необходимая зрелость**: MLSec 2.5+

Bug Bounty для AI специфичен: таргетится не классический код, а модели, промпты, агенты, data pipeline. Обычные программы (HackerOne, Intigriti, BI.ZONE Bug Bounty, Standoff Bug Bounty) уже поддерживают AI scope.

<a id="1-kogda-zapuskat_"></a>

## 1. Когда запускать

- Зрелость MLSec ≥ 2.5. Если меньше: сначала закрыть базу (DLP, audit log, kill-switch, SIEM rules).
- Пройден внутренний red team хотя бы один раунд.
- Есть продуктивные AI-фичи customer-facing (иначе bounty не о чем).
- Есть команда, способная закрывать находки в SLA: обычно 1 SecEng fulltime + on-call MLSec.

<a id="2-scope-programmy"></a>

## 2. Scope программы

<a id="in-scope-oplacivaetsa"></a>

### In scope (оплачивается)

- **LLM-компоненты** публичного продукта: chatbots, Q&A, summarization, copilots.
- **Прикладные AI**: генерация контента, classification, scoring, рекомендации.
- **Agent-based**: автоматизированные task-outputs, MCP-серверы, tool-use.
- **RAG**: утечки через retrieval, cross-tenant leakage, prompt injection из документов.
- **Voice / multimodal**: если есть customer-facing.
- **Inference endpoints**: API, если доступны пользователям.

<a id="out-of-scope-ne-oplacivaetsa-ili-rejetsa"></a>

### Out of scope (не оплачивается или режется)

- Bias / fairness (отдельная программа с Responsible AI).
- Hallucinations без security impact (если LLM врёт, но не leak-ит данные и не обходит policy).
- DoS через огромные prompts (это абуз, а не уязвимость).
- Prompt injection без демонстрации impact (утечка, privilege escalation, secret leak).
- Атаки на провайдера модели upstream (это их программа).
- Self-XSS, социальная инженерия сотрудников.

<a id="3-kategorii-uazvimostej-i-voznagrajdenia"></a>

## 3. Категории уязвимостей и вознаграждения

> Суммы ниже — **ориентировочный пример** шкалы, а не фиксированное обязательство. Конкретные диапазоны калибруются под бюджет программы, рынок исследователей и реальный impact (см. §8 «Месяц 2: калибровка severity/reward»).

| Категория | Пример | Severity | Диапазон, млн руб (пример) |
|---|---|---|---|
| Prompt injection с утечкой данных | Инъекция извлекает system prompt + секреты | Critical | 0.5-2.0 |
| Cross-tenant data leakage | Пользователь A видит данные пользователя B через RAG | Critical | 1.0-5.0 |
| Agent-based RCE / action escalation | Агент удаляет файлы / делает перевод | Critical | 1.0-5.0 |
| Jailbreak + нарушение политики | Обход age-gate, hate speech generation | High | 0.1-0.5 |
| Output injection (XSS через LLM-ответ) | Markdown / HTML в ответе исполняется в UI | High | 0.1-0.5 |
| Model DoS / resource exhaustion | Промпт вызывает час GPU-счёт | Medium | 0.05-0.2 |
| Prompt injection без direct impact | Возможно повлиять, но нет демонстрации | Low | 0.01-0.05 |
| Misconfiguration (открытый endpoint, weak auth) | Внутренний dev endpoint exposed | Variable | По основной bug bounty шкале |

Множители:
- Full chain (prompt injection → exfiltration → action) = x1.5-x2.
- Потенциальный impact на продуктивный сценарий оценивается по безопасной демонстрации; затрагивать реальных пользователей ради множителя нельзя.
- Первый в категории (novel technique) = x1.2.

<a id="4-pravila-engagement"></a>

## 4. Правила engagement

<a id="razreseno"></a>

### Разрешено

- Тестирование только явно перечисленных AI endpoints по действующим письменным правилам программы. Публичная доступность не означает разрешение на тестирование.
- Создание обычных пользовательских аккаунтов (не более 5).
- Prompt injection payloads (внутри собственных контекстов).
- Decoded payloads: base64, obfuscated text, unicode homoglyphs (для демонстрации).

<a id="zapreseno"></a>

### Запрещено

- Массовые атаки (DoS / flood) больше 10 req/sec без согласования.
- Скраппинг / extraction large-scale model weights (это отдельный класс).
- Извлечение реальных PII других пользователей (stop at demonstration; PII redact в отчёте).
- Социальная инженерия, физические атаки.
- Атаки на third-party (модели upstream, SaaS-компоненты).

<a id="5-prozess"></a>

## 5. Процесс

```mermaid
graph LR
    classDef step fill:#1a1a1a,stroke:#666,color:#fff
    R[Researcher] --> S1[Submit]
    S1 --> T[Triage]
    T --> V[Validation]
    V --> SEV[Severity]
    SEV --> REM[Remediation]
    REM --> VER[Verify fix]
    VER --> P[Payout]
    P --> CVE[CVE / write-up]

    class R,S1,T,V,SEV,REM,VER,P,CVE step
```

<a id="stadii-i-sla"></a>

### Стадии и SLA

1. **Submit**: Researcher отправляет отчёт через платформу (HackerOne / BI.ZONE / корпоративный портал).
2. **Triage**: пример внутренней цели — 24 часа. SecEng проверяет scope, безопасность и impact; отсутствие идеального шаблона не является основанием игнорировать возможную утечку.
3. **Validation**: 72 часа. MLSec + Application Security воспроизводят и ставят severity.
4. **Remediation**: SLA по severity. Critical 7 дней, High 14 дней, Medium 30, Low 90.
5. **Verify fix**: Researcher подтверждает фикс в течение 7 дней.
6. **Payout**: в течение 30 дней после verify.
7. **CVE / write-up**: coordinated disclosure по заранее согласованным правилам и срокам; CVE применим не к каждой проблеме поведения модели. 90 дней — пример политики, а не универсальная обязанность.

<a id="sablon-otceta"></a>

### Шаблон отчёта

```markdown
## Title
<Категория>: <короткое>

## Summary
<что, где, какое влияние>

## Steps to reproduce
1. Запрос X к endpoint Y
2. Промпт Z (в приложении)
3. Наблюдаемый response

## Impact
<конкретное: утечка, privilege escalation, что именно>

## Proof
- Скриншот / запись / redacted response
- Request/response payload (трим PII)

## Recommendation
<предложенная mitigation>

## Contact
<HackerOne handle / email>
```

<a id="6-tehniceskaa-infrastruktura"></a>

## 6. Техническая инфраструктура

<a id="izolirovannaa-bounty-sreda"></a>

### Изолированная bounty-среда

Для prompt-injection и agent-abuse атак рекомендовано выделить staging-среду:
- Отдельные API keys.
- Sandboxed агенты: тестовые credentials и получатели, запрет production network / IAM / mounts. `DRY_RUN=true` — только условный флаг приложения, он сам по себе не доказывает изоляцию.
- Обфусцированные / синтетические данные в RAG.
- Логи отдельно для post-mortem.

<a id="monitoring-aktivnosti"></a>

### Мониторинг активности

- Алерты на аномальные volumes запросов от bounty-tagged IP.
- Separate dashboard «Bug Bounty activity» в Grafana.
- SIEM ruleset для известных payload-классов; режим detect-only разрешается в изолированной среде. Защиту production не отключают ради bounty.

<a id="integrazia-s-jira-linear"></a>

### Интеграция с Jira / Linear

- Автосоздание тикетов из HackerOne / BI.ZONE.
- Поле `bounty_severity`, `bounty_id`, `bounty_reward`.
- Отдельные SLA monitors (алерт если approaches deadline).

<a id="7-legal-i-comms"></a>

## 7. Legal и comms

- **Safe harbor**: согласованное с юристом разрешение на добросовестное исследование в указанном scope и пределах полномочий организации. Это не общий иммунитет по DMCA или праву других стран и не разрешение владельцев third-party.
- **Disclosure policy**: 90 дней до публикации, продление при необходимости.
- **GDPR / 152-ФЗ**: чёткое указание, что реальные PII не должны выгружаться.
- **Press**: крупные находки (CVE) координируются с PR.

Правила публикуются до приглашения исследователей; юридическую формулировку адаптируют к активам и применимому праву. Первичная основа: [HackerOne Safe Harbor Overview](https://docs.hackerone.com/en/articles/8494502-safe-harbor-overview-faq), проверено **13.11.2026**.

<a id="dopusk-ai-szenaria-i-proverka-ispravlenia"></a>

### Допуск AI-сценария и проверка исправления

Product Security owner подписывает карточку: tenant / endpoint / версия, разрешённые инструменты и получатели, бюджет запросов и tokens, окно, emergency contact, правила остановки при чужих данных. Предел 10 req/sec из примера выше не разрешает нагрузочное тестирование: дополнительно ограничиваются concurrency, длина контекста, число agent turns и стоимость внешних tools.

| Сценарий проверки | Безопасная демонстрация | Evidence для triage / retest |
|---|---|---|
| Cross-tenant retrieval | Два выданных тестовых tenant, синтетический canary | Авторизованный tenant, revision документа, retrieval / response IDs |
| Tool abuse после нескольких ходов | Тестовый executor без production доступа; отдельный sink | Вся последовательность ходов, policy decision и фактический эффект у sink |
| Повтор после timeout | Тестовый job с потерянным ответом | Один action ID, readback и отсутствие второй mutation |
| Исправление ограничения | Прежний exploit и соседние варианты плюс разрешённая задача | Safety и utility, версии конфигурации, ошибки / неполные прогоны отдельно |

Исследователь останавливается при первом признаке чужих реальных данных и сообщает по защищённому каналу: не наращивает выгрузку для доказательства severity. Копию чувствительного отчёта не отправляют внешнему grader без допуска. При retest owner сверяет executor / получателя: отказ в тексте ответа при уже выполненной операции не является исправлением. Практическая основа: [OWASP AI Agent Security](https://cheatsheetseries.owasp.org/cheatsheets/AI_Agent_Security_Cheat_Sheet.html), тематическая сверка **13.11.2026**.

<a id="8-zapusk-za-3-mesaza-plan"></a>

## 8. Запуск за 3 месяца (план)

<a id="mesaz-1-podgotovka"></a>

### Месяц 1: Подготовка

- Scope definition.
- Severity + reward таблица.
- Legal review (внешние юристы + in-house).
- Выбор платформы (HackerOne / BI.ZONE / Standoff / own).
- Создание staging-среды.

<a id="mesaz-2-private-beta"></a>

### Месяц 2: Private beta

- Пригласить 10-30 researchers (по списку платформы, с AI-опытом).
- Запуск на 4 недели, soft-launch.
- Калибровка severity / reward по первым отчётам.
- Тестирование SLA внутренних команд.

<a id="mesaz-3-public-launch"></a>

### Месяц 3: Public launch

- Публичный анонс (блог, платформа).
- Программа активна 24/7.
- Первый quarterly report через 90 дней.

<a id="9-kpi-programmy"></a>

## 9. KPI программы

- **Mean-time-to-triage**: ≤ 24ч.
- **Mean-time-to-validate**: ≤ 72ч.
- **Mean-time-to-fix Critical**: ≤ 7 дней.
- **% отчётов, закрытых в SLA**: ≥ 90%.
- **Research retention**: % исследователей, присылающих 2+ отчёта (нормально 30-50%).
- **Payout budget utilization**: 60-90% от бюджета (если ближе к 100%, пересмотреть scope).
- **Reopen rate**: % фиксов, которые researcher отверг как недостаточные (< 10%).

<a id="10-castye-osibki"></a>

## 10. Частые ошибки

- **Слишком узкий scope**: researcher-ы уходят, программа тишина.
- **Слишком щедрые reward**: очередь отчётов, не успеваете чинить.
- **Нет staging-среды для агентов**: атаки попадают в production, impact реальным пользователям.
- **Нет коммуникации**: researcher ждёт 2 недели ответа, пишет в твиттер, репутационный ущерб.
- **Игнор dup-атак**: одна и та же техника присылается 10 раз, researcher-ы обижаются на dupe-close.

<a id="11-svazi"></a>

## 11. Связи

- [21-people-process.md](../21-people-process.md) People & Process глава.
- [07-red-teaming-testing-methods.md](../07-red-teaming-testing-methods.md) red team methods.
- [red-team-exercises.md](red-team-exercises.md) внутренние red team упражнения.
- [continuous/cve-watch.md](../continuous/cve-watch.md) CVE tracker.
