<a id="primery-kontrola-dejstvij-ai-agenta"></a>

# Примеры контроля действий AI-агента

Проверено по первичным источникам 13.11.2026. Это комплект проектных примеров для глав [10](../../10-llm-agent-protection.md), [11](../../11-chatbot-conversational-security.md), [14](../../14-model-risk-governance.md), [15](../../15-ai-incident-response.md), [21](../../21-people-process.md), [22](../../22-finops-ai.md) и [31–36](../../31-ai-agents-overview.md). Он помогает подготовить контроль и подтверждения, но сам не предоставляет полномочия и не подключает enforcement к runtime.

<a id="1-versii-i-sovmestimost_"></a>

## 1. Версии и совместимость

Обе JSON Schema используют **Draft 2020-12**. Текущую форму примеров здесь обозначаем `milksec-agent-examples/1.0`: это локальное обозначение комплекта, не версия MCP, A2A или стандарт сертификации. `$id` с `example.invalid` — идентификатор примера, а не доступный сервис. Для воспроизводимой проверки сохраняйте SHA-256 файлов схем вместе с версией валидатора.

Схемы сохраняют прежние поля, enum, `required` и `additionalProperties: false`. Исправлены пояснения к пределам их проверки. Не добавляйте `outcome`, `arguments_digest`, `tenant_id`, `memory_retired` или другие поля/события в старый event под видом совместимого изменения. Дополнительные подтверждения ниже хранятся отдельной записью, связанной через `evidence_uri` / `evidence_ref`. Если они нужны в основном контракте, согласуйте новую версию схемы, mapping производителей/потребителей, миграцию и негативные проверки. Нельзя молча отбрасывать неизвестные поля авторизации.

`agent-action-policy.yaml` — проектная модель политики для обсуждения и реализации адаптера. Она не является конфигурацией OPA, Cedar, MCP или конкретного agent framework. Указание `decision: deny` в файле само по себе не блокирует вызов. `prometheus-agent-alerts.yaml` использует синтаксис alert rules Prometheus, но требует собственного экспортера с описанной семантикой метрик. SIEM-запросы — псевдокод, требующий адаптации и тестирования.

Даты мая–августа 2026 года оставлены историческими. На 13.11.2026 эти разрешения истекли. Положительный тест выполняется с фиксированными **синтетическими часами** внутри исторического окна; это не продление разрешения и не основание выполнять реальную операцию.

<a id="semantic-validation"></a>

<a id="2-cto-proverat_-posle-json-schema"></a>

## 2. Что проверять после JSON Schema

[JSON Schema Validation](https://json-schema.org/draft/2020-12/json-schema-validation) задаёт структурные ограничения; `format` по умолчанию может быть аннотацией. В [python-jsonschema](https://python-jsonschema.readthedocs.io/en/stable/validate/) для проверки форматов явно задают `FormatChecker`. Даже с ним проверка `date-time` не сравнивает даты между полями и с текущим временем.

| Проверка доверенного executor | Что не доказывает прохождение схемы | Негативная проверка |
| --- | --- | --- |
| `requested_at ≤ approved_at ≤ now < expires_at`; актуальны policy и вся цепочка делегирования | Срок действия и отсутствие отзыва | Очередь возобновилась на границе expiry; делегация отозвана после согласования |
| `agent_id`, requester, tenant, экземпляр workflow, tool/connector и точный объект совпадают | Совпадение полей разных записей | Валидный approval другого tenant или run |
| Снимок аргументов, адресат, назначение данных и preconditions связаны с показанным preview | Что `action_id` обозначает именно эти аргументы | Поменять ticket, файл, получателя или tool revision после preview |
| `approved_by.actor_id`, `approver_ids` и `approver_id` согласованы; текущие роли разрешают согласование | Что два разных ID принадлежат разным людям | Два алиаса одного principal; согласующий потерял роль |
| Условия проверены фактически; approval не отозван/использован | Что текст `conditions` был исполнен | `must_be_satisfied_before_execution=true`, но нет результата проверки |
| Права исполнителя и scope дочернего агента не шире каждого предка; есть общий budget | Что `delegation_scope_hash` рассчитан верно и полномочия существуют сейчас | Подмена scope, отзыв родителя, исчерпание родительского бюджета |

Одинаковый хэш помогает проверить совпадение байтов/канонического представления, но не удостоверяет автора или разрешение. Mapping identity, ACL, authoritative policy, revocation и trusted approval store не должны поступать из prompt, памяти агента или tool output. Два разных объекта в `approved_by` проходят `uniqueItems`, даже если относятся к одному человеку.

<a id="privazka-soglasovania-k-dejstviu"></a>

### Привязка согласования к действию

1. Доверенный сервис строит неизменяемый action snapshot: subject/tenant, run, точное действие, tool/contract revision, connector, объект, аргументы, preconditions, максимальный объём и ключ идемпотентности. Пользователь видит соответствующий preview.
2. Запись решения связывает digest snapshot с digest approval record, policy revision, delegation revision и установленной identity согласующих. Сервис проверяет целостность и происхождение этой записи; хэш, присланный самой моделью, не принимается за подтверждение.
3. После очереди, retry, handoff и resume executor заново получает актуальные policy, grant/revocation, roles и object ACL. Старый `allow` или `human_approval_recorded` не заменяет проверку. При изменении снимка нужен новый preview и новое согласование.
4. В доверенном хранилище атомарно резервируются право на единственное исполнение и общий budget; исполнение использует проверенный snapshot. Учтите race между проверкой и отправкой через fencing/version preconditions. Этот пример не реализует транзакцию, распределённую блокировку или защиту от TOCTOU.
5. Ответ API сопоставляют с фактическим результатом по отдельному readback. Повторный click или доставка сообщения не создают новую операцию. Компенсирующая операция получает собственные полномочия и подтверждение.

`validate-agent-examples.py` и `agent-semantic-fixtures.json` показывают локальную проверку связей, дат, ролей и привязки аргументов на синтетических данных. Sidecar `binding` имеет отдельную версию `1.0`; он не меняет JSON Schema approval. Это self-test, не сервис авторизации: все его «доверенные» контексты тестовые, подписи и live IAM не проверяются. Валидатор показывает один grant и `specific_action`; полный обход цепочки предков, поддержка широких scopes и atomic consumption остаются задачей runtime integration. Внутри примера используется JSON с сортированными ключами без float; это локальная сериализация, не заявление о совместимости с JCS или подписными протоколами.

```bash
uv run --no-project --with 'jsonschema[format]==4.26.0' --with 'pyyaml==6.0.3' python examples/agents/validate-agent-examples.py
```

<a id="external-outcomes"></a>

<a id="3-neizvestnyj-vnesnij-rezul_tat-i-ostanovka"></a>

## 3. Неизвестный внешний результат и остановка

Для каждого отправленного вызова заведите запись последствий: parent/run reference, connector, provider job ID, idempotency reference, время dispatch, deadline, последнее подтверждённое состояние, источник readback, владелец и срок следующей проверки. Это отдельный evidence artifact. `outcome=unknown` не является новым допустимым значением `status` старой схемы.

| Наблюдение | Решение | Подтверждение |
| --- | --- | --- |
| Timeout после dispatch | Сохранить `unknown`, не повторять запись автоматически | Журнал отправки и попытка readback по тому же job/idempotency reference |
| Runtime остановлен, remote job работает | Блокировать новые dispatch; отменять remote job по согласованному пути | Отдельные receipt запроса cancel и ответ/последующий readback |
| Cancel вернул HTTP success | Не объявлять эффект отменённым до подтверждения | Provider state и проверка целевого объекта; уже доставленное сообщение не «возвращается» |
| Provider недоступен | Эскалировать владельцу, сохранить `unknown` | Пробел наблюдаемости, следующий срок проверки и связанные budget reservations |

Не снимайте reservation неизвестного результата так, будто расхода не было. Согласуйте финансовую сверку и ограниченный reconciliation отдельно. Остановка родителя должна охватывать child credentials, schedules, queues, callbacks и внешние jobs; один `agent_stopped` не подтверждает этот охват. Блокировка dispatch не ждёт окончания forensic snapshot. Preservation выполняется параллельно; cleanup и уничтожение данных требуют отдельного решения после сохранения минимально необходимого evidence.

<a id="memory-retirement"></a>

<a id="4-pamat_-i-vyvod-iz-ekspluatazii"></a>

## 4. Память и вывод из эксплуатации

Для памяти фиксируют namespace/tenant, source revision, ACL, lineage, writer, TTL и состояние доверия. Retrieval повторно проверяет текущие права; summary или cache не повышает доверие источника и не восстанавливает отозванные полномочия. Удаление проверяют в основной записи, summaries, embeddings, индексах, cache и export; для backup отдельно указывают срок и ограничения физического удаления.

Retirement создаёт минимальный tombstone: retired identity/namespace, revision, дата, owner, основание и evidence reference без исходного контента и секретов. Restore и replay сначала проверяют tombstone/epoch, чтобы старая копия памяти, scheduler или карточка агента не оживили удалённое состояние. Tombstone сам имеет срок хранения и ограничение доступа; он не повод бессрочно хранить пользовательские данные. При legal hold agent-visible доступ блокируется, а необходимый forensic материал хранится отдельно по утверждённому основанию.

Проверки: отравленная summary после очистки источника; restore backup с retirement tombstone; late callback старого run; expired memory при resume; cross-tenant retrieval через cache. Подтверждение — отказ на retrieval/dispatch и независимый readback, а не только успешный запрос удаления.

<a id="bounded-telemetry"></a>

<a id="5-ogranicennaa-telemetria"></a>

## 5. Ограниченная телеметрия

В [рекомендациях Prometheus по именованию](https://prometheus.io/docs/practices/naming/) запрещается использовать неограниченные множества вроде user ID как labels. Здесь `agent_id`, `connector_id`, `action_name` разрешены в метриках только как значения ограниченного deployment inventory/action catalog. Exporter отображает неизвестные значения в фиксированную категорию и считает потери; tenant, run, job, approval, trace, URI, raw reason и content hash остаются в защищённом журнале, а не labels.

Экспортер ограничивает размер события/ссылок, длину reason, скорость ingress, очередь, число series и стоимость корреляции. На переполнение: отдельный счётчик потерь/задержки, bounded buffer и уведомление owner; отсутствие событий не становится доказательством отсутствия действий. Для критичного аудита заранее определяют, когда потеря записи блокирует dispatch и как аварийное containment остаётся доступно.

Счётчик событий не авторизует действие. Внешнее действие без подходящего approval выявляет stateful join по конкретной операции и authoritative approval/binding, а не сравнение суммарных счётчиков в окне. Отсутствующий ряд метрики отличается от нуля; настройте heartbeat/lag и отдельную проверку доставки оповещений. `promtool check rules` проверяет синтаксис; только тестовые временные ряды и проверка маршрута до owner подтверждают поведение алерта.

Из корня проекта выполните с установленным `promtool`:

```bash
promtool check rules examples/agents/prometheus-agent-alerts.yaml
promtool test rules examples/agents/prometheus-agent-alerts.test.yaml
```

Временные ряды проверены на официальном Prometheus **3.16.0**: 14 правил, положительный и отрицательный случай для каждого, отдельный случай отсутствующего ряда. Тесты фиксируют пороги, `for`, offset baseline, labels и annotations. Они не проверяют exporter, authoritative join и доставку до owner. Для бинарника сверяйте checksum из [официального release](https://github.com/prometheus/prometheus/releases/tag/v3.16.0); версия tool зафиксирована для воспроизводимости, а не как требование обновить рабочий мониторинг.

<a id="6-protokol-i-polnomocia"></a>

## 6. Протокол и полномочия

[MCP Authorization, версия 2026-07-28](https://modelcontextprotocol.io/specification/2026-07-28/basic/authorization), описывает flow для HTTP transport. Успешная аутентификация клиента, discovery или получение tool list не означает согласование бизнес-операции. Проверяйте audience/resource, issuer и актуальный scope в transport adapter; object/tenant policy, action-bound approval и результат операции проверяются отдельно. Для STDIO и другого транспорта фиксируют собственный способ выдачи credentials и изоляции. Версия схемы этого каталога не является версией протокола.

Критерий приёмки комплекта: JSON/YAML разбираются, оба schema проходят meta-validation, положительные и отрицательные примеры дают ожидаемый результат, semantic fixtures отклоняют нарушения связей/времени, а runtime integration отдельно подтверждает реальные deny, revoke, cancel, readback и границы памяти. Локальный self-test этих интеграций не доказывает.
