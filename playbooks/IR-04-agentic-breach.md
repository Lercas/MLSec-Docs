<a id="ir-04-agentic-breach-agent-vypolnil-nesankzionirovannoe-dejstvie"></a>

# IR-04. Agentic Breach (агент выполнил несанкционированное действие)

> Severity: SEV1 (Critical) по умолчанию. Любое необратимое действие агента в продуктиве требует немедленной эскалации.
>
> SLA containment: 15 минут. SLA полного закрытия: 10 рабочих дней.

<a id="1-opredelenie-i-priznaki"></a>

## 1. Определение и признаки

Agentic Breach: ИИ-агент (с доступом к tools, API, БД, файлам, email) выполнил действие, которое нарушает политику безопасности или привело к ущербу. Исторический пример: в июле 2025 Replit подтвердил удаление агентом данных приложения Jason Lemkin и сообщил об их полном восстановлении; см. [заявление Replit от 29.07.2025](https://replit.com/blog/doubling-down-on-our-commitment-to-secure-vibe-coding), проверено 13.11.2026. Ниже — учебные сценарии, а не атрибутированные исторические случаи:
- Agent, обладавший write-tools для Git, запушил изменения в защищённую ветку.
- LLM-агент через tool `send_email` отправил PII внешнему адресату.
- Agent в облачной консоли удалил S3 bucket.
- Agent выполнил `rm -rf` или `DROP TABLE` в результате prompt injection или галлюцинации.

Частые первопричины: (а) prompt injection (см. IR-03), (б) галлюцинация плана, (в) недостаточная изоляция tools, (г) отсутствие HITL для побочных эффектов, (д) ошибка в инструкциях системы, (е) Lethal Trifecta (untrusted input × sensitive data × external action).

<a id="11-triggery-obnarujenia-ioc"></a>

### 1.1. Триггеры обнаружения (IoC)

- Алерт audit log действия, выполненного от имени сервис-аккаунта агента.
- Аномальная активность агента (высокий rate tool calls, неожиданные tools).
- Tool-use audit показывает вызов `destructive` tools (delete, drop, truncate, send) без соответствующего HITL-подтверждения.
- Резкое изменение состояния системы (missing rows, deleted files, blocked users), совпадающее по времени с активностью агента.
- Отчёт пользователя / жалоба.
- Нарушение broker policy / OPA policy в gateway агента.
- Алерт cloud provider (AWS CloudTrail, Azure Activity Log, GCP Cloud Audit Logs) о операции со стороны сервис-аккаунта агента.

<a id="12-istocniki-dannyh"></a>

### 1.2. Источники данных

- Agent trace: session / action IDs, доступные сообщения, tool calls и результаты, версии model / prompt / policy. Скрытая chain of thought не требуется и не заменяет audit исполнителя.
- Broker / gateway audit log (какие запросы пропущены, какие блокированы).
- Cloud provider audit log (CloudTrail, Activity Log, Audit Logs).
- Git / GitLab audit (commits, pushes, branch changes).
- Database audit (slow query log, binlog, audit plugin, DDL changes).
- Email / messaging audit (отправленные сообщения).
- Filesystem audit (auditd, Windows Security log).
- SIEM: корреляция user - agent session - action - impact.
- Доступные application logs: минимально необходимый контекст и план, если он явно сохранён приложением; без предположения о доступности внутреннего reasoning модели.

---

<a id="2-podgotovka-preparation"></a>

## 2. Подготовка (Preparation)

- [ ] Все агенты зарегистрированы в Agent Registry: owner, назначение, доступные tools, Tier.
- [ ] Broker pattern обязателен: агент не имеет прямого доступа к критичным системам, только через broker с policy-enforcement.
- [ ] Все tool calls логируются в SIEM.
- [ ] Destructive actions (delete, drop, truncate, send email / money / api-to-client) требуют HITL (human in the loop) или explicit allow-list.
- [ ] Сервис-аккаунты агентов имеют минимальные права (principle of least privilege).
- [ ] Kill-switch L4 настроен и протестирован: можно остановить конкретного агента или все агенты.
- [ ] Отдельно проверены approval перед действием и идемпотентность повторов у исполнителя; подтверждение человеком не предотвращает дублирование само по себе.
- [ ] Rate-limit на tool calls (max N calls / minute, max N destructive ops / day).
- [ ] Для cloud agents: IAM role scoped down с conditions на IP / tags / время.
- [ ] SIEM-правила: `agent-01-destructive-action`, `agent-02-tool-abuse`, `agent-03-egress-anomaly`.
- [ ] Rollback / restore процедуры отработаны (БД, файлы, конфиги).

---

<a id="3-detection-amp-analysis"></a>

## 3. Detection & Analysis

<a id="31-triaj-l1-0-15-minut-kriticnaa-skorost_"></a>

### 3.1. Триаж (L1, 0-15 минут) / КРИТИЧНАЯ СКОРОСТЬ

1. Идентифицировать агента: Agent ID, версия, владелец, Tier.
2. Немедленно ограничить новые действия конкретного агента через предусмотренный kill-switch / executor deny; не ждать полной оценки ущерба.
3. Определить затронутые системы: записи, файлы, внешние jobs, scheduler / retry.
4. Оценить обратимость и сохранение evidence: backup / replica / snapshot не доказывают возможность отменить внешний эффект.
5. Открыть инцидент `ML-AGENT-BREACH`, SEV1.
6. Уведомить: on-call engineer владельца системы, ML Tech Lead, CISO.

<a id="32-analiz-l2-mlsec-analyst-on-call-vladel_za-sistemy-15-60-minut"></a>

### 3.2. Анализ (L2 MLSec Analyst + on-call владельца системы, 15-60 минут)

1. **Восстановить timeline**:
   - Запрос пользователя.
   - Шаги reasoning агента (если доступны).
   - Цепочка tool calls.
   - Action outcome.
   - Последствия в целевой системе.
2. **Root cause**:
   - Prompt injection? (см. IR-03 для техники).
   - Галлюцинация плана (модель решила, что нужно удалить).
   - Ошибка в инструкциях системы / prompt template.
   - Превышение прав tool (tool сделал больше, чем должен).
   - Отсутствующий HITL для critical op.
   - Compromised MCP server / third-party integration.
3. **Оценить объём ущерба**:
   - Количество удалённых / изменённых записей.
   - Количество получателей (для email / message).
   - Деньги (для финансовых tools).
   - Репутация / юр. последствия.
4. **Подтвердить изоляцию**: этот инцидент только в одном agent или в целой категории (тот же prompt template, тот же MCP)?
5. **Связанные агенты**: другие агенты, использующие тот же tool / template / model, потенциально уязвимы.

<a id="33-klassifikazia"></a>

### 3.3. Классификация

| Признак | SEV1 | SEV2 |
|---|---|---|
| Побочный эффект | Необратимое удаление данных, отправка внешним контрагентам | Внутренние изменения, отрабатываемые через rollback |
| Масштаб | Prod, массовое воздействие | Staging / dev или ограниченное воздействие |
| Обратимость | Restore из backup занимает часы, часть данных потеряна | Восстановление быстрое и полное |

(SEV3 для этого типа инцидентов практически не применяется: любой подтверждённый breach агента - минимум SEV2.)

---

<a id="4-containment-kriticnaa-skorost_"></a>

## 4. Containment (КРИТИЧНАЯ СКОРОСТЬ)

<a id="41-nemedlennye-dejstvia-0-15-minut"></a>

### 4.1. Немедленные действия (0-15 минут)

1. **Kill-switch L4**: немедленно остановить конкретного агента.
2. **Определить связанную границу**: IC расширяет остановку на общий template / tool / MCP при обоснованном риске, фиксирует scope и влияние на разрешённые процессы. Неизвестный root cause сам по себе не требует автоматического выключения всех агентов организации.
3. **Revoke credentials**: отозвать API keys, sessions, refresh tokens, delegated grants и leases в затронутой границе; IAM owner подтверждает отказ старого доступа у получателей.
4. **Заблокировать destructive tools** на executor затронутых сценариев; глобальное отключение — отдельное решение IC при общем риске.
5. **Freeze affected systems**: если агент работал с БД - создать snapshot / перевести в read-only, поставить pause на pipeline.
6. **Уведомить**: ML Tech Lead, CISO, owner затронутой системы, AI Risk Committee.

<a id="42-takticeskie-dejstvia-15-min-4-casa"></a>

### 4.2. Тактические действия (15 мин - 4 часа)

1. **Сверить последствия с владельцами систем**: определить committed / pending / unknown операции до повтора или компенсации. Restore БД, revert Git и отмена сообщения требуют отдельного плана, чтобы не затереть законные изменения; локальное unsend не доказывает отсутствие копии у получателя.
2. **Уведомить затронутых пользователей / контрагентов**: если агент отправил внешнее сообщение / транзакцию / shared document.
3. **Снять образ окружения агента** для форензики: container image, logs, state, vector DB memory, conversation history.
4. **Анализ связанных агентов**: тот же template / tool / model используется ещё? Аудит прав.
5. **Ужесточить broker policy**: временно запретить destructive tools, ввести HITL для всех write-операций связанных агентов.
6. Для финсектора / КИИ: проверить основания и сроки уведомлений по [главе 18](../18-ru-compliance-deep.md), а не по одному внутреннему уровню SEV.
7. Юр. служба: оценка ответственности, уведомление пострадавших третьих сторон.

---

<a id="5-eradication-amp-recovery"></a>

## 5. Eradication & Recovery

<a id="51-eradication-dni-1-5"></a>

### 5.1. Eradication (дни 1-5)

1. **Root cause confirmed**:
   - Prompt injection: применить меры из IR-03.
   - Галлюцинация: настроить constrained generation, plan validation, self-critique.
   - Tool overreach: sandbox tool, scope down permissions, add validation.
   - Missing HITL: ввести обязательное подтверждение для этого класса операций.
   - Compromised MCP: см. [безопасность коннекторов](../33-ai-agents-security-overlay.md) и [agent incident playbook](../35-ai-agents-incident-playbook.md).
2. **Архитектурные изменения**:
   - Broker pattern обязателен для всех агентов с write-доступом.
   - OPA policy: declarative whitelist действий.
   - Principle of least privilege: пересмотр всех сервис-аккаунтов.
   - Idempotency: устойчивый action ID / ключ у поддерживающего его получателя, сверка статуса перед повтором. Staging и approval — отдельные меры; 2-phase commit доступен не для каждого внешнего API.
3. **Восстановление систем**:
   - БД: restore из backup, reconciliation с journal / event sourcing.
   - Files: restore из snapshot / git history.
   - Контрагенты: извинения, компенсация, откат договорных действий.

<a id="52-recovery-dni-3-10"></a>

### 5.2. Recovery (дни 3-10)

1. Новая версия агента проходит полный adversarial test suite:
   - Prompt injection regression.
   - Tool abuse tests.
   - Plan hallucination tests.
   - Least privilege audit.
2. Дополнительный security review от ML SecOps Board.
3. Canary-rollout: ограниченная группа пользователей, 100% HITL, ужесточённый мониторинг.
4. Изменение HITL утверждает владелец сценария на основании evidence и оценки риска; истечение validation period само по себе не снимает подтверждения.
5. Обновлённая Agent Card / Model Card с уроками инцидента.

---

<a id="53-ucenie-ostanovlen-runtime-vnesnij-export-prodoljaetsa"></a>

### 5.3. Учение: остановлен runtime, внешний export продолжается

**Fixture**: изолированный broker и тестовый получатель с журналом операций. Export принят получателем, ответ потерян, scheduler пытается повторить job после перезапуска. Реальные адреса, деньги и production credentials отсутствуют. Владелец интеграции заранее задаёт способ readback; IC — условия остановки учения.

1. Остановить новые действия агента и scheduled retry; сохранить action ID, external job ID и прежний approval revision.
2. Получить timeout: записать `unknown`, не считать его успехом отмены и не повторять export.
3. Проверить job непосредственно у тестового получателя. Если уже завершён — учесть созданный объект и доступ к нему; если отменён — сохранить terminal state. При недоступности получателя оставить owner и срок следующей сверки.
4. Перезапустить агент с прежней сессией / approval: executor должен отказать до нового допуска. Новый разрешённый read-only сценарий должен работать после допуска.

**Приёмка**: нет второго export, старые полномочия не ожили, статус внешнего объекта подтверждён независимо от agent trace. Evidence pack: broker audit, readback получателя, отмена расписания, deny-test прежней сессии; подписывают integration owner и IC. По MCP cancellation может проиграть гонку завершению и не заменяет эту сверку: [общие условия IR](README.md), проверено **13.11.2026**.

Пример записи для tabletop, **не схема API или конфигурация конкретного продукта**. `unknown` остаётся открытым даже после остановки runtime; ссылку на readback добавляют после фактической сверки.

```json
{
  "action_id": "exercise-export-001",
  "external_job_id": "fixture-job-017",
  "runtime_state": "stopped",
  "outcome": "unknown",
  "automatic_retry_allowed": false,
  "owner": "integration-oncall",
  "next_readback_at": "2026-11-13T18:30:00Z",
  "evidence_ref": "exercise://S7/broker-audit/001"
}
```

<a id="6-post-incident-activity"></a>

## 6. Post-Incident Activity

<a id="61-obazatel_nye-artefakty-v-tecenie-15-rabocih-dnej"></a>

### 6.1. Обязательные артефакты (в течение 15 рабочих дней)

- [ ] Detailed incident report (timeline, root cause, impact, recovery actions).
- [ ] Обновлённая Agent Card / Model Card.
- [ ] Обновлённый Agent threat model.
- [ ] Обновлённые SIEM-правила.
- [ ] Обновлённый adversarial test suite.
- [ ] Public post-mortem (если затронуты клиенты).
- [ ] Уведомления РКН (при ПДн), ФинЦЕРТ (банкинг), ГосСОПКА (КИИ).
- [ ] Lessons Learned с ML-командой, ИБ, DevOps, SRE, юр. службой.
- [ ] Обновлённый AI Use Policy (если обнаружен систематический пробел).

<a id="62-metriki"></a>

### 6.2. Метрики

- Time to Detect, Time to Contain (ожидание: contain < 15 минут).
- Data loss (записей, файлов, денег).
- Number of affected users / counterparties.
- Recovery Time Objective достигнут / нет.
- Coverage HITL для destructive ops (до / после).

---

<a id="7-eskalazionnaa-zepocka"></a>

## 7. Эскалационная цепочка

```
Детектор агента / SOC L1 (обнаружение)
    ↓ [любой подтверждённый breach]
Kill-switch L4 немедленно
    ↓
MLSec Analyst L2 + owner затронутой системы (анализ)
    ↓ [всегда для SEV1]
ML Tech Lead + CISO + AI Risk Committee + CEO
    ↓ [регуляторика / публичность / сторонние пострадавшие]
РКН / ФинЦЕРТ / ГосСОПКА / клиенты / правоохранители
```

---

<a id="8-svazi"></a>

## 8. Связи

- [Глава 10. Защита LLM-агентов](../10-llm-agent-protection.md)
- [Глава 33. AI-агенты: security overlay](../33-ai-agents-security-overlay.md) (изоляция коннекторов, MCP)
- [Глава 15. AI Incident Response](../15-ai-incident-response.md)
- [Глава 34. AI-агенты: runtime procedure](../34-ai-agents-runtime-procedure.md) (kill-switch)
- [Глава 23. MITRE ATLAS RU](../23-mitre-atlas-ru.md)
- OWASP Top 10 for Agentic Applications (2026): ASI01 Agent Goal Hijack, ASI02 Tool Misuse & Exploitation, ASI03 Identity & Privilege Abuse, ASI06 Memory & Context Poisoning.
- Референс: Replit Agent incident (July 2025), MCP Tool Poisoning (Invariant Labs 2025).
