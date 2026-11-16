<a id="ir-playbooks-dla-mlai-inzidentov"></a>

# IR Playbooks для ML/AI-инцидентов

> Версия: 1.0 · Дата: 2026-04-22 · Tier: 1-4

Готовые runbook-и для Incident Response команды (SOC L1/L2/L3) и MLSec Analyst. Для удобства работы сохранены фазы Preparation, Detection & Analysis, Containment, Eradication & Recovery, Post-Incident Activity. Это операционная структура runbook, а не буквальная структура актуального NIST SP 800-61 Rev. 3: редакция 2025 года встраивает IR в CSF 2.0.

<a id="spisok-playbook"></a>

## Список playbook

| # | Сценарий | Severity по умолчанию | SLA реагирования | Файл |
|---|---|---|---|---|
| 1 | Data Poisoning | SEV2 | 1 час | [IR-01-data-poisoning.md](IR-01-data-poisoning.md) |
| 2 | Model Extraction / Theft | SEV1-SEV2 | 15 мин-1 час | [IR-02-model-extraction.md](IR-02-model-extraction.md) |
| 3 | Prompt Injection кампания | SEV2 | 1 час | [IR-03-prompt-injection-campaign.md](IR-03-prompt-injection-campaign.md) |
| 4 | Agentic Breach | SEV1 | 15 мин | [IR-04-agentic-breach.md](IR-04-agentic-breach.md) |
| 5 | Shadow AI Data Leak | SEV2 | 1 час | [IR-05-shadow-ai-leak.md](IR-05-shadow-ai-leak.md) |

<a id="kak-ispol_zovat_"></a>

## Как использовать

1. При срабатывании детектора SOC L1 определяет категорию инцидента и открывает соответствующий playbook.
2. Выполняет шаги Containment до истечения SLA.
3. Эскалирует на L2 (MLSec Analyst) для Analysis и Eradication.
4. После закрытия инцидента заполняет Post-Incident Report и планирует Lessons Learned.

<a id="svazi"></a>

## Связи

<a id="obsie-uslovia-vypolnenia"></a>

### Общие условия выполнения

- SLA и численные пороги в runbook-ах — примеры внутренних целей, которые утверждает Incident Commander (IC). Они не заменяют юридические основания и сроки уведомлений из [главы 18](../18-ru-compliance-deep.md). Отсутствие точной оценки ущерба не откладывает ограничение продолжающегося воздействия.
- Дежурный сначала блокирует новые опасные действия в известной границе; сбор полного snapshot и установление root cause идут параллельно. Сохраните время, scope, автора и readback применённого ограничения. Сам приказ «отключить» не является доказательством исполнения.
- Для credentials отдельно проверяются API keys, access/refresh tokens, sessions, delegated grants и leases. Отзыв в IdP не гарантирует немедленный отказ уже выданного токена у каждого получателя. IAM owner проверяет безопасным запросом прежний путь доступа; исключения и срок их устранения остаются открытыми.
- Остановленный агент может оставить очередь, scheduler или внешний job. Владелец интеграции ведёт реестр `pending / cancelled / completed / unknown`, связывает action ID с внешним job ID и проверяет результат у получателя. Timeout не означает отсутствие эффекта; mutation не повторяют ради проверки.
- Evidence хранится отдельно с ограниченным доступом, хешем, временем получения и цепочкой передачи. Полные prompts, секреты и реальные ПДн не копируются автоматически во все тикеты и eval-наборы. Retention и legal hold назначает владелец данных совместно с юристом; уничтожение требует отдельного согласованного manifest, а не автоматического шага закрытия.

**Приёмка восстановления**: IC подписывает решение только после проверки ограничений, целостности восстановленной версии и полезного разрешённого сценария. Неразрешённые внешние результаты записываются как `unknown` с owner и следующим сроком readback, а не как «отменено».

Тематическая сверка: **13.11.2026**. Основа: [NIST SP 800-61 Rev. 3](https://csrc.nist.gov/pubs/sp/800/61/r3/final), [OWASP AI Agent Security](https://cheatsheetseries.owasp.org/cheatsheets/AI_Agent_Security_Cheat_Sheet.html). Для MCP отдельно проверяйте согласованную редакцию: [Cancellation 2025-11-25](https://modelcontextprotocol.io/specification/2025-11-25/basic/utilities/cancellation) допускает гонку с завершением и не является гарантией отката внешнего действия. Эти условия применяются ко всем пяти runbook-ам.

- [Глава 15. AI Incident Response](../15-ai-incident-response.md) - процесс, таксономия, коммуникации.
- [Глава 01 раздел 12](../01-overview-architecture.md#12-integrazia-s-korporativnoj-ib) - SIEM-правила и классификация.
- [templates/TABLETOP-SCENARIOS.md](../templates/TABLETOP-SCENARIOS.md) - штабные учения на тех же сценариях.
