<a id="guides-dopolnitel_nye-prakticeskie-rukovodstva"></a>

# Guides: Дополнительные практические руководства

> **Версия**: 1.0 · **Дата**: 2026-04-22

Набор пошаговых руководств для специфических задач MLSec, которые выходят за рамки основной документации и чаще всего запрашиваются отдельно.

<a id="sostav"></a>

## Состав

| Файл | Для кого | Объём / сложность |
|---|---|---|
| [cloud-to-onprem-migration.md](cloud-to-onprem-migration.md) | CTO, ML Lead, SecOps | ~6 месяцев программа |
| [bug-bounty-ai.md](bug-bounty-ai.md) | CISO, Product Security | Запуск за 3 месяца |
| [red-team-exercises.md](red-team-exercises.md) | Red Team, MLSec, IR | Сценарная библиотека |

<a id="kogda-ispol_zovat_"></a>

## Когда использовать

- **Миграция cloud → on-prem**: если регулятор, клиенты или комплаенс требуют размещения AI/ML на собственной инфраструктуре (частый случай: банки, гос, КИИ).
- **Bug Bounty AI**: если MLSec-зрелость уже 2.5+ и нужна внешняя валидация (scan → fix → repeat).
- **Red Team упражнения**: если нужна регулярная adversarial проверка (quarterly) или подготовка к инцидентам.

<a id="svazi"></a>

## Связи

<a id="cto-podtverdit_-do-vypolnenia"></a>

### Что подтвердить до выполнения

Сроки, бюджеты и maturity в guides — примеры плана, а не обязательная норма или гарантия результата. Владелец сценария фиксирует конкретный scope, данные, разрешённые действия, условия остановки и свидетельства приёмки. Red team / bounty выполняются по письменной авторизации, миграция — по согласованному cutover manifest; публичность endpoint не заменяет разрешение.

Для сценариев с tools проверяйте фактическое состояние у исполнителя; для RAG — текущие ACL / tombstones после restore; для тестов — изоляцию fixtures и внешние generation / grading пути. Ни один guide не разрешает production-атаки, автоматическое удаление evidence или передачу данных новой облачной замене. Общая IR-последовательность: [playbooks/README.md](../playbooks/README.md).

Тематическая сверка runbooks и приёмочных сценариев: **13.11.2026**. Источники приведены в соответствующих guides; исторические каталоги моделей и учебные стоимостные оценки не являются проверенными текущими рекомендациями закупки.

- [00-INDEX.md](../00-INDEX.md) корневая навигация.
- [13-implementation-ru-playbook.md](../13-implementation-ru-playbook.md) roadmap программы MLSec.
- [playbooks/](../playbooks/) IR-runbook-и (используются в red team exercises).
- [21-people-process.md](../21-people-process.md) bug bounty как часть People & Process.
