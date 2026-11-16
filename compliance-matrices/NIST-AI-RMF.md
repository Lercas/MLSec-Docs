<a id="matriza-sootvetstvia-nist-ai-rmf-10-genai-profile"></a>

# Матрица соответствия: NIST AI RMF 1.0 + GenAI Profile

> Сопоставление функций NIST AI Risk Management Framework (NIST AI 100-1) и GenAI Profile (NIST AI 600-1) с главами MLSec Recommendations. Функции: GOVERN, MAP, MEASURE, MANAGE; локальные сокращения не используются как официальные control IDs.

<a id="status-istocnikov-i-sposob-ctenia"></a>

## Статус источников и способ чтения

Проверено 13.11.2026: [AI RMF 1.0 / NIST AI 100-1, январь 2023, Core tables 1–4](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.100-1.pdf) и [GenAI Profile / NIST AI 600-1, июль 2024](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf) — опубликованные документы для добровольного применения. В таблицах ниже описание — сокращённый пересказ outcome; главы и артефакты — **наша реализация**, не перечень инструментов, предписанных NIST. Ни шаблон, ни scanner сами по себе не доказывают достижение outcome.

[SP 2400-102 E2026 от 09.11.2026](https://csrc.nist.gov/pubs/sp/2400-102/e2026/ipd) — **Initial Public Draft**, taxonomy атак и mitigations, включая агентный контекст. Используется для research/threat-model review, не как новая редакция RMF, обязательная норма или финальное основание сертификации. Draft-связь в threat register хранится отдельно от final RMF outcome; изменение taxonomy не переносит статус pass между ними.

<a id="govern"></a>

## GOVERN

| Пункт | Описание | Главы | Артефакты |
|-------|----------|-------|-----------|
| Govern 1.1 | Legal, regulatory requirements understood and managed | [14](../14-model-risk-governance.md), [18](../18-ru-compliance-deep.md) | [PIA-TEMPLATE](../templates/PIA-TEMPLATE.md), [FSTEK-AUDIT-CHECKLIST](../templates/FSTEK-AUDIT-CHECKLIST.md) |
| Govern 1.2 | Trustworthiness встроена в политики и процессы | [14](../14-model-risk-governance.md), [09](../09-threat-modeling.md) | Trustworthiness policy и карта требований |
| Govern 1.3 | Объём risk management соразмерен risk tolerance | [14](../14-model-risk-governance.md) | Обоснование scope / ресурсов и risk tolerance |
| Govern 1.4 | Прозрачные risk policies и controls | [14](../14-model-risk-governance.md) | Утверждённый процесс и владельцы решений |
| Govern 1.5 | Мониторинг / review процесса и outcomes | [14](../14-model-risk-governance.md) | Review cadence с владельцами и результатами |
| Govern 1.6 | Инвентарь AI-систем и ресурсы по приоритетам | [14](../14-model-risk-governance.md), [06](../06-stage4-operations-platform.md) | AI inventory, owner, ресурсы и текущий статус |
| Govern 1.7 | Decommission processes are in place | [04](../04-stage2-model-operations.md), [15](../15-ai-incident-response.md) | Model retirement playbook |
| Govern 2.1 | Roles, responsibilities, lines of communication | [14](../14-model-risk-governance.md), [role-cheatsheets/](../role-cheatsheets/) | RACI, role cheatsheets |
| Govern 2.2 | Personnel provided training | [14](../14-model-risk-governance.md) | AI Literacy программа |
| Govern 2.3 | Executive leadership responsible | [14](../14-model-risk-governance.md) | AI steering committee |
| Govern 3.1 | Разнообразие дисциплин / опыта команды при принятии risk decisions | [14](../14-model-risk-governance.md) | Состав multidisciplinary team и участие разных expertise / affected groups |
| Govern 3.2 | Роли human–AI и oversight разграничены | [10](../10-llm-agent-protection.md), [33](../33-ai-agents-security-overlay.md) | Authority / approval matrix, проверки передачи управления |
| Govern 4.1 | Критическое мышление и safety-first культура | [14](../14-model-risk-governance.md) | [AI-USE-POLICY-TEMPLATE](../templates/AI-USE-POLICY-TEMPLATE.md) |
| Govern 4.2 | Organizational teams document risks | [09](../09-threat-modeling.md) | [THREAT-MODEL-TEMPLATE](../templates/THREAT-MODEL-TEMPLATE.md) |
| Govern 4.3 | Тестирование, выявление инцидентов, обмен информацией | [14](../14-model-risk-governance.md) | Test process, incident intake и sharing decisions |
| Govern 5.1 | Внешняя обратная связь об impacts | [14](../14-model-risk-governance.md), [15](../15-ai-incident-response.md) | Feedback channels, affected-party input |
| Govern 5.2 | Согласованная обратная связь меняет систему | [14](../14-model-risk-governance.md), [06](../06-stage4-operations-platform.md) | Feedback triage → change decision → проверка эффекта |
| Govern 6.1 | Риски третьих сторон, включая IP / права | [18](../18-ru-compliance-deep.md) | Vendor/data-use assessment, разрешения, ограничения |
| Govern 6.2 | Contingency для third-party failures / incidents | [04](../04-stage2-model-operations.md), [15](../15-ai-incident-response.md) | Fallback / stop / restore drill с policy scope |

<a id="map"></a>

## MAP

| Пункт | Описание | Главы | Артефакты |
|-------|----------|-------|-----------|
| Map 1.1 | Context of AI system established | [02](../02-stage0-ml-system-design.md) | [THREAT-MODEL-TEMPLATE](../templates/THREAT-MODEL-TEMPLATE.md) раздел 1 |
| Map 1.2 | Interdisciplinary collaboration | [14](../14-model-risk-governance.md) | Cross-functional reviews |
| Map 1.3 | Миссия и цели организации задокументированы | [14](../14-model-risk-governance.md) | Tiering, risk acceptance |
| Map 1.4 | Business value defined | [02](../02-stage0-ml-system-design.md) | ROI analysis |
| Map 1.5 | Organizational risk tolerances determined | [14](../14-model-risk-governance.md) | Risk tolerance; внутренний Tier 1–4 не является классификацией NIST |
| Map 1.6 | System requirements documented | [02](../02-stage0-ml-system-design.md) | Design docs |
| Map 2.1 | Определены задачи системы и методы их реализации | [02](../02-stage0-ml-system-design.md), [14](../14-model-risk-governance.md) | [AI-BOM-EXAMPLE](../templates/AI-BOM-EXAMPLE.json) |
| Map 2.2 | Knowledge limits, использование outputs и human oversight документированы | [04](../04-stage2-model-operations.md) | Model cards |
| Map 2.3 | Scientific integrity addressed | [07](../07-red-teaming-testing-methods.md) | Validation protocols |
| Map 3.1 | Potential benefits examined | [02](../02-stage0-ml-system-design.md) | Business case |
| Map 3.2 | Potential costs examined | [14](../14-model-risk-governance.md) | Cost modeling |
| Map 3.3 | Границы приложения по capabilities и контексту | [14](../14-model-risk-governance.md) | Intended-use / out-of-scope register |
| Map 3.4 | Компетентность операторов и practitioners | [10](../10-llm-agent-protection.md) | Обучение, проверка понимания ограничений / oversight |
| Map 3.5 | Human oversight defined | [10](../10-llm-agent-protection.md), [14](../14-model-risk-governance.md) | HITL policies |
| Map 4.1 | Legal risks mapped | [18](../18-ru-compliance-deep.md) | [PIA-TEMPLATE](../templates/PIA-TEMPLATE.md) |
| Map 4.2 | Internal risks mapped | [09](../09-threat-modeling.md) | Threat model |
| Map 5.1 | Вероятность / масштаб beneficial и harmful impacts | [09](../09-threat-modeling.md) | STRIDE-AI analysis |
| Map 5.2 | Взаимодействие с affected parties по impacts | [14](../14-model-risk-governance.md) | Engagement record и пересмотр решения по feedback |

<a id="measure"></a>

## MEASURE

| Пункт | Описание | Главы | Артефакты |
|-------|----------|-------|-----------|
| Measure 1.1 | Approaches and metrics identified | [07](../07-red-teaming-testing-methods.md) | Metrics catalog |
| Measure 1.2 | Пригодность метрик и эффективность контролей пересматриваются | [07](../07-red-teaming-testing-methods.md) | Metric validity / errors / affected-group review |
| Measure 1.3 | Internal experts and end-users consulted | [07](../07-red-teaming-testing-methods.md) | Red team + UAT |
| Measure 2.1 | Test sets, metrics identified | [04](../04-stage2-model-operations.md) | Test datasets, adversarial sets |
| Measure 2.2 | Evaluations involving humans | [07](../07-red-teaming-testing-methods.md) | Human evaluation protocols |
| Measure 2.3 | Performance demonstrated | [04](../04-stage2-model-operations.md) | Benchmarks, A/B tests |
| Measure 2.4 | Поведение системы отслеживается в production | [06](../06-stage4-operations-platform.md) | Active revisions, workload metrics, drift / route traces |
| Measure 2.5 | Validity / reliability и пределы обобщения | [04](../04-stage2-model-operations.md), [07](../07-red-teaming-testing-methods.md) | Evaluation report с deployment-like conditions и limitations |
| Measure 2.6 | Safety, остаточный риск и безопасный отказ | [05](../05-stage3-model-deployment.md) | Safety/failure tests и согласованная risk tolerance |
| Measure 2.7 | AI system security documented | [12](../12-detection-protection-cicd-llm.md) | DLP metrics, pentest reports |
| Measure 2.8 | Риски transparency / accountability | [09](../09-threat-modeling.md) | Disclosure, decision trace и ownership review |
| Measure 2.9 | AI model explained | [10](../10-llm-agent-protection.md) | Explainability reports |
| Measure 2.10 | Privacy risks assessed | [18](../18-ru-compliance-deep.md) | [PIA-TEMPLATE](../templates/PIA-TEMPLATE.md) |
| Measure 2.11 | Fairness and bias measured | [07](../07-red-teaming-testing-methods.md) | Bias audits |
| Measure 2.12 | Environmental impact | [05](../05-stage3-model-deployment.md) | Carbon tracking |
| Measure 2.13 | Эффективность TEVV метрик и процессов | [14](../14-model-risk-governance.md) | Проверка метрик / datasets / reviewers, не просто scanner pass |
| Measure 3.1 | Approaches to risk tracking | [14](../14-model-risk-governance.md) | Risk register |
| Measure 3.2 | Отслеживание трудноизмеримых рисков | [14](../14-model-risk-governance.md) | Unknown-risk register, qualitative assessment, revisiting triggers |
| Measure 3.3 | Сообщения / appeals пользователей и affected groups | [15](../15-ai-incident-response.md) | Complaint/appeal channel и связь с evaluation metrics |
| Measure 4.1 | Методы измерения связаны с deployment context | [04](../04-stage2-model-operations.md) | Domain / user consultation и measurement protocol |
| Measure 4.2 | Результаты проверены с relevant AI actors | [05](../05-stage3-model-deployment.md) | Review результатов и соответствия intended use |
| Measure 4.3 | Улучшения / ухудшения по feedback и field data | [15](../15-ai-incident-response.md) | Сравнение baseline/candidate и сегментов пользователей |

<a id="manage"></a>

## MANAGE

| Пункт | Описание | Главы | Артефакты |
|-------|----------|-------|-----------|
| Manage 1.1 | Решение о соответствии целям и продолжении разработки / deployment | [14](../14-model-risk-governance.md), [01](../01-overview-architecture.md) | Go/no-go decision с evidence, scope и владельцем |
| Manage 1.2 | Treatment for high-priority risks | [14](../14-model-risk-governance.md) | Mitigation plans |
| Manage 1.3 | Планы ответа на приоритетные риски | [14](../14-model-risk-governance.md) | Mitigate / transfer / avoid / accept с ответственными |
| Manage 1.4 | Остаточные риски downstream / end users документированы | [14](../14-model-risk-governance.md) | Residual risk disclosure и принятие владельцем |
| Manage 2.1 | Ресурсы и жизнеспособные non-AI alternatives | [14](../14-model-risk-governance.md) | Сравнение с ручным / non-AI baseline |
| Manage 2.2 | Mechanisms for sustained value | [14](../14-model-risk-governance.md) | Continuous improvement |
| Manage 2.3 | Ответ и восстановление при ранее неизвестном риске | [15](../15-ai-incident-response.md) | Emergent-risk response / recovery record |
| Manage 2.4 | Замещение, disengage / deactivate при несоответствии intended use | [15](../15-ai-incident-response.md) | Stop / revoke / queue / retry drill и назначенный owner |
| Manage 3.1 | AI risks and benefits from third parties | [04](../04-stage2-model-operations.md) | Vendor risk management |
| Manage 3.2 | Pre-trained models | [04](../04-stage2-model-operations.md) | Мониторинг pretrained model / provider revisions, provenance, maintenance и изменения условий |
| Manage 4.1 | Post-deployment monitoring | [05](../05-stage3-model-deployment.md) | Observability stack |
| Manage 4.2 | Measurable continuous improvement | [14](../14-model-risk-governance.md) | Maturity assessment |
| Manage 4.3 | Incidents and errors documented | [15](../15-ai-incident-response.md) | IR journals |

<a id="genai-profile-nist-ai-600-1"></a>

## GenAI Profile (NIST AI 600-1)

Дополнительные риски для генеративных ИИ-систем:

| Риск | Главы | Меры |
|------|-------|------|
| CBRN Information or Capabilities | [07](../07-red-teaming-testing-methods.md), [12](../12-detection-protection-cicd-llm.md) | Content policy, red team coverage |
| Confabulation (hallucinations) | [10](../10-llm-agent-protection.md), [12](../12-detection-protection-cicd-llm.md) | Hallucination scanner Layer 6, RAG grounding |
| Dangerous, Violent, or Hateful Content | [12](../12-detection-protection-cicd-llm.md) | DLP Layer 3 (toxicity classifier), content policy |
| Data Privacy | [03](../03-stage1-data-operations.md), [12](../12-detection-protection-cicd-llm.md) | Data minimization, scoped DLP, [PIA-TEMPLATE](../templates/PIA-TEMPLATE.md) |
| Environmental Impacts | [05](../05-stage3-model-deployment.md) | Измерение энергии / ресурсов целевого workload; локальное размещение само по себе не доказывает меньший impact |
| Harmful Bias or Homogenization | [07](../07-red-teaming-testing-methods.md) | Bias testing, diverse evaluation |
| Human-AI Configuration | [10](../10-llm-agent-protection.md) | HITL design, user training |
| Information Integrity | [12](../12-detection-protection-cicd-llm.md) | Provenance, watermarking |
| Information Security | [12](../12-detection-protection-cicd-llm.md) | Выбранные preventive/detective/recovery controls и attack-path tests |
| Intellectual Property | [12](../12-detection-protection-cicd-llm.md) | Проверка прав / permitted use; scanner — вспомогательный сигнал |
| Obscene, Degrading, Abusive Content | [12](../12-detection-protection-cicd-llm.md) | Content moderation |
| Value Chain and Component Integration | [04](../04-stage2-model-operations.md) | AI-BOM, SLSA |

<a id="ot-outcome-k-proverke-primer-agentnogo-workflow"></a>

## От outcome к проверке: пример агентного workflow

**Учебная система:** агент готовит платёж, но выполнить его может только executor после подтверждения конкретных аргументов. Это наш пример реализации RMF, не сценарий, предписанный NIST.

| Final RMF outcome | Наша трактовка / контроль | Проверяемое evidence | Что остаётся открытым |
|---|---|---|---|
| GOVERN 3.2; MAP 3.5 | Отдельные права proposer/approver/executor, delegation сужает scope | Authority matrix и trace: модель предлагает, человек подтверждает сумму/получателя, executor проверяет grant | Подтверждение UI без связи с аргументами не проверено |
| MEASURE 2.1; 2.3; 2.7 | Revision-bound positive/negative/failure suite в целевой среде | Report: изменённый получатель, expired grant в очереди, retry после timeout; внешний receipt + отсутствие повторного платежа | Test pass не означает отсутствие всех инъекций |
| MANAGE 2.4; 4.1 | Stop действует на действующие grants, очереди и retries | Runtime policy readback, stop time, отказ следующего tool-call, reconciliation ранее отправленных операций | Удалённый provider может не отменить уже выполненный эффект |
| MAP 1.4; MANAGE 2.2 | Польза и полная цена успешной принятой задачи отдельно от HTTP/latency | Baseline/candidate, ручные исправления, failures/retries/tools/review cost, sample/uncertainty | Без customer evidence польза остаётся гипотезой |

**Применимость:** фиксируются intended use, actor roles, owners, затронутые группы и границы проверки. Profile выбирает приоритеты; отсутствие доступной метрики записывается по MEASURE 1.1 / 3.2 как unknown, а не выводится из denominator как «покрыто». Для GenAI конкретные suggested action IDs берутся из AI 600-1 §3; таблица рисков выше не является их полным crosswalk.

Privacy оценивается на нескольких границах: разрешённое использование dataset и отзыв ([03](../03-stage1-data-operations.md)), весь base/adapter/runtime bundle и contamination ([04](../04-stage2-model-operations.md)), retrieval/cache ACL ([24](../24-vector-db-security.md)). DLP не заменяет эти проверки; DP требует явно заданного механизма, adjacency и privacy accounting. Provenance / C2PA ([29](../29-watermarking-attribution.md)) подтверждает проверяемую историю и подписи в выбранной trust model, не истинность утверждения или право обучения.

<a id="sm-takje"></a>

## См. также

- [NIST AI RMF 1.0 (актуальная версия)](https://www.nist.gov/itl/ai-risk-management-framework)
- [NIST AI 600-1 (GenAI Profile)](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf)
- [ISO-42001.md](ISO-42001.md) - дополняет NIST AI RMF по ISO-стандарту
- Глава [14. Governance](../14-model-risk-governance.md)
