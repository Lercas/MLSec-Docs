<a id="matriza-sootvetstvia-mitre-atlas"></a>

# Матрица соответствия: MITRE ATLAS

> Сопоставление тактик и техник MITRE ATLAS (Adversarial Threat Landscape for Artificial Intelligence Systems) с главами MLSec Recommendations и практиками защиты.

<a id="oboznacenia"></a>

## Обозначения

- Идентификаторы тактик/техник сверены с набором данных ATLAS (`mitre-atlas/atlas-data`); проверено 13.11.2026 по официальному [release v2026.10 от 28.10.2026](https://github.com/mitre-atlas/atlas-data/releases/tag/v2026.10): версия content `2026.10`, schema/data-format `6.1.0`. Это разные оси версии. Тактики имеют формат `AML.TAxxxx`, техники — `AML.Txxxx`, суб-техники — `AML.Txxxx.NNN`. ID тактик в ATLAS неупорядочены относительно колонок матрицы.
- В колонке "Detect" ссылка на правила детекции (sigma-правила, anomaly detection).
- В колонке "Mitigate" ссылка на профилактические меры.

**Граница покрытия:** в snapshot 16 tactics, 129 parent techniques, 92 subtechniques, 44 mitigations и 77 case studies. Это числа записей, не coverage / incident rate; case studies включают Incident и Exercise. Ниже выбранная подматрица. `Detect` / `Mitigate` — предложенные нами практики, не дословные MITRE mitigation statements и не доказательство предотвращения атаки.

<a id="taktika-reconnaissance-amlta0002"></a>

## Тактика: Reconnaissance (AML.TA0002)

| Техника | ID | Главы | Detect | Mitigate |
|---------|-----|-------|--------|----------|
| Search Open AI Vulnerability Analysis | AML.T0001 | [07](../07-red-teaming-testing-methods.md) | Мониторинг открытых vulnerability reports об используемых AI-компонентах | Устранение подтверждённых уязвимостей, review публично раскрытых сведений |
| Search Application Repositories | AML.T0004 | [04](../04-stage2-model-operations.md) | Monitoring HuggingFace / GitHub по корпоративным именам моделей | Запрет публикации production-моделей в public-repo |

<a id="taktika-resource-development-amlta0003"></a>

## Тактика: Resource Development (AML.TA0003)

| Техника | ID | Главы | Detect | Mitigate |
|---------|-----|-------|--------|----------|
| Acquire Public AI Artifacts | AML.T0002 | [04](../04-stage2-model-operations.md) | AI-BOM tracking, мониторинг публикации trojanized adapters | Cosign verify, SBOM, источники только из реестра |
| Obtain Capabilities | AML.T0016 | [04](../04-stage2-model-operations.md) | SCA (Trivy, Grype) | SLSA Level 3+, pinned dependencies |
| Develop Capabilities | AML.T0017 | [07](../07-red-teaming-testing-methods.md) | Threat intel | |
| Publish Poisoned AI Artifacts | AML.T0115 | [03](../03-stage1-data-operations.md) | Data lineage, checksum, distribution tests | Происхождение / permitted use, quarantine→promotion и independent validation; подпись не гарантирует чистоту |
| Publish Hallucinated Entities | AML.T0060 | [10](../10-llm-agent-protection.md) | Проверка сгенерированных package / domain references и namespace ownership | Allowlist источников, dependency resolution до исполнения, review нового артефакта |

<a id="taktika-ai-model-access-amlta0000"></a>

## Тактика: AI Model Access (AML.TA0000)

| Техника | ID | Главы | Detect | Mitigate |
|---------|-----|-------|--------|----------|
| AI Model Inference API Access | AML.T0040 | [12](../12-detection-protection-cicd-llm.md) | Rate limit, anomaly detection на серии запросов | Rilio Gateway, auth, RBAC |
| AI-Enabled Product or Service | AML.T0047 | [12](../12-detection-protection-cicd-llm.md) | Audit log | Минимизация публичной поверхности |
| Physical Environment Access | AML.T0041 | [05](../05-stage3-model-deployment.md) | Physical security logs | TEE, HSM |
| Full AI Model Access | AML.T0044 | [05](../05-stage3-model-deployment.md) | DLP на egress, контроль выхода артефактов | Tenant isolation, access control, encrypted at rest |

<a id="taktika-execution-amlta0005"></a>

## Тактика: Execution (AML.TA0005)

| Техника | ID | Главы | Detect | Mitigate |
|---------|-----|-------|--------|----------|
| User Execution | AML.T0011 | [14](../14-model-risk-governance.md) | EDR, user training monitoring | AI Literacy training, политики использования |
| Command and Scripting Interpreter | AML.T0050 | [05](../05-stage3-model-deployment.md) | EDR | Allowlist ПО |
| LLM Prompt Injection | AML.T0051 | [07](../07-red-teaming-testing-methods.md), [12](../12-detection-protection-cicd-llm.md) | DLP Layer 0 injection scanner, sigma-правила | Разделение данных/инструкций + executor authorization; DLP/guardrails — дополнительные сигналы |
| Direct | AML.T0051.000 | [12](../12-detection-protection-cicd-llm.md) | Rilio Layer 0-3 | Разделение данных/инструкций + executor authorization; DLP/guardrails — дополнительные сигналы |
| Indirect | AML.T0051.001 | [10](../10-llm-agent-protection.md), [12](../12-detection-protection-cicd-llm.md) | RAG corpus poisoning checks, content tagging | Разделение данных/инструкций + executor authorization; DLP/guardrails — дополнительные сигналы |
| AI Agent Tool Invocation | AML.T0053 | [10](../10-llm-agent-protection.md) | Anomaly detection на tool calls, audit | Tool allowlist, sandbox (gvisor / Firecracker / WASM), HITL |

<a id="taktika-persistence-amlta0006"></a>

## Тактика: Persistence (AML.TA0006)

| Техника | ID | Главы | Detect | Mitigate |
|---------|-----|-------|--------|----------|
| Training Data Poisoning | AML.T0020 | [03](../03-stage1-data-operations.md), [04](../04-stage2-model-operations.md) | Statistical anomaly detection на train-set | Data lineage, signed datasets, filtering |
| Manipulate AI Model | AML.T0018 | [04](../04-stage2-model-operations.md) | Behavioral anomaly detection, trigger scanning | Model signing, SLSA, independent validation |
| RAG Poisoning | AML.T0070 | [16](../16-ml-attacks-rag-multimodal.md), [24](../24-vector-db-security.md) | Corpus change history, source trust и retrieval canaries | Quarantine/promotion, ACL freshness, rollback corpus revision |
| AI Agent Context Poisoning | AML.T0080 | [32](../32-ai-agents-operating-overlay.md) | Context provenance и action trace с injected memory/retrieval | Untrusted context не меняет полномочия executor |
| Modify AI Agent Configuration | AML.T0081 | [33](../33-ai-agents-security-overlay.md) | Diff agent config / tool registry и проверка активной revision | Independent publish authority, signed revision, revoke |

<a id="taktika-defense-evasion-amlta0007"></a>

## Тактика: Defense Evasion (AML.TA0007)

| Техника | ID | Главы | Detect | Mitigate |
|---------|-----|-------|--------|----------|
| Evade AI Model | AML.T0015 | [07](../07-red-teaming-testing-methods.md) | Adversarial testing, confidence drop monitoring | Adversarial training, ensemble models |
| LLM Prompt Obfuscation | AML.T0068 | [12](../12-detection-protection-cicd-llm.md) | Unicode normalization, homoglyph detection | Pre-processing, DLP Layer 0 updates |
| False RAG Entry Injection | AML.T0071 | [16](../16-ml-attacks-rag-multimodal.md) | Проверка nested false-document / metadata в разрешённых источниках и фактической интерпретации retrieved chunks | Write authorization + provenance / review содержимого до promotion; authorized ingest сам по себе не исключает injection |

<a id="taktika-discovery-amlta0008"></a>

## Тактика: Discovery (AML.TA0008)

| Техника | ID | Главы | Detect | Mitigate |
|---------|-----|-------|--------|----------|
| Discover AI Model Ontology | AML.T0013 | [12](../12-detection-protection-cicd-llm.md) | Query pattern analysis | Limited error messages, abstracted API |
| Discover AI Model Family | AML.T0014 | [12](../12-detection-protection-cicd-llm.md) | Fingerprinting query detection | Model fingerprint obfuscation |
| Discover AI Artifacts | AML.T0007 | [04](../04-stage2-model-operations.md) | Repository monitoring | Private repos, access control |
| Recover AI Model Internals | AML.T0144 | [07](../07-red-teaming-testing-methods.md) | Разрешённые probes восстановления непубличных model internals | Минимизировать раскрытие internals, ограничить oracle; один rate limit не доказывает защиту |

<a id="taktika-collection-amlta0009"></a>

## Тактика: Collection (AML.TA0009)

| Техника | ID | Главы | Detect | Mitigate |
|---------|-----|-------|--------|----------|
| AI Artifact Collection | AML.T0035 | [05](../05-stage3-model-deployment.md) | DLP egress, outbound volume | Tenant isolation, encryption |
| Data from Information Repositories | AML.T0036 | [03](../03-stage1-data-operations.md) | Audit log, DLP | RBAC, data minimization |
| Invert AI Model | AML.T0137.002 | [07](../07-red-teaming-testing-methods.md) | Model inversion detection | Privacy threat assessment и проверяемый PET; DP применима только с механизмом / accounting |
| Infer Membership | AML.T0137.000 | [12](../12-detection-protection-cicd-llm.md) | Membership inference detection | Data minimization и оценка MIA на matched non-members; output filtering недостаточен |
| Conversation Context and Memory | AML.T0085.002 | [12](../12-detection-protection-cicd-llm.md) | Canary в conversation/memory и проверка cross-user / cross-session выдачи | Серверные ACL на histories/memory, scoped retrieval/cache, минимизация контекста |
| Extract Memorized Data | AML.T0137.003 | [04](../04-stage2-model-operations.md), [17](../17-privacy-enhancing-tech.md) | Canary / authorized extraction tests по memorized training content | Минимизация данных, eval contamination/privacy review; не путать с memory leakage |

<a id="taktika-ai-attack-adaptation-amlta0001"></a>

## Тактика: AI Attack Adaptation (AML.TA0001)

| Техника | ID | Главы | Detect | Mitigate |
|---------|-----|-------|--------|----------|
| Replicate AI Model Behavior | AML.T0005 | [07](../07-red-teaming-testing-methods.md) | Query volume + distribution analysis | Rate limit, query diversity analysis |
| Replicate Behavior from Model Outputs | AML.T0005.001 | [07](../07-red-teaming-testing-methods.md) | Systematic coverage detection (LHS) | Response randomization |
| Craft Adversarial Data | AML.T0043 | [07](../07-red-teaming-testing-methods.md) | ART / CleverHans regular runs | Adversarial training |

<a id="taktika-exfiltration-amlta0010"></a>

## Тактика: Exfiltration (AML.TA0010)

| Техника | ID | Главы | Detect | Mitigate |
|---------|-----|-------|--------|----------|
| Exfiltration via AI Inference API | AML.T0024 | [12](../12-detection-protection-cicd-llm.md) | DLP post-call, anomaly on output size | Output size limit, DLP block |
| Exfiltration via AI Agent Tool Invocation | AML.T0086 | [33](../33-ai-agents-security-overlay.md) | Tool destination / args / outcome, canary egress | Egress / tool ACL и reauthorization после очереди |

<a id="taktika-impact-amlta0011"></a>

## Тактика: Impact (AML.TA0011)

| Техника | ID | Главы | Detect | Mitigate |
|---------|-----|-------|--------|----------|
| Evade AI Model | AML.T0015 | [07](../07-red-teaming-testing-methods.md) | Adversarial testing | Adversarial training |
| Denial of AI Service | AML.T0029 | [12](../12-detection-protection-cicd-llm.md) | Anomaly detection, volume metrics | Rate limit, kill-switch L0 |
| Spamming AI System with Chaff Data | AML.T0046 | [12](../12-detection-protection-cicd-llm.md) | Pattern detection | Rate limit, CAPTCHA on anomalous patterns |
| Erode AI Model Integrity | AML.T0031 | [04](../04-stage2-model-operations.md) | Model drift monitoring | Immutable models, rollback |
| Cost Harvesting | AML.T0034 | [12](../12-detection-protection-cicd-llm.md) | Budget monitoring | Budget control, token limit |
| External Harms | AML.T0048 | [14](../14-model-risk-governance.md) | Reputation monitoring | AI Use Policy, HITL for critical decisions |

<a id="migrazia-ssylok-i-proverka-evidence"></a>

## Миграция ссылок и проверка evidence

В этой редакции исправлены значения старых ссылок; это не универсальная механическая таблица переименования:

| Прежняя запись этой матрицы | Текущее решение | Почему нужна проверка сценария |
|---|---|---|
| T0019 «Publish Poisoned Datasets» | T0115 Publish Poisoned AI Artifacts | Сценарий публикации отравленного артефакта, не любое изменение training set |
| T0053 «Plugin Compromise» | Точное имя T0053 AI Agent Tool Invocation | Compromise tool supply chain требует отдельной ссылки по фактическому пути |
| T0060 «Prompt Self-Replication» | Publish Hallucinated Entities, Resource Development | Это публикация attacker-controlled сущности по галлюцинированной ссылке, не репликация prompt |
| T0024.000 / .001 | T0137.000 / .002, Collection | Membership inference / inversion — сбор сведений; exfiltration может быть отдельным следующим шагом |
| T0024.002 «Extract Model» | T0144 только для recovery internals | Для functional replica см. T0005.001, для collection outputs — T0135; не один универсальный extraction ID |
| T0057 «Data Leakage» | T0085.002 для conversation/memory | Training memorization вынесена в отдельную строку T0137.003 |

**Как читать mitigation:** подпись подтверждает integrity / signer в выбранной trust model, не отсутствие poisoning; sandbox ограничивает ресурсы, но не отзывает законный сетевой доступ; DLP / normalizer могут пропускать indirect injection. MITRE ID описывает поведение противника, а не обязательный продукт или успешность защиты.

| Источник / сценарий | Наша трактовка и контроль | Проверяемое evidence | Непокрытый аспект |
|---|---|---|---|
| T0070 / T0071, отравление RAG | Различать T0070 poisoning corpus и T0071 ложный документ внутри обычной ingest entry. Проверять как unauthorized write, так и authorized ingest с вложенной false metadata; promotion + write/read ACL | Before/after corpus revisions, unauthorized write denied, nested false-document test на разрешённом источнике, retrieval interpretation trace, cache invalidation / rollback | Чистый corpus не исключает injection из разрешённого внешнего документа |
| T0080 → T0053 → T0086 | Контекст склоняет к tool exfiltration; executor проверяет grant/args/destination | Canary document → tool proposal → denied decision, отсутствие внешнего receipt, audit/egress trace; clean permitted call проходит | Текстовый отказ LLM без контроля внешнего эффекта не закрывает путь |
| T0081 | Agent config — часть control plane | Попытка изменить allowlist агентным identity отвергнута; reviewer-approved revision отражена в runtime readback | Подписанный старый config после revoke требует отдельной freshness проверки |
| T0137.000 / .003 | MIA и training extraction измеряются на разрешённой тестовой выборке | Matched member/non-member protocol, low-FPR / uncertainty, independent holdout и canary result | Нулевые находки не доказывают отсутствие memorization / юридическую анонимность |

**Закрытие строки:** сохранить snapshot version, ID + tactic relationship, asset / attacker capability, test subject digest, positive/negative/failure cases и reviewer. Неиспользуемый tool может дать обоснованное N/A для конкретного пути, но не для всей тактики. Остаток каталога и другие attacker capabilities остаются вне этой подматрицы. Подробная таксономия: [глава 23](../23-mitre-atlas-ru.md).

<a id="sm-takje"></a>

## См. также

- [MITRE ATLAS (актуальная матрица)](https://atlas.mitre.org/)
- [OWASP-LLM-TOP10.md](OWASP-LLM-TOP10.md) - пересекается по рискам LLM
- Глава [07. Red Teaming](../07-red-teaming-testing-methods.md)
- Глава [12. Методы обнаружения и защиты (Gateway и DLP)](../12-detection-protection-cicd-llm.md)
