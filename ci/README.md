<a id="cicd-pipelines-dla-mlsec"></a>

# CI/CD Pipelines для MLSec

> Версия: 1.2 · Проверено 2026-11-13

Интеграционные заготовки GitHub Actions/GitLab CI для стадий 04–06, 12. Они **не являются готовым deployment этого репозитория**: training/model registry, `scripts/build_opa_input.py`, scanners, `redteam/`, `configs/`, `k8s/` и runner images предоставляет проект внедрения. Исполняемая автономная часть здесь — OPA policies/tests и checksum-verified installer. Скопированные workflows по умолчанию требуют opt-in; они не устанавливаются в `.github/workflows` автоматически.

<a id="sostav"></a>

## Состав

| Файл | Платформа | Назначение |
|---|---|---|
| [github-actions/policy-smoke.yml](github-actions/policy-smoke.yml) | GitHub Actions | Изолированные synthetic OPA regression tests без live endpoint и deploy credentials |
| [github-actions/mlsec-pipeline.yml](github-actions/mlsec-pipeline.yml) | GitHub Actions | Полный pipeline: data → train → test → gate → deploy |
| [github-actions/daily-compliance.yml](github-actions/daily-compliance.yml) | GitHub Actions | Ежедневные compliance-проверки (SBOM, CVE scan, политики) |
| [github-actions/red-team-weekly.yml](github-actions/red-team-weekly.yml) | GitHub Actions | Еженедельный red team через garak + promptfoo |
| `gitlab-ci/.gitlab-ci.yml` | GitLab CI | Служебный исходник в checkout; для веб-пакета используйте отдельный шаблон security-gate ниже |
| [gitlab-ci/security-gate.yml](gitlab-ci/security-gate.yml) | GitLab CI | Шаблон для include в корпоративных pipeline |

<a id="gejty-po-stadiam"></a>

## Гейты по стадиям

```
┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  Data gate   │→→→│  Train gate  │→→→│  Test gate   │→→→│   ML gate    │→→→│  Deploy      │
└──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘
  Data Card OK      Training           Unit + integ       Signed artifact    Canary 10→50→100
  PII scan OK       reproducible       Adversarial OK     SBOM + ML-BOM      Health check
  Poisoning scan    Metrics logged     Red team OK        OPA policies       Kill-switch test
  Provenance        Reproducibility    Bias analysis      Sign-offs
```

<a id="peremennye-okrujenia-secrets"></a>

## Переменные окружения (secrets)

<a id="kontrakt-integrazii-do-vklucenia"></a>

### Контракт интеграции до включения

| Вход / настройка | Кто отвечает / проверка |
|-----------------|-------------------------|
| `MLSEC_INTEGRATION_ENABLED=true` | Platform owner включает после реализации project adapters; для GitLab дополнительно protected ref, для GitHub секретный full pipeline не выполняется на PR |
| `OPA_LINUX_AMD64_SHA256` (GitHub repository variable) / `OPA_SHA256` (GitLab) | Утверждённый checksum OPA **1.22.4 linux amd64 static** из доверенного release manifest; без значения installer завершается до download |
| Tool/requirements lock и CI images | С 16.11.2026 все actions в заготовках закреплены по полному commit SHA с комментарием версии (checkout v7.0.1, setup-python v7.1.0, setup-node v7.1.0, upload-artifact v7.0.2, download-artifact v8.0.2, github-script v9.0.0, codeql-action v4.39.3, trivy-action v0.36.0), Node 24 LTS, а CLI-инструменты — по точной версии (garak 0.17.1, promptfoo 0.125.1, cyclonedx-bom 8.0.1, cosign 3.1.4). Версия ≠ hash lock: в интеграционном проекте всё равно нужны container digest и Python/npm lock с хэшами, включая ART/Fairlearn/garak. `trivy-action@master` убран: тег-ссылки этого action были перезаписаны вредоносным кодом в марте 2026 ([CVE-2026-33634](https://github.com/aquasecurity/trivy/security/advisories/GHSA-69fq-xp46-6x23)) |
| `COSIGN_SHA256` (GitLab) | Утверждённый SHA-256 `cosign-linux-amd64` **v3.1.4** из `cosign_checksums.txt` релиза (на 16.11.2026: `424e2c97d0b45fd7a6b608a87f090f35633f4c23ece5f092d48bba11aaf4bbfa`); без значения шаг model gate завершается до использования бинарника |
| `MLSEC_DEPLOY_IMAGE`, `MLSEC_TRIVY_IMAGE` (GitLab) | Проверенные image digests. Deploy image содержит docker client + доступ к изолированному builder, cosign и kubectl; образ только с kubectl недостаточен |
| `build_opa_input.py` / `collect_prod_state.py` | Независимый verifier связывает отчёты с artifact/bundle digest, policy revision, scenario, owner и freshness; PR/model не заполняет себе `verified=true` |
| `OPA_TRUST_DATA_PATH` (GitHub variable) → `OPA_TRUST_DATA` / `OPA_TRUST_DATA` (GitLab) | Путь к смонтированному доверенному JSON data bundle с `trusted_signers`, `deployment_policy_revision`, `trusted_registries`. Флаг `-d` уже используется в gate; platform adapter должен доставить и проверить файл. Значения не включены в пример |
| `configs/garak/rest.json` | Generator options для `rest.RestGenerator`: URI из разрешённого canary, HTTP request template, headers с `$KEY`, response JSONPath, timeout. `GATEWAY_URL` сам по себе не конфигурирует garak |
| Environments / approvals | Настройте reviewers, branch restrictions, protected variables и credential scopes в CI-платформе; `environment: production` и echo не создают эти ограничения |
| `MLSEC_CANARY_DRILL_ENABLED=true` | Отдельный manual drill только с изолированным canary и scoped identity, планом восстановления/readback; не scheduled production mutation |
| `MLSEC_NOTIFICATIONS_ENABLED=true` | Отдельное решение о публикации редактированных summaries в Slack/issues; raw prompts/traces не отправляются |

Запуск `policy-smoke.yml` на PR выполняет код PR с read-only token, без секретов. Не добавляйте туда registry/cloud/admin keys, `pull_request_target` checkout или privileged runner. Это проверка Rego, а не безопасность training artifact. Full pipeline — доверенная ветка с отдельными verifier/signer/publisher identities; scripts из недоверенного checkout не должны выполняться с publish/deploy credentials.

<a id="evidence-unknown-outcome-i-vosstanovlenie"></a>

### Evidence, unknown outcome и восстановление

1. До gate фиксируйте immutable digest **всего bundle** (model/adapter/tokenizer + prompt/tool schema/policy/corpus), dataset revisions, reports и scanner versions. SBOM/ML-BOM и численные score не доказывают effect safety сами по себе.
2. OPA exit error, undefined/не-boolean decision, malformed/empty report, недоступный scanner/readback → gate не пройден (`unknown/inconclusive`), а не ноль находок. Не подавляйте ошибку `|| true` без отдельного сохранения статуса.
3. Promotion approval относится к конкретному digest, environment и ограниченному сроку. `latest` tag и повторная сборка после approval не сохраняют identity проверенного артефакта: интеграционный publisher должен продвигать тот же digest и проверять подпись/identity, а не доверять названию CI artifact.
4. Deploy lock (`concurrency` / `resource_group`) снижает гонки, но не заменяет server-side idempotency и action-bound approval. При timeout не повторяйте push/payment/rollout вслепую; сверьте target state, jobs и usage ledger. Отмена CI не доказывает остановку удалённой работы.
5. Recovery использует совместимый предыдущий bundle. Kill-switch drill сначала сохраняет состояние, затем сверяет остановку новых/queued/running jobs и восстанавливает scoped права; закончившийся job не означает восстановленный сервис. Внешний effect oracle и rollback adapter поставляет проект.

Отчёты могут содержать секреты/PII; редактируйте их **до** upload-artifact, задавайте минимальные ACL/retention. `promptfoo share` из заготовки отключён. Synthetic checks подтверждают только решение политики и синтаксис примеров; live provider, GitHub/GitLab permissions, подписи, admission и production recovery здесь не проверялись.

| Имя | Назначение |
|---|---|
| `VAULT_ADDR`, `VAULT_TOKEN` | HashiCorp Vault для секретов pipeline |
| `COSIGN_PRIVATE_KEY`, `COSIGN_PASSWORD` | Подпись артефактов |
| `REGISTRY_URL`, `REGISTRY_TOKEN` | Private Docker registry |
| `DVC_S3_ACCESS_KEY`, `DVC_S3_SECRET_KEY` | DVC remote |
| `MODEL_REGISTRY_TOKEN` | MLflow / W&B / custom registry |
| `OPA_POLICY_BUNDLE_URL` | URL OPA bundle с корпоративными политиками |
| `SLACK_WEBHOOK` | Уведомления в Slack при fail гейта |

<a id="svazi"></a>

## Связи

Первичные источники, проверены 13.11.2026 (версии actions и инструментов — 16.11.2026): [GitHub secure use](https://docs.github.com/en/actions/reference/security/secure-use), [workflow syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax), [GitLab YAML/needs/rules/resource_group](https://docs.gitlab.com/ci/yaml/), [CycloneDX Python CLI 8.0.1: requirements](https://cyclonedx-bom-tool.readthedocs.io/en/v8.0.1/usage.html#for-pip-requirements), [garak REST implementation](https://github.com/NVIDIA/garak/blob/main/garak/generators/rest.py). В CLI 7.2.2 подкоманды `requirements` файл pip-requirements `requirements.lock` — позиционный input, `-i` / `--index-url` задаёт package index; версия инструмента закрепляется отдельно от schema version BOM.

- [Глава 12. CI/CD](../12-detection-protection-cicd-llm.md)
- [opa/](../opa/): политики, проверяемые в pipeline.
- [playbooks/](../playbooks/): что делать при срабатывании.
