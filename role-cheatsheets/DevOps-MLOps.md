<a id="devops-mlops-cheatsheet"></a>

# DevOps / MLOps Cheatsheet

Что отвечает за безопасность ML в эксплуатации и CI/CD.

<a id="top-12-prioritetov"></a>

## Топ-12 приоритетов

1. **Pod Security Standards**. `restricted` профиль для всех ML-нагрузок. Запрет privileged, hostNetwork, hostPath. Read-only rootfs. См. [05. Deployment](../05-stage3-model-deployment.md), [19. Training Infrastructure](../19-training-infrastructure.md).

2. **SBOM + Sigstore**. CycloneDX SBOM на каждый образ. Подписание cosign + keyless. Verify policy в Admission Controller (Kyverno / OPA Gatekeeper). Готовые политики: [opa/](../opa/). См. [05. Deployment](../05-stage3-model-deployment.md), [12. CI/CD](../12-detection-protection-cicd-llm.md).

3. **Container scanning**. Trivy + Grype + Syft в CI. Блокировка на CRITICAL / HIGH. Регулярный rescan уже развёрнутых образов. Готовые CI workflows: [ci/](../ci/). См. [12. CI/CD](../12-detection-protection-cicd-llm.md).

4. **Network segmentation**. NetworkPolicy по умолчанию deny all, явные разрешения между сервисами. Istio mTLS для service mesh. Egress firewall с allowlist для LLM API. См. [05. Deployment](../05-stage3-model-deployment.md), [08. Access](../08-access-secrets-management.md).

5. **Secrets management**. Vault / OpenBao + External Secrets Operator. Никаких секретов в ConfigMap. Ротация с проверкой, что прежние credentials / refresh / jobs больше не сохраняют доступ; TTL определяется риском и возможностями issuer. Audit log в SIEM. SOPS для IaC. См. [08. Access](../08-access-secrets-management.md).

6. **Runtime security**. Falco + Tetragon для eBPF-мониторинга. Sigma-правила для ML-специфичных событий (подозрительный egress, pickle load в проде). Интеграция в SIEM. Готовые правила: [siem/](../siem/) (Sigma / SPL / KUMA). См. [06. Operations](../06-stage4-operations-platform.md), [12. CI/CD](../12-detection-protection-cicd-llm.md).

7. **Drift detection и monitoring**. Evidently AI / Arize Phoenix для data и concept drift. Prometheus + Grafana на latency, cost per request, DLP hit rate, guardrail violations. См. [06. Operations](../06-stage4-operations-platform.md).

8. **Canary / blue-green deploys**. Argo Rollouts или Flagger. Автоматический rollback по SLO. Для моделей: shadow-mode перед переключением трафика. См. [05. Deployment](../05-stage3-model-deployment.md).

9. **GPU hardening**. MIG / vGPU выбирать по модели угроз и поддерживаемым гарантиям конкретного GPU / драйвера; логическое разделение не считать доказанной защитой от всех каналов утечки. NCCL / InfiniBand в отдельном сегменте. CIS Benchmark Linux + NVIDIA security advisories. См. [19. Training Infrastructure](../19-training-infrastructure.md).

10. **SLSA / build provenance**. Целевой SLSA Build level закрепить по риску и версии спецификации. Проверять isolated build, identity builder и соответствие provenance digest развёрнутому артефакту; воспроизводимость проверяется отдельно. См. [12. CI/CD](../12-detection-protection-cicd-llm.md), [19. Training Infrastructure](../19-training-infrastructure.md).

11. **Vector DB operations**. Backup / restore с шифрованием at-rest, tenant isolation (collection-level / database-level), RLS для pgvector, мониторинг подозрительных выгрузок; после restore проверить current ACL, удалённые записи, старые caches и cross-tenant deny-test. См. [24. Vector DB](../24-vector-db-security.md).

12. **CVE-watch и patch management**. Еженедельный триаж новых CVE на компонентах ML-стека. Внутренний MTTP назначить по эксплуатируемости, exposure и критичности; фиксировать исключения, компенсирующие меры и срок владельца. См. [continuous/cve-watch.md](../continuous/cve-watch.md).

<a id="obazatel_nye-ceki-v-ci-cd"></a>

## Обязательные чеки в CI / CD

- SAST: Bandit, Semgrep, CodeQL.
- SCA: pip-audit, OSV-Scanner, Snyk Code.
- IaC: Checkov, tfsec, KICS.
- Secret scan: gitleaks, trufflehog.
- Container: Trivy + Grype.
- Model scan: ModelScan, picklescan, fickling.
- DAST: ZAP или Nuclei на staging.
- Cosign verify: trusted identity/issuer, digest и policy; неверная подпись / provenance блокируется, валидный разрешённый артефакт проходит.

<a id="migrazia-cloud-on-prem"></a>

## Миграция cloud → on-prem

Если переезжаете с managed cloud LLM на self-hosted: [guides/cloud-to-onprem-migration.md](../guides/cloud-to-onprem-migration.md). 6-месячная программа с capacity planning, cost comparison, go-live чеклистом.

<a id="disaster-recovery"></a>

## Disaster Recovery

RPO / RTO определены по Tier. Бэкапы:
- Моделей (подписанных cosign): в защищённое хранилище, retention по политике.
- Векторных БД: snapshot + шифрование at-rest.
- Training data: DVC + S3 versioning.
- Kill-switch state: Redis persistence + PostgreSQL source of truth.

Регулярные restore-тесты (ежеквартально). Документация KMS recovery.

<a id="on-call-minimum"></a>

## On-call минимум

- Access к kill-switch L0-L4.
- Runbook для применимых сценариев в [playbooks/](../playbooks/).
- Алерты: DLP critical, kill-switch triggered, GPU down, CVE Critical в prod.
- Rollback в установленный RTO; после переключения проверить jobs, tool credentials, current ACL и разрешённый клиент. Нет readback — unknown, а не восстановление.
