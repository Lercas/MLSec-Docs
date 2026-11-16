<a id="opa-rego-politiki-dla-ml-secops"></a>

# OPA / Rego политики для ML SecOps

> Версия: 1.2 · Проверено 2026-11-13 на OPA 1.22.4, Rego v1. Существующие `future.keywords.*` оставлены для совместимости исходных примеров; новые тесты используют `import rego.v1`.

Исполняемые примеры решений для ML gate, LLM gateway, агентов и supply chain. Это внутренние политики с демонстрационными порогами, не нормативное заключение и не готовые Gatekeeper ConstraintTemplate/Envoy adapters. OPA вычисляет решение по фактам: подпись, права, происхождение, freshness и effect-readback должен устанавливать доверенный verifier/broker.

<a id="sostav"></a>

## Состав

| Файл | Назначение | Точка применения |
|---|---|---|
| [model-deployment.rego](model-deployment.rego) | Проверка готовности модели к promote в prod | CI/CD gate перед rollout, OPA Gatekeeper |
| [data-governance.rego](data-governance.rego) | Validator Data Card, классификация K0-K4, правовое основание | CI/CD на commit Data Card, реестр обработки ПДн |
| [llm-gateway.rego](llm-gateway.rego) | Матрица «роль × класс данных × модель», rate-limits | Inline в LLM gateway (Istio / Envoy ExtAuthz / собственный) |
| [agent-tool.rego](agent-tool.rego) | HITL-требования, allowlist tools, broker-policy | Agent broker перед выполнением tool call |
| [supply-chain.rego](supply-chain.rego) | Только подписанные images, обязательный ML-BOM, проверенные базы | OPA Gatekeeper / admission webhook / CI/CD |
| [dlp-classification.rego](dlp-classification.rego) | Маппинг классов данных на разрешённые действия | DLP engine, LLM gateway |
| [tests/](tests/) | Synthetic regression: положительные/отрицательные решения, action binding, неизвестный контекст | Локально / изолированный CI; не live enforcement |

<a id="zapusk-testov"></a>

## Запуск тестов

```bash
# Linux CI: obtain OPA_SHA256 from a verified platform-owned manifest.
# Do not download the binary to ./opa: that path is the policy directory.
bash ci/scripts/install-opa.sh /tmp/mlsec-opa

# Запустить все тесты
/tmp/mlsec-opa check --strict opa/
/tmp/mlsec-opa test opa/ -v

# Оценить конкретный пакет
/tmp/mlsec-opa eval --format=json -d opa/llm-gateway.rego -i test-input.json "data.ml.llm_gateway.allow" > decision.json
jq -e '.result[0].expressions[0].value == true' decision.json

# Bundle для сервера
/tmp/mlsec-opa build -o /tmp/mlsec-policy-bundle.tar.gz opa/llm-gateway.rego
```

<a id="integrazia"></a>

## Интеграция

<a id="llm-gateway-envoy-extauthz"></a>

### LLM Gateway (Envoy ExtAuthz)

Фрагмент фильтра, не полный bootstrap Envoy. Нужен **OPA-Envoy plugin**, gRPC cluster `opa`, mapping CheckRequest → вход этой политики и plugin path решения. Обычный OPA HTTP server не реализует ExtAuthz. При timeout/ошибке/undefined executor должен запретить действие; проверка только наличия HTTP 200 недостаточна.

```yaml
http_filters:
  - name: envoy.filters.http.ext_authz
    typed_config:
      "@type": type.googleapis.com/envoy.extensions.filters.http.ext_authz.v3.ExtAuthz
      failure_mode_allow: false
      grpc_service:
        envoy_grpc:
          cluster_name: opa
      transport_api_version: V3
```

<a id="kubernetes-opa-gatekeeper"></a>

### Kubernetes (OPA Gatekeeper)

```bash
# Prepare this in the integration repository, not from this directory.
helm template gatekeeper gatekeeper/gatekeeper --version "${GATEKEEPER_CHART_VERSION:?pin reviewed chart version}" > rendered-gatekeeper.yaml
# First create ConstraintTemplate/Constraint and an input.review adapter.
# Those files are not supplied here. Do not pass AdmissionReview directly
# to policies expecting input.model / input.dataset / input.deployment.
```

<a id="cicd-github-actions-gitlab-ci"></a>

### CI/CD (GitHub Actions, GitLab CI)

См. [../ci/](../ci/) пример пайплайна с проверкой OPA на каждый PR.

<a id="kontrakt-doveria-evidence-i-recovery"></a>

## Контракт доверия, evidence и recovery

| Пакет | Обязательные факты / ограничение |
|-------|----------------------------------|
| `ml.agent_tool` | Проверенный broker context; principal/tenant/action_id, registry-owned tool/schema/risk class, canonical args digest. Для side effects approval совпадает по всем полям, свежий и не consumed |
| `ml.deployment` | Digest модели, trusted signer, numeric metrics, Tier 1–4, актуальное verifier evidence с digest и `data.deployment_policy_revision`; `data.trusted_signers` задаёт platform owner |
| `ml.supply_chain` | Registry host без suffix confusion, digest-bound complete scan/freshness, validated SBOM; ML-service требует непустой model inventory и ML-BOM с явно поддерживаемой specVersion |
| `ml.data_governance` | Data Card, цель, SHA-256, verified purpose-bound evidence, retention/storage и privacy declarations; `legal.localization_assessed/ru_localization_required` определяются внешней оценкой. Проверка полей не доказывает отсутствие ПДн или законность основания |
| Gateway / DLP | Полный kill-switch/scan state; бюджет участвует в allow. DLP имеет однозначный приоритет: strict block → разрешённый internal mask fallback → матрица |

`verified` должен означать результат независимой проверки, а не поле, которое model/PR может записать себе. Custom input/evidence — локальный контракт примеров; это не JSON CycloneDX и не поля MCP. Порог accuracy/fairness, срок approval и retention здесь — примеры внутренней политики. Отсутствующий документ, unknown Tier, stale evidence или scanner outcome не превращаются в положительное решение.

Перед выполнением broker повторно проверяет права/kill-switch и **атомарно** резервирует бюджет, action_id/idempotency key и consume approval. OPA не хранит эти изменения. Нормализация URL/email, DNS/IP/redirect/SSRF enforcement, SQL parsing и запрет альтернативных execution paths находятся вне Rego. Сетевой пример ожидает lowercase hostname без scheme/port; allowlist — домены без ведущей точки. Regex SQL — дополнительная эвристика; все `sql_execute/db_query/git_push/send_*` в примере консервативно требуют action-bound approval независимо от risk label.

После timeout/cancel неизвестный эффект сверяется с target/job registry; повтор не должен дублировать действие. Revocation/retirement останавливает новые и queued jobs, отдельно сверяет running jobs и отозванные credentials. Логируйте decision/action IDs, policy revision, digest и outcome; не сырые SQL/токены/PII. `mask` требует реально работающего masker; при его отказе отправка блокируется.

Источники, проверены 13.11.2026: [OPA language](https://www.openpolicyagent.org/docs/policy-language), [testing](https://www.openpolicyagent.org/docs/policy-testing), [OPA-Envoy](https://www.openpolicyagent.org/docs/envoy), [Gatekeeper templates](https://open-policy-agent.github.io/gatekeeper/website/docs/constrainttemplates/). Официальная [CycloneDX 1.7](https://cyclonedx.org/docs/1.7/json/) не делает 1.5-input автоматически конвертированным: схема проверяется внешним verifier, policy допускает только заявленные 1.5/1.6/1.7.

<a id="svazi"></a>

## Связи

- [Глава 05. Deployment Security](../05-stage3-model-deployment.md)
- [Глава 08. Управление доступом и секретами](../08-access-secrets-management.md)
- [Глава 09. Threat Modeling](../09-threat-modeling.md)
- [Глава 12. CI/CD и защита LLM](../12-detection-protection-cicd-llm.md)
- [templates/AI-USE-POLICY-TEMPLATE.md](../templates/AI-USE-POLICY-TEMPLATE.md) (матрица K × Модель)
