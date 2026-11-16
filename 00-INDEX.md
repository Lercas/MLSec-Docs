<a id="mlsec-recommendations-indeks-dokumentov"></a>

# MLSec Recommendations. Индекс документов

> **Проект**: Рекомендации по внедрению ML SecOps в российских компаниях
> **Перспектива**: Служба ИБ внедряет процессы MLSec по корпоративным стандартам
> **Базовая редакция**: 2026-05-29 · **Тематическая актуализация**: 2026-11-13 (данные и модели, платформа, privacy, агенты, governance, IR, регуляторика и практические примеры)

Для новых threat model ориентируйтесь на [OWASP GenAI LLM Top 10 2026](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/) и отдельный [Agentic Applications 2026](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/). Существующие матрицы с пометкой «2025» относятся к указанной редакции; коды переводятся по [таблице соответствия 2025 → 2026](compliance-matrices/OWASP-LLM-TOP10.md#sootvetstvie-redakzij-2025-2026), для расширенных пунктов с проверкой нового охвата. Сводка ниже описывает покрытие материалов, а не свидетельствует о полном аудите всех глав.

<a id="bystrye-ssylki"></a>

## Быстрые ссылки

- [README](README.md) - общий обзор проекта и рекомендованные маршруты.
- [GLOSSARY](GLOSSARY.md) - словарь терминов ИБ, ML и регуляторики.
- [FAQ](FAQ.md) - частые вопросы по внедрению MLSec.
- [TAGS](TAGS.md) - перекрёстный указатель тегов по главам.

<a id="prakticeskie-materialy"></a>

## <span id="gotovye-artefakty-po-zaprosu" aria-hidden="true"></span>Практические материалы

Дополнительные материалы открываются по ссылкам в соответствующих разделах; в веб-версии для них нужен бесплатный аккаунт. Заполненные карточки, реальные данные и собственные evidence хранятся во внутреннем контуре организации.

- [Опросник зрелости MLSec](MATURITY-ASSESSMENT.md) по 10 доменам с evidence, неизвестными и обоснованной неприменимостью.
- [Одностраничники по ролям](role-cheatsheets/README.md): CISO, ML-engineer, DevOps, Compliance, Developer, FinOps.
- [Шаблоны](templates/README.md): Threat Model, PIA, AI Use Policy, AI-BOM (пример CycloneDX 1.5), tabletop, ФСТЭК-чеклист и уведомления регуляторам.
- [Матрицы](compliance-matrices/README.md): OWASP, ATLAS v2026.10, NIST, ISO, EU AI Act и российские требования с отдельной оценкой применимости и свидетельств.
- [Примеры агентов](examples/agents/README.md): policy, approval/delegation, память, карантин, схемы событий и локальные fixtures.
- Архитектурные диаграммы Mermaid: lifecycle, gateway, DLP, kill-switch, IR.

Обновлены Markdown и текстовые примеры. Исторические PPTX/XLSX не пересобраны и не опубликованы как новая редакция; их наличие в исходниках не подтверждает актуальность формул или слайдов.

---

<a id="struktura-dokumentov"></a>

## Структура документов

| # | Документ | Описание |
|---|---------|---------|
| 01 | [Обзор и архитектура MLSec](01-overview-architecture.md) | Введение в MLSec, архитектура процесса, отличия от DevSecOps, security by design/default/deployment |
| 02 | [Этап 0. ML System Design](02-stage0-ml-system-design.md) | Проектирование ML-системы: требования безопасности, Data Classification, Privacy Impact Assessment |
| 03 | [Этап 1. Data Operations](03-stage1-data-operations.md) | Операции с данными: валидация, Great Expectations, Presidio, Label Studio, DVC, защита data pipeline |
| 04 | [Этап 2. Model Operations](04-stage2-model-operations.md) | Операции с моделями: MLflow, Bandit, pip-audit, Checkov, ART, безопасное обучение |
| 05 | [Этап 3. Model Deployment](05-stage3-model-deployment.md) | Развёртывание: Kubernetes, Docker security, canary / blue-green, rollback, KServe, Istio |
| 06 | [Этап 4. Operations & Platform](06-stage4-operations-platform.md) | Эксплуатация: мониторинг (Prometheus, Grafana, Arthur AI, Fiddler), drift detection, incident response |
| 07 | [Red Teaming и методы тестирования](07-red-teaming-testing-methods.md) | Red Teaming, RLHF, adversarial testing, Garak, PyRIT, Promptfoo, тестирование LLM / CV / табличных моделей |
| 08 | [Управление доступом и секретами](08-access-secrets-management.md) | Vault / OpenBao, SOPS, Keycloak, PoLP, workload identity, audience, projected tokens и проверка отзыва |
| 09 | [Threat Modeling](09-threat-modeling.md) | STRIDE / STRIDE-AI, OWASP ML Top 10, OWASP LLM Top 10 (2025), MITRE ATLAS, DFD-анализ |
| 10 | [Защита LLM-агентов](10-llm-agent-protection.md) | Типы интеграции LLM, OWASP Agentic AI Top 10, Agentic Radar, реестр guardrails со статусами сопровождения, red teaming агентов |
| 11 | [Безопасность чат-ботов](11-chatbot-conversational-security.md) | Архитектура chatbot, STRIDE по DFD, prompt injection, утечки PII, model poisoning, side-channel, матрица рисков |
| 12 | [Методы обнаружения и защиты, CI/CD](12-detection-protection-cicd-llm.md) | Defense in Depth, sanitization, guardrails, eBPF, Falco, WAF, GitLab CI/CD для LLM, fuzzing |
| 13 | [Внедрение MLSec в российских компаниях](13-implementation-ru-playbook.md) | Сводный внедренческий плейбук: roadmap, зрелость, 152-ФЗ, ЦБ РФ, ФСТЭК, отечественный стек, OSS-инвентарь, Rilio |
| 14 | [Governance: MRM, AI-BOM, AI Use Policy](14-model-risk-governance.md) | Управление модельным риском, реестр ИИ-систем, пакет свидетельств релиза и повторная валидация |
| 15 | [AI Incident Response, Forensics, Tabletop](15-ai-incident-response.md) | Классификация инцидентов, плейбуки, траектория агента, отзыв полномочий, forensics и проверка восстановления |
| 16 | [ML Attack Atlas: RAG, Multimodal, Fine-tuning](16-ml-attacks-rag-multimodal.md) | Extraction, inversion, MIA, RAG security, мультимодальные атаки, adapter supply chain |
| 17 | [Privacy Enhancing Technologies (PET)](17-privacy-enhancing-tech.md) | Differential Privacy, Federated Learning, TEE, Homomorphic Encryption, SMPC, data clean rooms |
| 18 | [Российская специфика, deep dive](18-ru-compliance-deep.md) | 152-ФЗ, 187-ФЗ, ФСТЭК, ЦБ, ГОСТ-крипто, реестр отечественного ПО, маркировка AI-контента |
| 19 | [Безопасность обучающей инфраструктуры](19-training-infrastructure.md) | GPU-кластеры, distributed training, защита checkpoint-ов, supply chain, multi-tenant |
| 20 | [Безопасность код-ассистентов](20-code-assistants-security.md) | Copilot, Cursor, Claude Code, Codex, gateway, DLP, background runs, доверие к rules/hooks и разделение CI-полномочий |
| 21 | [Люди и процесс: AI Literacy, Decommissioning, Bug Bounty](21-people-process.md) | Программа обучения по ролям, снятие моделей с эксплуатации, bug bounty для AI |
| 22 | [FinOps для ИИ и LLM](22-finops-ai.md) | Unit economics, общий бюджет агентного запуска, резервирование, cache/routing, стоимость принятой задачи и denial of wallet |
| 23 | [MITRE ATLAS на русском](23-mitre-atlas-ru.md) | ATLAS v2026.10: точные ID, тактики, митигации, типы case studies и миграция закреплённого снимка |
| 24 | [Безопасность векторных БД](24-vector-db-security.md) | Inversion, poisoning, cross-tenant, RLS, актуальность ACL, cache и проверка полноты ANN retrieval |
| 25 | [PromptOps](25-prompt-ops.md) | Промпты как код: registry, версионирование, review, CI/CD, изоляция Vault, canary detector и границы защиты от exfiltration |
| 26 | [Мультимодальность и CV](26-multimodal-cv-security.md) | Prompt injection через изображение, adversarial patches, OCR-атаки, deepfake, face-ID |
| 27 | [Voice AI](27-voice-ai-security.md) | ASR/TTS, voice cloning, ASVspoof, ЕБС, liveness, watermarking TTS |
| 28 | [Синтетические данные](28-synthetic-data-security.md) | Memorization, distribution shift, model collapse, DP-генерация, compliance и attribution |
| 29 | [Watermarking и attribution](29-watermarking-attribution.md) | SynthID, AudioSeal, C2PA, Sigstore MT, model watermarking для IP и compliance |
| 30 | [Интерпретируемость для ИБ](30-interpretability-for-security.md) | SHAP/Captum/Mechanistic, backdoor detection, bias, forensics, GDPR Art. 22 |
| 31 | [AI-агенты: обзор и наследование](31-ai-agents-overview.md) | README ветки про агентов: карта документов, принцип приоритета базовых документов, examples/ |
| 32 | [AI-агенты: operating overlay](32-ai-agents-operating-overlay.md) | Граница агентного сценария, классы A-D, поля реестра, делегированные полномочия, этапы допуска |
| 33 | [AI-агенты: security overlay](33-ai-agents-security-overlay.md) | Модель угроз, граница инструментов, согласование, память, изоляция коннекторов, защита от prompt injection |
| 34 | [AI-агенты: runtime procedure](34-ai-agents-runtime-procedure.md) | Состояния runtime, мониторинг, ограниченный режим, приостановка, kill-switch, восстановление |
| 35 | [AI-агенты: incident playbook](35-ai-agents-incident-playbook.md) | Первичная реакция на инъекцию, tool misuse, отравление памяти, компрометацию коннектора, потерю свидетельств |
| 36 | [AI-агенты: production readiness](36-ai-agents-production-checklist.md) | Чек-лист готовности: 8 блоков подтверждений, 9 блокирующих условий, подписи ролей |

---






<a id="dopolnitel_nye-materialy"></a>

## Дополнительные материалы

| Раздел | Описание |
|---|---|
| [executive/](executive/) | One-pager, summary, сценарий board deck, 90-day CISO план и ROI-модель; бинарные экспорты не обновлены |
| [industries/](industries/) | Отраслевые плейбуки: банки, гос, промышленность, retail, healthcare, telecom |
| [playbooks/](playbooks/) | 5 IR-runbook: data poisoning, extraction, injection, agent breach, shadow AI |
| [opa/](opa/) | Rego-политики: deployment, runtime access, LLM gateway |
| [siem/](siem/) | Sigma и SPL; KUMA XML — отключённые иллюстративные заготовки для адаптации |
| [ci/](ci/) | CI workflow-ы: GitHub Actions и GitLab CI для MLSec pipeline и red team |
| [templates/](templates/) | Шаблоны: Model Card, Data Card, AI-BOM, Threat Model, Tabletop |
| [compliance-matrices/](compliance-matrices/) | Матрицы соответствия OWASP / MITRE / NIST / EU AI Act / ФСТЭК |
| [role-cheatsheets/](role-cheatsheets/) | Одностраничники по ролям |
| [continuous/](continuous/) | Живые материалы: CVE-watch, incident-log индустрии, regulatory timeline |
| [guides/](guides/) | Практические руководства: миграция cloud→on-prem, Bug Bounty AI, Red Team exercises |
| [MATURITY-ASSESSMENT.md](MATURITY-ASSESSMENT.md) | Self-assessment MLSec-зрелости по 10 доменам |
| [examples/agents/](examples/agents/README.md) | Агентные контракты, шаблоны, offline semantic fixtures и временные тесты Prometheus |

---

<a id="navigazia-po-rolam"></a>

## Навигация по ролям

<a id="rukovoditeli-i-product-owner"></a>

### Руководители и Product Owner
1. [01. Обзор и архитектура](01-overview-architecture.md). Начните здесь.
2. [13. Внедренческий плейбук](13-implementation-ru-playbook.md). Roadmap и зрелость.
3. [14. Governance](14-model-risk-governance.md). MRM, AI-BOM, политика.
4. [09. Threat Modeling](09-threat-modeling.md). Оценка рисков.
5. [22. FinOps](22-finops-ai.md). Бюджеты и аномалии.

<a id="ciso-i-risk-menedjment"></a>

### CISO и риск-менеджмент
1. [13. Внедренческий плейбук](13-implementation-ru-playbook.md)
2. [14. Governance](14-model-risk-governance.md)
3. [15. AI Incident Response](15-ai-incident-response.md)
4. [18. Российская специфика](18-ru-compliance-deep.md)
5. [21. Люди и процесс](21-people-process.md)

<a id="ml-injenery-i-data-scientists"></a>

### ML-инженеры и Data Scientists
1. [02. ML System Design](02-stage0-ml-system-design.md)
2. [03. Data Operations](03-stage1-data-operations.md)
3. [04. Model Operations](04-stage2-model-operations.md)
4. [07. Red Teaming](07-red-teaming-testing-methods.md)
5. [16. ML Attacks](16-ml-attacks-rag-multimodal.md)
6. [17. PET](17-privacy-enhancing-tech.md)

<a id="security-injenery"></a>

### Security-инженеры
1. [08. Управление доступом и секретами](08-access-secrets-management.md)
2. [09. Threat Modeling](09-threat-modeling.md)
3. [10. Защита LLM-агентов](10-llm-agent-protection.md)
4. [11. Безопасность чат-ботов](11-chatbot-conversational-security.md)
5. [12. Методы обнаружения и защиты](12-detection-protection-cicd-llm.md)
6. [15. AI Incident Response](15-ai-incident-response.md)
7. [16. ML Attacks](16-ml-attacks-rag-multimodal.md)
8. [20. Код-ассистенты](20-code-assistants-security.md)

<a id="devops-i-mlops-injenery"></a>

### DevOps и MLOps-инженеры
1. [05. Model Deployment](05-stage3-model-deployment.md)
2. [06. Operations & Platform](06-stage4-operations-platform.md)
3. [12. CI/CD для LLM](12-detection-protection-cicd-llm.md)
4. [19. Training Infrastructure](19-training-infrastructure.md)

<a id="razrabotciki-i-timlidy"></a>

### Разработчики и тимлиды
1. [20. Код-ассистенты](20-code-assistants-security.md)
2. [14. Governance (Use Policy)](14-model-risk-governance.md)
3. [21. Люди и процесс (AI Literacy)](21-people-process.md)

<a id="compliance-uristy-audit"></a>

### Compliance, юристы, аудит
1. [18. Российская специфика](18-ru-compliance-deep.md)
2. [14. Governance](14-model-risk-governance.md)
3. [15. AI Incident Response (уведомления)](15-ai-incident-response.md)
4. [21. Люди и процесс (Bug Bounty)](21-people-process.md)

<a id="finops-i-cfo"></a>

### FinOps и CFO
1. [22. FinOps для ИИ](22-finops-ai.md)
2. [14. Governance (AI-BOM)](14-model-risk-governance.md)
3. [13. Внедренческий плейбук](13-implementation-ru-playbook.md)

---

<a id="standarty-i-frejmvorki"></a>

## Стандарты и фреймворки

| Стандарт, фреймворк | Документы |
|-------------------|----------|
| [OWASP Machine Learning Security Top Ten](https://owasp.org/projects/machine-learning-security-top-ten) (lab/draft) | 09, 11; исторический контекст 2023 не означает окончательную редакцию |
| OWASP LLM Top 10 (2025) | 09, 10, 11, 13, 16, 20 |
| OWASP GenAI LLM Top 10 (2026; отдельная редакция) | README, матрица OWASP; без автоматического переноса кодов 2025 |
| OWASP Agentic AI Top 10 | 10, 13, 15 |
| MITRE ATLAS v2026.10 | 09, 13, 15, 16, 21, 23; матрица ATLAS |
| STRIDE, STRIDE-AI | 09, 11, 16 |
| NIST AI RMF 1.0 | 01, 02, 13, 14, 21 |
| NIST AI 600-1, GenAI Profile (дополнение к RMF 1.0) | 31, тематическая актуализация источников |
| NIST SP 2400-102e2026 (Initial Public Draft, 09.11.2026) | 09, 10, 31–36; проект документа, не окончательный стандарт |
| OWASP Securing Agentic Applications V2 | 31–36; руководство отдельно от таксономии ASI и протокола ACS |
| MCP Current 2026-07-28: Authorization, elicitation, MRTR; sampling deprecated | 10, 33–36 |
| NIST AI 100-2 (Adversarial ML) | 16 |
| NIST SP 800-226 (DP) | 17 |
| EU AI Act с поправками Регламента 2026/1744 | 01, 02, 14, 18, 21; матрица и календарь применимости |
| ISO/IEC 42001:2023 (AI MS) | 01, 13, 14, 21 |
| ISO/IEC 23894:2023 (AI Risk) | 01, 13, 14 |
| SLSA Framework | 05, 12, 19 |
| CIS Benchmarks (K8s, Docker, Linux) | 05, 06, 19 |
| GDPR | 03, 08, 11 |
| 152-ФЗ, 149-ФЗ, 98-ФЗ | 03, 08, 13, 18 |
| 243-ФЗ от 26.07.2026 (БФМ; отдельные даты применения статей) | 18, 26, 27, 29; календарь и роли для предупреждения о происхождении |
| 187-ФЗ КИИ, ГосСОПКА | 13, 15, 18 |
| 242-ФЗ (локализация ПДн) | 18 |
| ГОСТ Р 57580 (ЦБ РФ) | 13, 18 |
| ГОСТ Р 71476-2024 | 13 |
| Приказы ФСТЭК 117 (ранее 17), 21, 31, 239 | 13, 18 |
| Положения ЦБ 716-П, 850-П (ранее 787-П); историческое письмо 240-Т | 13, 14, 15, 18; разные статус и область применения |
| Приказ ФСБ 378 (СКЗИ) | 17, 18 |
| CycloneDX AI/ML-BOM (пример шаблона — 1.5) | 14; BOM не заменяет реестр AI-систем |
| SR 26-2 (Federal Reserve MRM, 17.04.2026; заменило SR 11-7) | 14; guidance США, не универсальное требование РФ |
| C2PA 2.5 (Content Provenance) | 16, 26, 27, 29; происхождение отдельно от истинности |

---

<a id="instrumenty"></a>

## Инструменты

Это указатель упоминаний в главах, а не список одобренных актуальных поставщиков. Состояние сопровождения, версия, лицензия и область проверки устанавливаются отдельно; историческое упоминание не означает рекомендацию для нового внедрения. В частности, статус инструментов защиты агентов сверён в [§24 главы 10](10-llm-agent-protection.md).

| Категория | Инструмент | Документы |
|-----------|-----------|----------|
| Secrets, KMS | Vault, OpenBao, SOPS, gitleaks, trufflehog, External Secrets Operator | 08, 13, 20 |
| IAM, SSO | Keycloak, Authentik, Authelia, Zitadel, OpenFGA, Permify, OPA, SPIFFE/SPIRE | 08, 13 |
| Model Registry, Tracking | MLflow, DVC, ClearML, W&B (self-hosted), Aim | 03, 04, 19 |
| Data Validation | Great Expectations, Deepchecks, Pandera, Soda, Evidently, WhyLogs | 03, 13 |
| PII / ПДн детекция | Presidio, Natasha, DeepPavlov, Razdel, spaCy ru | 03, 13 |
| Adversarial ML | ART, CleverHans, Foolbox, TextAttack, Counterfit, AugLy | 04, 07, 16 |
| LLM Red Teaming | Garak, PyRIT, Promptfoo, Giskard, Inspect AI, DeepEval, RAGAS, TruLens | 07, 13, 14, 16 |
| LLM Guardrails | NeMo Guardrails, Guardrails AI, LlamaFirewall, Invariant | 10, 12, 13, 16 |
| Agent Security | Agentic Radar, LlamaFirewall | 10, 13 |
| Runtime security | Falco, Tetragon, Tracee, eBPF, Cilium | 06, 12, 13, 19 |
| Container security | Trivy, Grype, Syft, Kubescape, kube-bench | 05, 13, 19 |
| Policy engines | Kyverno, OPA Gatekeeper | 13, 19 |
| Supply chain | Sigstore, Cosign, in-toto, SLSA, Dependency-Track, OSV-Scanner, Scorecard, GUAC | 05, 12, 13, 16, 19 |
| Model scanning | ModelScan, picklescan, fickling; покрытие форматов проверяется отдельно | 04, 13, 16, 19 |
| Формат весов и доставка обновлений | SafeTensors (формат), TUF (доверенная доставка); не сканеры backdoor | 04, 13, 16, 19 |
| Observability | Prometheus, Grafana, Loki, Tempo, OpenTelemetry, SigNoz, Jaeger | 06, 12, 13, 19, 22 |
| ML Monitoring | Evidently AI, WhyLogs, Arize Phoenix, Arthur AI, Fiddler, NannyML | 06, 13, 14 |
| SIEM / SOAR | Wazuh, SecurityOnion, TheHive, Shuffle, Sigma, Suricata, Zeek, CrowdSec | 13, 15 |
| WAF / API gateway | Coraza, ModSecurity, OWASP CRS, Envoy, Traefik, APISIX, Kong, NGINX | 05, 13 |
| SAST, Dep-Scan | Bandit, pip-audit, Semgrep, CodeQL, OSV-Scanner, Snyk Code | 04, 12, 13, 20 |
| IaC Security | Checkov, tfsec, KICS | 04, 13 |
| DAST | OWASP ZAP, Nuclei, Wapiti, Schemathesis, RESTler | 12, 13 |
| LLM Gateway, DLP | Rilio, LiteLLM, Helicone, Langfuse, OpenLLMetry, Arize Phoenix, Portkey | 13, 20, 22 |
| Self-hosted LLM | Ollama, LM Studio, vLLM, TGI, LocalAI, llama.cpp, SGLang, Aphrodite, OpenWebUI | 13, 20 |
| Vector DB, RAG | pgvector, Qdrant, Weaviate, Milvus, Chroma, Vespa, Haystack, LlamaIndex, LangChain | 13, 16 |
| Differential Privacy | Opacus, TensorFlow Privacy, diffprivlib | 17 |
| Federated Learning | Flower (FLWR), NVFlare, FedML, PySyft, FATE | 17 |
| TEE / Confidential | Intel SGX/TDX, AMD SEV-SNP, Confidential Containers, Gramine, Enarx, Keylime | 17 |
| Homomorphic Encryption | OpenFHE, SEAL, TenSEAL, Zama TFHE-rs, Concrete | 17 |
| Threat Modeling | OWASP Threat Dragon, pytm, MITRE ATLAS Navigator, IriusRisk | 09, 13 |
| MLOps | MLflow, Kubeflow, ZenML, Metaflow, Feast, BentoML, KServe, Ray Serve, Triton | 04, 05, 13, 19 |
| Dataset governance | DVC, Cleanlab, Deepchecks | 03, 16, 19 |
| Secret scanning | gitleaks, trufflehog, GitGuardian | 13, 20 |
| License scanning | FOSSA, ScanCode | 20 |
| FinOps | OpenCost, Kubecost, Helicone, Langfuse | 22 |

---

<a id="kajdyj-dokument-soderjit"></a>

## Каждый документ содержит

1. Краткое резюме раздела. Суть методики.
2. Верификация фактов и инструментов. Проверка актуальности.
3. Рекомендации ИБ. С позиции службы информационной безопасности.
4. Шаблоны и примеры. Код, конфигурации, YAML.
5. Чеклисты. Для самопроверки.
6. Типичные ошибки. Антипаттерны и их последствия.
