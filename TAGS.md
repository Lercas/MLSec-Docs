<a id="tegi-perekrestnyj-ukazatel_"></a>

# Теги (перекрёстный указатель)

> Указатель тегов по главам методики и вспомогательным материалам. Основные теги задаются в шапке главы в строке `> Версия: X.Y · Обновлено: YYYY-MM-DD · Теги: ... · Tier: N-M`; указатель также включает темы новых разделов. Используйте для быстрой навигации к темам, упоминаемым в нескольких главах.

<a id="ispol_zovanie"></a>

## Использование

- Каждый тег указывает на главы и/или дополнительные материалы, где он раскрывается.
- Один тег может соответствовать нескольким главам: тема раскрывается с разных углов (архитектурный, операционный, контрольный, compliance).
- Полный список глав: [00-INDEX.md](00-INDEX.md). Словарь терминов: [GLOSSARY.md](GLOSSARY.md).

<a id="karta-tegov-po-kategoriam"></a>

## Карта тегов по категориям

<a id="jiznennyj-zikl-i-arhitektura"></a>

### Жизненный цикл и архитектура

| Тег | Главы / материалы |
|-----|-------|
| `архитектура` | [01](01-overview-architecture.md) |
| `lifecycle` | [01](01-overview-architecture.md) |
| `security-by-design` | [01](01-overview-architecture.md) |
| `tiering` | [01](01-overview-architecture.md) |
| `maturity` | [01](01-overview-architecture.md), [MATURITY-ASSESSMENT](MATURITY-ASSESSMENT.md) |
| `зрелость` | [13](13-implementation-ru-playbook.md), [MATURITY-ASSESSMENT](MATURITY-ASSESSMENT.md) |
| `system design` | [02](02-stage0-ml-system-design.md) |

<a id="dannye"></a>

### Данные

| Тег | Главы / материалы |
|-----|-------|
| `data` | [03](03-stage1-data-operations.md) |
| `data classification` | [02](02-stage0-ml-system-design.md) |
| `validation` | [03](03-stage1-data-operations.md) |
| `pipeline security` | [03](03-stage1-data-operations.md) |
| `PII` | [03](03-stage1-data-operations.md) |
| `Presidio` | [03](03-stage1-data-operations.md), [25](25-prompt-ops.md) |
| `DVC` | [03](03-stage1-data-operations.md) |
| `PIA` | [02](02-stage0-ml-system-design.md), [templates/PIA-TEMPLATE](templates/PIA-TEMPLATE.md) |
| `privacy ledger` | [17](17-privacy-enhancing-tech.md), [28](28-synthetic-data-security.md) |
| `tombstone` | [03](03-stage1-data-operations.md), [24](24-vector-db-security.md), [34](34-ai-agents-runtime-procedure.md) |
| `synthetic data` | [28](28-synthetic-data-security.md) |
| `SDV` | [28](28-synthetic-data-security.md) |

<a id="modeli-i-supply-chain"></a>

### Модели и supply chain

| Тег | Главы / материалы |
|-----|-------|
| `MLflow` | [04](04-stage2-model-operations.md) |
| `supply chain` | [04](04-stage2-model-operations.md), [19](19-training-infrastructure.md) |
| `SBOM` | [05](05-stage3-model-deployment.md) |
| `CycloneDX` | [14](14-model-risk-governance.md) |
| `AI-BOM` | [14](14-model-risk-governance.md), [templates/AI-BOM-EXAMPLE](templates/AI-BOM-EXAMPLE.json) |
| `ML-BOM` | [14](14-model-risk-governance.md) |
| `Model Card` | [14](14-model-risk-governance.md), [templates/MODEL-CARD-TEMPLATE](templates/MODEL-CARD-TEMPLATE.md) |
| `Data Card` | [14](14-model-risk-governance.md), [templates/DATA-CARD-TEMPLATE](templates/DATA-CARD-TEMPLATE.md) |
| `SafeTensors` | [04](04-stage2-model-operations.md) |
| `Sigstore` | [05](05-stage3-model-deployment.md), [29](29-watermarking-attribution.md) |
| `cosign` | [05](05-stage3-model-deployment.md), [19](19-training-infrastructure.md) |
| `pip-audit` | [04](04-stage2-model-operations.md) |
| `Bandit` | [04](04-stage2-model-operations.md) |
| `ART` | [04](04-stage2-model-operations.md), [26](26-multimodal-cv-security.md) |

<a id="razvertyvanie-i-infra"></a>

### Развёртывание и инфра

| Тег | Главы / материалы |
|-----|-------|
| `Kubernetes` | [05](05-stage3-model-deployment.md) |
| `Pod Security` | [05](05-stage3-model-deployment.md) |
| `canary` | [05](05-stage3-model-deployment.md) |
| `GPU` | [19](19-training-infrastructure.md) |
| `multi-tenant` | [19](19-training-infrastructure.md), [24](24-vector-db-security.md) |
| `distributed` | [19](19-training-infrastructure.md) |
| `training` | [19](19-training-infrastructure.md) |
| `SLSA` | [19](19-training-infrastructure.md) |
| `cloud-to-onprem` | [guides/cloud-to-onprem-migration](guides/cloud-to-onprem-migration.md), [05](05-stage3-model-deployment.md) |
| `on-prem` | [guides/cloud-to-onprem-migration](guides/cloud-to-onprem-migration.md) |
| `vLLM` | [guides/cloud-to-onprem-migration](guides/cloud-to-onprem-migration.md) |

<a id="runtime-monitoring-finops"></a>

### Runtime, мониторинг, FinOps

| Тег | Главы / материалы |
|-----|-------|
| `monitoring` | [06](06-stage4-operations-platform.md) |
| `drift` | [06](06-stage4-operations-platform.md) |
| `Prometheus` | [06](06-stage4-operations-platform.md) |
| `Grafana` | [06](06-stage4-operations-platform.md) |
| `Falco` | [06](06-stage4-operations-platform.md), [12](12-detection-protection-cicd-llm.md) |
| `eBPF` | [12](12-detection-protection-cicd-llm.md) |
| `anomaly` | [22](22-finops-ai.md) |
| `FinOps` | [22](22-finops-ai.md), [executive/roi-calculator](executive/roi-calculator.md) |
| `cost attribution` | [22](22-finops-ai.md) |
| `denial of wallet` | [22](22-finops-ai.md) |
| `token flood` | [22](22-finops-ai.md) |
| `ROI` | [executive/roi-calculator](executive/roi-calculator.md) |
| `NPV` | [executive/roi-calculator](executive/roi-calculator.md) |

<a id="red-teaming-i-ataki"></a>

### Red teaming и атаки

| Тег | Главы / материалы |
|-----|-------|
| `red teaming` | [07](07-red-teaming-testing-methods.md), [guides/red-team-exercises](guides/red-team-exercises.md) |
| `red team exercises` | [guides/red-team-exercises](guides/red-team-exercises.md) |
| `adversarial` | [07](07-red-teaming-testing-methods.md), [26](26-multimodal-cv-security.md) |
| `Garak` | [07](07-red-teaming-testing-methods.md), [guides/red-team-exercises](guides/red-team-exercises.md) |
| `PyRIT` | [07](07-red-teaming-testing-methods.md), [guides/red-team-exercises](guides/red-team-exercises.md) |
| `Promptfoo` | [07](07-red-teaming-testing-methods.md), [25](25-prompt-ops.md) |
| `bug bounty` | [07](07-red-teaming-testing-methods.md), [21](21-people-process.md), [guides/bug-bounty-ai](guides/bug-bounty-ai.md) |
| `ML attacks` | [16](16-ml-attacks-rag-multimodal.md) |
| `extraction` | [16](16-ml-attacks-rag-multimodal.md), [24](24-vector-db-security.md) |
| `inversion` | [16](16-ml-attacks-rag-multimodal.md), [24](24-vector-db-security.md) |
| `model poisoning` | [16](16-ml-attacks-rag-multimodal.md), [28](28-synthetic-data-security.md) |
| `MITRE ATLAS` | [09](09-threat-modeling.md), [23](23-mitre-atlas-ru.md) |
| `MITRE ATLAS RU` | [23](23-mitre-atlas-ru.md) |

<a id="multimodal-cv-voice"></a>

### Multimodal, CV, Voice

| Тег | Главы / материалы |
|-----|-------|
| `multimodal` | [16](16-ml-attacks-rag-multimodal.md), [26](26-multimodal-cv-security.md) |
| `CV` | [26](26-multimodal-cv-security.md) |
| `adversarial patch` | [26](26-multimodal-cv-security.md) |
| `OCR attack` | [26](26-multimodal-cv-security.md) |
| `QR injection` | [26](26-multimodal-cv-security.md) |
| `face-ID` | [26](26-multimodal-cv-security.md) |
| `deepfake` | [26](26-multimodal-cv-security.md), [27](27-voice-ai-security.md), [continuous/incident-log](continuous/incident-log.md) |
| `voice cloning` | [27](27-voice-ai-security.md) |
| `ASR` | [27](27-voice-ai-security.md) |
| `TTS` | [27](27-voice-ai-security.md) |
| `ASVspoof` | [27](27-voice-ai-security.md) |
| `liveness` | [27](27-voice-ai-security.md) |
| `ЕБС` | [27](27-voice-ai-security.md), [18](18-ru-compliance-deep.md) |

<a id="access-i-secrets"></a>

### Access и secrets

| Тег | Главы / материалы |
|-----|-------|
| `RBAC` | [08](08-access-secrets-management.md) |
| `PoLP` | [08](08-access-secrets-management.md) |
| `Vault` | [08](08-access-secrets-management.md) |
| `SOPS` | [08](08-access-secrets-management.md) |
| `Keycloak` | [08](08-access-secrets-management.md) |
| `audit` | [08](08-access-secrets-management.md) |
| `mTLS` | [08](08-access-secrets-management.md) |

<a id="threat-modeling"></a>

### Threat modeling

| Тег | Главы / материалы |
|-----|-------|
| `threat modeling` | [02](02-stage0-ml-system-design.md), [09](09-threat-modeling.md), [templates/THREAT-MODEL-TEMPLATE](templates/THREAT-MODEL-TEMPLATE.md) |
| `STRIDE` | [11](11-chatbot-conversational-security.md) |
| `STRIDE-AI` | [09](09-threat-modeling.md) |
| `DFD` | [09](09-threat-modeling.md) |
| `OWASP LLM` | [09](09-threat-modeling.md), [compliance-matrices/OWASP-LLM-TOP10](compliance-matrices/OWASP-LLM-TOP10.md) |
| `OWASP ML` | [09](09-threat-modeling.md) |
| `OWASP Agentic` | [10](10-llm-agent-protection.md) |

<a id="llm-agenty-rag"></a>

### LLM, агенты, RAG

| Тег | Главы / материалы |
|-----|-------|
| `агенты` | [10](10-llm-agent-protection.md) |
| `Agentic AI` | [10](10-llm-agent-protection.md), [31](31-ai-agents-overview.md), [36](36-ai-agents-production-checklist.md) |
| `MCP` | [10](10-llm-agent-protection.md), [20](20-code-assistants-security.md), [33](33-ai-agents-security-overlay.md) |
| `elicitation` | [10](10-llm-agent-protection.md), [33](33-ai-agents-security-overlay.md), [36](36-ai-agents-production-checklist.md) |
| `MRTR` | [10](10-llm-agent-protection.md), [33](33-ai-agents-security-overlay.md), [36](36-ai-agents-production-checklist.md) |
| `sampling` | [10](10-llm-agent-protection.md), [36](36-ai-agents-production-checklist.md); MCP feature deprecated, отдельно от sampling телеметрии |
| `A2A` | [10](10-llm-agent-protection.md), [31](31-ai-agents-overview.md), [32](32-ai-agents-operating-overlay.md) |
| `action-bound approval` | [33](33-ai-agents-security-overlay.md), [examples/agents](examples/agents/README.md) |
| `delegation` | [08](08-access-secrets-management.md), [32](32-ai-agents-operating-overlay.md), [33](33-ai-agents-security-overlay.md) |
| `unknown outcome` | [05](05-stage3-model-deployment.md), [33](33-ai-agents-security-overlay.md), [35](35-ai-agents-incident-playbook.md) |
| `resume` | [06](06-stage4-operations-platform.md), [34](34-ai-agents-runtime-procedure.md) |
| `acceptance evidence` | [01](01-overview-architecture.md), [07](07-red-teaming-testing-methods.md), [36](36-ai-agents-production-checklist.md) |
| `HITL` | [10](10-llm-agent-protection.md) |
| `kill-switch` | [10](10-llm-agent-protection.md) |
| `sandbox` | [10](10-llm-agent-protection.md) |
| `RAG` | [16](16-ml-attacks-rag-multimodal.md), [24](24-vector-db-security.md) |
| `vector DB` | [24](24-vector-db-security.md) |
| `Qdrant` | [24](24-vector-db-security.md) |
| `Weaviate` | [24](24-vector-db-security.md) |
| `pgvector` | [24](24-vector-db-security.md) |
| `RLS` | [24](24-vector-db-security.md), [08](08-access-secrets-management.md) |
| `embedding inversion` | [24](24-vector-db-security.md), [16](16-ml-attacks-rag-multimodal.md) |
| `LoRA` | [16](16-ml-attacks-rag-multimodal.md) |
| `chatbot` | [11](11-chatbot-conversational-security.md) |
| `prompt injection` | [11](11-chatbot-conversational-security.md), [25](25-prompt-ops.md), [playbooks/IR-03-prompt-injection-campaign](playbooks/IR-03-prompt-injection-campaign.md) |
| `PII leak` | [11](11-chatbot-conversational-security.md) |

<a id="promptops-i-prompt-firewall"></a>

### PromptOps и prompt firewall

| Тег | Главы / материалы |
|-----|-------|
| `PromptOps` | [25](25-prompt-ops.md) |
| `prompt registry` | [25](25-prompt-ops.md) |
| `prompt firewall` | [25](25-prompt-ops.md) |
| `Anti-EchoLeak` | [25](25-prompt-ops.md) |
| `LLM Guard` | [25](25-prompt-ops.md) |
| `NeMo Guardrails` | [25](25-prompt-ops.md) |
| `Guardrails AI` | [25](25-prompt-ops.md) |
| `Langfuse` | [25](25-prompt-ops.md) |

<a id="dlp-gateway-cicd"></a>

### DLP, gateway, CI/CD

| Тег | Главы / материалы |
|-----|-------|
| `DLP` | [11](11-chatbot-conversational-security.md), [20](20-code-assistants-security.md) |
| `gateway` | [01](01-overview-architecture.md), [20](20-code-assistants-security.md) |
| `Rilio` | [01](01-overview-architecture.md) |
| `guardrails` | [12](12-detection-protection-cicd-llm.md), [25](25-prompt-ops.md) |
| `WAF` | [12](12-detection-protection-cicd-llm.md) |
| `Defense in Depth` | [12](12-detection-protection-cicd-llm.md) |
| `CI/CD` | [12](12-detection-protection-cicd-llm.md), [ci/](ci/) |
| `OPA` | [opa/](opa/) |
| `Rego` | [opa/](opa/) |
| `SIEM` | [siem/](siem/) |
| `Sigma` | [siem/](siem/) |
| `KUMA` | [siem/](siem/) |

<a id="incident-response"></a>

### Incident response

| Тег | Главы / материалы |
|-----|-------|
| `incident response` | [15](15-ai-incident-response.md), [playbooks/](playbooks/) |
| `forensics` | [15](15-ai-incident-response.md), [30](30-interpretability-for-security.md) |
| `retention` | [15](15-ai-incident-response.md) |
| `tabletop` | [15](15-ai-incident-response.md), [templates/TABLETOP-SCENARIOS](templates/TABLETOP-SCENARIOS.md), [guides/red-team-exercises](guides/red-team-exercises.md) |
| `ГосСОПКА` | [15](15-ai-incident-response.md) |
| `ФинЦЕРТ` | [15](15-ai-incident-response.md) |
| `IR` | [06](06-stage4-operations-platform.md), [playbooks/](playbooks/) |
| `playbook` | [playbooks/](playbooks/) |
| `incident log` | [continuous/incident-log](continuous/incident-log.md) |

<a id="governance-i-politiki"></a>

### Governance и политики

| Тег | Главы / материалы |
|-----|-------|
| `MRM` | [14](14-model-risk-governance.md) |
| `Use Policy` | [14](14-model-risk-governance.md), [templates/AI-USE-POLICY-TEMPLATE](templates/AI-USE-POLICY-TEMPLATE.md) |
| `AI Literacy` | [21](21-people-process.md) |
| `independent validation` | [14](14-model-risk-governance.md) |
| `decommissioning` | [21](21-people-process.md) |

<a id="privacy-enhancing-tech-pet"></a>

### Privacy Enhancing Tech (PET)

| Тег | Главы / материалы |
|-----|-------|
| `DP` | [17](17-privacy-enhancing-tech.md), [28](28-synthetic-data-security.md) |
| `DP-SGD` | [17](17-privacy-enhancing-tech.md) |
| `FL` | [17](17-privacy-enhancing-tech.md) |
| `TEE` | [17](17-privacy-enhancing-tech.md) |
| `Homomorphic Encryption` | [17](17-privacy-enhancing-tech.md) |
| `SMPC` | [17](17-privacy-enhancing-tech.md) |
| `clean rooms` | [17](17-privacy-enhancing-tech.md) |
| `Opacus` | [17](17-privacy-enhancing-tech.md) |

<a id="interpretability"></a>

### Interpretability

| Тег | Главы / материалы |
|-----|-------|
| `interpretability` | [30](30-interpretability-for-security.md) |
| `SHAP` | [30](30-interpretability-for-security.md) |
| `Captum` | [30](30-interpretability-for-security.md) |
| `TransformerLens` | [30](30-interpretability-for-security.md) |
| `backdoor detection` | [30](30-interpretability-for-security.md), [19](19-training-infrastructure.md) |
| `bias` | [30](30-interpretability-for-security.md) |
| `GDPR Art. 22` | [30](30-interpretability-for-security.md) |

<a id="watermarking-i-attribution"></a>

### Watermarking и attribution

| Тег | Главы / материалы |
|-----|-------|
| `watermarking` | [29](29-watermarking-attribution.md) |
| `SynthID` | [29](29-watermarking-attribution.md) |
| `AudioSeal` | [29](29-watermarking-attribution.md), [27](27-voice-ai-security.md) |
| `C2PA` | [29](29-watermarking-attribution.md), [26](26-multimodal-cv-security.md) |
| `Sigstore MT` | [29](29-watermarking-attribution.md) |
| `149-ФЗ` | [29](29-watermarking-attribution.md), [18](18-ru-compliance-deep.md), [continuous/regulatory-timeline](continuous/regulatory-timeline.md) |

<a id="code-assistants"></a>

### Code assistants

| Тег | Главы / материалы |
|-----|-------|
| `code assistants` | [20](20-code-assistants-security.md) |
| `Copilot` | [20](20-code-assistants-security.md) |
| `Cursor` | [20](20-code-assistants-security.md) |
| `Claude CLI` | [20](20-code-assistants-security.md) |

<a id="cve-i-vulnerability-management"></a>

### CVE и vulnerability management

| Тег | Главы / материалы |
|-----|-------|
| `CVE` | [continuous/cve-watch](continuous/cve-watch.md) |
| `SBOM scan` | [12](12-detection-protection-cicd-llm.md), [ci/](ci/) |
| `MTTP` | [continuous/cve-watch](continuous/cve-watch.md) |

<a id="executive-i-board"></a>

### Executive и board

| Тег | Главы / материалы |
|-----|-------|
| `board deck` | [executive/board-deck](executive/board-deck.md) |
| `one-pager` | [executive/one-pager](executive/one-pager.md) |
| `summary` | [executive/summary](executive/summary.md) |
| `ROI calculator` | [executive/roi-calculator](executive/roi-calculator.md) |
| `CISO 90-day plan` | [executive/quick-start-ciso](executive/quick-start-ciso.md) |

<a id="otraslevoe"></a>

### Отраслевое

| Тег | Главы / материалы |
|-----|-------|
| `banking` | [industries/banking](industries/banking.md) |
| `govtech` | [industries/govtech](industries/govtech.md) |
| `healthcare` | [industries/healthcare](industries/healthcare.md) |
| `industrial` | [industries/industrial](industries/industrial.md) |
| `retail` | [industries/retail](industries/retail.md) |
| `telecom` | [industries/telecom](industries/telecom.md) |

<a id="rossijskaa-spezifika"></a>

### Российская специфика

| Тег | Главы / материалы |
|-----|-------|
| `152-ФЗ` | [13](13-implementation-ru-playbook.md), [18](18-ru-compliance-deep.md) |
| `187-ФЗ` | [18](18-ru-compliance-deep.md) |
| `242-ФЗ` | [18](18-ru-compliance-deep.md) |
| `243-ФЗ` | [18](18-ru-compliance-deep.md), [26](26-multimodal-cv-security.md), [27](27-voice-ai-security.md), [29](29-watermarking-attribution.md), [continuous/regulatory-timeline](continuous/regulatory-timeline.md) |
| `БФМ` | [18](18-ru-compliance-deep.md) |
| `572-ФЗ` | [27](27-voice-ai-security.md), [18](18-ru-compliance-deep.md) |
| `ФСТЭК` | [13](13-implementation-ru-playbook.md), [18](18-ru-compliance-deep.md), [templates/FSTEK-AUDIT-CHECKLIST](templates/FSTEK-AUDIT-CHECKLIST.md), [compliance-matrices/FSTEK-ORDERS](compliance-matrices/FSTEK-ORDERS.md) |
| `ФСТЭК 117/137` | [18](18-ru-compliance-deep.md), [26](26-multimodal-cv-security.md), [compliance-matrices/FSTEK-ORDERS](compliance-matrices/FSTEK-ORDERS.md) |
| `ЦБ` | [13](13-implementation-ru-playbook.md), [18](18-ru-compliance-deep.md), [industries/banking](industries/banking.md) |
| `716-П` | [18](18-ru-compliance-deep.md), [continuous/regulatory-timeline](continuous/regulatory-timeline.md) |
| `ГОСТ` | [18](18-ru-compliance-deep.md) |
| `маркировка` | [18](18-ru-compliance-deep.md), [29](29-watermarking-attribution.md) |
| `плейбук` | [13](13-implementation-ru-playbook.md) |
| `roadmap` | [13](13-implementation-ru-playbook.md) |

<a id="regulatorika-mejdunarodnaa"></a>

### Регуляторика (международная)

| Тег | Главы / материалы |
|-----|-------|
| `EU AI Act` | [14](14-model-risk-governance.md), [compliance-matrices/EU-AI-ACT](compliance-matrices/EU-AI-ACT.md), [continuous/regulatory-timeline](continuous/regulatory-timeline.md) |
| `GDPR` | [18](18-ru-compliance-deep.md), [30](30-interpretability-for-security.md) |
| `NIST AI RMF` | [compliance-matrices/NIST-AI-RMF](compliance-matrices/NIST-AI-RMF.md) |
| `ISO 42001` | [14](14-model-risk-governance.md), [compliance-matrices/ISO-42001](compliance-matrices/ISO-42001.md) |

<a id="people-and-process"></a>

### People and process

| Тег | Главы / материалы |
|-----|-------|
| `safe harbor` | [21](21-people-process.md) |
| `обучение` | [21](21-people-process.md) |

<a id="sm-takje"></a>

## См. также

- [00-INDEX.md](00-INDEX.md): иерархический указатель глав.
- [README.md](README.md): навигация по ролям и дополнительным материалам.
- [GLOSSARY.md](GLOSSARY.md): словарь терминов.
- [FAQ.md](FAQ.md): частые вопросы.
- [role-cheatsheets/](role-cheatsheets/): одностраничники по ролям.
- [templates/README.md](templates/README.md): шаблоны артефактов.
- [compliance-matrices/README.md](compliance-matrices/README.md): матрицы соответствия.
