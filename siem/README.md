<a id="siem-pravila-dla-mlai-inzidentov"></a>

# SIEM правила для ML/AI-инцидентов

> Версия: 1.2 · Проверено 2026-11-13

Экспериментальные правила и заготовки ML-детектирования. Нужны local field mapping, enrichment и replay на событиях своей платформы:

- **Sigma** (vendor-neutral, конвертируется в Splunk / Elastic / Sentinel / Chronicle через sigma-cli или uncoder.io).
- **SPL** (Splunk Search Processing Language): запросы с локальными macros/data model, которые нужно создать; backend execution здесь не проверен.
- **KUMA** (Kaspersky Unified Monitoring and Analysis): XML **псевдокод логики**, не экспортируемый/импортируемый ресурс KUMA. Все `<enabled>` отключены; пример SOAR action не разрешает автоматическое исполнение.

<a id="karta-pravil"></a>

## Карта правил

| ID | Название | Sigma | SPL | KUMA | Playbook |
|---|---|---|---|---|---|
| ml-01 | Pipeline Tampering (неподписанное изменение) | [sigma/ml-01-pipeline-tampering.yml](sigma/ml-01-pipeline-tampering.yml) | [splunk/ml-01-pipeline-tampering.spl](splunk/ml-01-pipeline-tampering.spl) | [kuma/ml-01-pipeline-tampering.xml](kuma/ml-01-pipeline-tampering.xml) | [IR-01](../playbooks/IR-01-data-poisoning.md) |
| ml-02 | Drift Anomaly (аномалия распределения модели) | [sigma/ml-02-drift-anomaly.yml](sigma/ml-02-drift-anomaly.yml) | [splunk/ml-02-drift-anomaly.spl](splunk/ml-02-drift-anomaly.spl) | [kuma/ml-02-drift-anomaly.xml](kuma/ml-02-drift-anomaly.xml) | [IR-01](../playbooks/IR-01-data-poisoning.md) |
| ml-03 | Extraction Pattern (паттерн query-based извлечения) | [sigma/ml-03-extraction-pattern.yml](sigma/ml-03-extraction-pattern.yml) | [splunk/ml-03-extraction-pattern.spl](splunk/ml-03-extraction-pattern.spl) | [kuma/ml-03-extraction-pattern.xml](kuma/ml-03-extraction-pattern.xml) | [IR-02](../playbooks/IR-02-model-extraction.md) |
| ml-04 | Artifact Exfiltration (вынос весов/моделей) | [sigma/ml-04-artifact-exfiltration.yml](sigma/ml-04-artifact-exfiltration.yml) | [splunk/ml-04-artifact-exfiltration.spl](splunk/ml-04-artifact-exfiltration.spl) | [kuma/ml-04-artifact-exfiltration.xml](kuma/ml-04-artifact-exfiltration.xml) | [IR-02](../playbooks/IR-02-model-extraction.md) |
| llm-01 | Prompt Injection Attempt | [sigma/llm-01-injection-attempt.yml](sigma/llm-01-injection-attempt.yml) | [splunk/llm-01-injection-attempt.spl](splunk/llm-01-injection-attempt.spl) | [kuma/llm-01-injection-attempt.xml](kuma/llm-01-injection-attempt.xml) | [IR-03](../playbooks/IR-03-prompt-injection-campaign.md) |
| llm-02 | Guardrails Bypass | [sigma/llm-02-guard-bypass.yml](sigma/llm-02-guard-bypass.yml) | [splunk/llm-02-guard-bypass.spl](splunk/llm-02-guard-bypass.spl) | [kuma/llm-02-guard-bypass.xml](kuma/llm-02-guard-bypass.xml) | [IR-03](../playbooks/IR-03-prompt-injection-campaign.md) |
| llm-03 | System Prompt Leak в ответе | [sigma/llm-03-system-prompt-leak.yml](sigma/llm-03-system-prompt-leak.yml) | [splunk/llm-03-system-prompt-leak.spl](splunk/llm-03-system-prompt-leak.spl) | [kuma/llm-03-system-prompt-leak.xml](kuma/llm-03-system-prompt-leak.xml) | [IR-03](../playbooks/IR-03-prompt-injection-campaign.md) |
| agent-01 | Agent Destructive Action без HITL | [sigma/agent-01-destructive-action.yml](sigma/agent-01-destructive-action.yml) | [splunk/agent-01-destructive-action.spl](splunk/agent-01-destructive-action.spl) | [kuma/agent-01-destructive-action.xml](kuma/agent-01-destructive-action.xml) | [IR-04](../playbooks/IR-04-agentic-breach.md) |
| agent-02 | Agent Tool Abuse (скачок tool calls) | [sigma/agent-02-tool-abuse.yml](sigma/agent-02-tool-abuse.yml) | [splunk/agent-02-tool-abuse.spl](splunk/agent-02-tool-abuse.spl) | [kuma/agent-02-tool-abuse.xml](kuma/agent-02-tool-abuse.xml) | [IR-04](../playbooks/IR-04-agentic-breach.md) |
| agent-03 | Agent Egress Anomaly | [sigma/agent-03-egress-anomaly.yml](sigma/agent-03-egress-anomaly.yml) | [splunk/agent-03-egress-anomaly.spl](splunk/agent-03-egress-anomaly.spl) | [kuma/agent-03-egress-anomaly.xml](kuma/agent-03-egress-anomaly.xml) | [IR-04](../playbooks/IR-04-agentic-breach.md) |
| shadow-01 | Shadow AI: external LLM domain | [sigma/shadow-01-external-llm.yml](sigma/shadow-01-external-llm.yml) | [splunk/shadow-01-external-llm.spl](splunk/shadow-01-external-llm.spl) | [kuma/shadow-01-external-llm.xml](kuma/shadow-01-external-llm.xml) | [IR-05](../playbooks/IR-05-shadow-ai-leak.md) |
| shadow-02 | Shadow AI: SaaS AI tool через SSO | [sigma/shadow-02-saas-ai-tool.yml](sigma/shadow-02-saas-ai-tool.yml) | [splunk/shadow-02-saas-ai-tool.spl](splunk/shadow-02-saas-ai-tool.spl) | [kuma/shadow-02-saas-ai-tool.xml](kuma/shadow-02-saas-ai-tool.xml) | [IR-05](../playbooks/IR-05-shadow-ai-leak.md) |
| shadow-03 | API-ключ LLM-провайдера в коде | [sigma/shadow-03-api-key-in-repo.yml](sigma/shadow-03-api-key-in-repo.yml) | [splunk/shadow-03-api-key-in-repo.spl](splunk/shadow-03-api-key-in-repo.spl) | [kuma/shadow-03-api-key-in-repo.xml](kuma/shadow-03-api-key-in-repo.xml) | [IR-05](../playbooks/IR-05-shadow-ai-leak.md) |

<a id="neobhodimye-istocniki-dannyh"></a>

## Необходимые источники данных

| Сигнал | Нормализация и граница вывода |
|--------|------------------------------|
| `agent-01` | Trusted broker пишет `hitl.required` и `approval.validation=verified/invalid/missing/expired/replayed/unknown` после проверки action/principal/tenant/tool/schema/args digest и one-time approval. Булево `confirmed=true` недостаточно |
| [agent-04 Sigma](sigma/agent-04-outcome-unknown.yml) / [SPL](splunk/agent-04-outcome-unknown.spl) | Reconciler публикует overdue unknown effect после timeout/cancel; необходимо readback целевой системы, не blind retry |
| `agent-02`, `ml-03` Sigma | `calls_per_minute`, RPS/entropy/pattern scores и 24h counters вычисляет upstream. Condition оценивает **одно** enrichment-событие, а не автоматически коррелирует историю |
| `llm-02` | Pre-guard allow + post-DLP block означает несогласованность защит. Если DLP успел заблокировать доставку, факта утечки ещё нет; нужны stream/tool/egress evidence |
| `ml-02`, `ml-03`, `ml-04` | Drift, похожий querying и большой GetObject — гипотезы, не доказательство poisoning/extraction/exfiltration; проверяются разрешённый контекст и целевой эффект |

ID Sigma теперь UUID; прежние человекочитаемые ID сохранены в `name`, именах файлов и SPL detection. При импорте обновите внешние ссылки на UUID, чтобы не задвоить alert rules. Таксономические tags из ранних примеров не подтверждают актуальность MITRE/OWASP mapping: закрепите редакцию в локальном detection catalog.

- **LLM gateway / прокси**: структурированные логи IDs, model/provider revision, guard result, token usage, tool/action IDs, duration, policy revision. Raw `prompt`/`response` по умолчанию не собираются; сигнатуры/сходство можно вычислять до редактирования с отдельным правовым основанием и доступом к raw evidence только при необходимости.
- **MLflow / W&B / Airflow**: события о запуске обучения, создании модели, версионировании.
- **DVC / lakeFS / Model Registry**: события о изменении датасетов и моделей.
- **Kubernetes audit log**: pod exec, kubectl port-forward, изменения в DAG.
- **Prometheus / mimir**: метрики модели (accuracy, latency, PSI), KS-test, drift.
- **Object storage (S3 / MinIO / Artifactory)**: access-log, объёмы GET-запросов.
- **CASB / egress proxy (Squid, Palo Alto, Zscaler, Netskope)**: HTTP(S) трафик с категоризацией доменов.
- **EDR (Crowdstrike, SentinelOne, Kaspersky EDR)**: endpoint-события.
- **Git / GitLab / GitHub Enterprise**: commit hooks, push events.
- **Cloud provider audit (AWS CloudTrail, YC Audit Trails, SberCloud Audit)**: API-активность сервис-аккаунтов.

При mapping используйте закреплённую редакцию [OpenTelemetry GenAI Semantic Conventions](https://github.com/open-telemetry/semantic-conventions-genai): отдельные поля могут иметь разную stability, а legacy `gen_ai.system` не следует механически переносить в новый exporter. Snapshot и Development status описаны в [главе 06](../06-stage4-operations-platform.md); поддержка конкретной instrumentation проверяется отдельно. Наши `approval.*`, `action.*`, `policy.*`, `evidence.*` — локальный контракт, не обещание стандарта OTel/MCP. В timestamps различайте event time и ingestion time; tenant/principal/session/task/action/job IDs имеют разные назначения и не заменяют авторизацию.

<a id="kak-ispol_zovat_-sigma"></a>

## Как использовать Sigma

```bash
# Конвертация в Splunk
pip install sigma-cli pysigma-backend-splunk
sigma convert -t splunk siem/sigma/ml-03-extraction-pattern.yml

# Конвертация в Microsoft Sentinel
# Install the required backend and your field-mapping pipeline.
# Check available names with sigma list pipelines for the pinned version.

# Конвертация в Elasticsearch DSL
# A Windows ECS pipeline does not map agent-broker events.
```

<a id="nastrojka-kuma"></a>

## Настройка KUMA

По [официальной документации correlation rules](https://support.kaspersky.com/KUMA/3.0.1/en-US/217783.htm) правило — ресурс с зависящими от типа настройками; он связывается с correlator в [Correlation step](https://support.kaspersky.com/KUMA/3.0.1/en-US/221168.htm). Наши XML не проверялись по схеме экспорта KUMA и не должны импортироваться как native configuration. Перенесите selectors/grouping/windows в ресурс своей версии, настройте normalizer/enrichment, затем replay positive/negative события. `CustomString*` здесь условные позиции, не универсальный mapping. SOAR revoke/kill-switch сначала проходит preview/approval по точному principal/resource, затем выполняется отдельной scoped identity с readback и планом восстановления.

<a id="porogi-i-tuning"></a>

## Пороги и тюнинг

<a id="proverka-effekta-unknown-i-recovery"></a>

### Проверка эффекта, unknown и recovery

Локальная проверка формы всех Sigma и 43 synthetic cases (approval/reconciliation и полная таблица 3-of-5):

```bash
uv run --no-project --with pysigma --with pysigma-backend-splunk python siem/tests/synthetic_replay.py
```

Replay выполняет ограниченный AST subset через pySigma и отклоняет неизвестные node types; он не эмулирует Splunk/KUMA. Случай отсутствующего `approval.validation` намеренно **не совпадает** с rule: потерю enrichment должен поднять отдельный coverage monitor.

Для synthetic replay достаточно `{case_id, rule name/UUID/revision, source schema, expected match, actual, owner, evidence_ref}`; исходные секреты и ПДн не нужны. Обязательные пары: изменённый approval digest против неизменённого; неизвестный outcome против reconciled; allowed hostname против `evilexample.org`; false/missing scanner outcome против подтверждённого clean scan. Missing fields проверяйте отдельно: отсутствие события не равно отсутствию эффекта. Настройте heartbeat/coverage alert источников, lag, dedup и retention.

Alert хранит redacted evidence и IDs. При response не повторяйте side effect по timeout: сначала target/job readback и проверка idempotency. Для false positive не отключайте глобальную защиту: scoped exception имеет owner/expiry/evidence. После изменения field mapping, provider/schema, tool permissions или collector повторите replay. При retirement снимите rule/route, SOAR credentials и queued jobs по отдельному change; сохраните evidence по установленному сроку.

Проверка pySigma parsing/conversion подтверждает форму правила, не field coverage, detection recall или native backend execution. XML parse подтверждает только XML well-formedness. Официальные ориентиры: [Sigma rules](https://sigmahq.io/docs/basics/rules.html), [modifiers](https://sigmahq.io/docs/basics/modifiers.html), [correlations](https://sigmahq.io/docs/meta/correlations.html), проверены 13.11.2026.

Первые 7-14 дней после деплоя рекомендуется запускать правила в shadow-режиме (без алертов, только логирование) для калибровки порогов под организацию. Ключевые параметры указаны в комментариях в каждом правиле.

<a id="svazi"></a>

## Связи

- [playbooks/](../playbooks/): процедуры реагирования на каждое срабатывание.
- [Глава 06. Operations Platform](../06-stage4-operations-platform.md): мониторинг и метрики.
- [Глава 15. AI Incident Response](../15-ai-incident-response.md).
- [Глава 23. MITRE ATLAS RU](../23-mitre-atlas-ru.md): маппинг на MITRE ATLAS v5.4.
