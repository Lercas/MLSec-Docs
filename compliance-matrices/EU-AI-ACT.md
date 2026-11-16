<a id="matriza-sootvetstvia-eu-ai-act-regulation-eu-20241689"></a>

# Матрица соответствия: EU AI Act (Regulation (EU) 2024/1689)

> Сопоставление требований регламента Европейского союза по ИИ (EU AI Act) с главами MLSec Recommendations. Применимость устанавливается по роли, intended use и территориальному scope Art. 2, включая некоторые случаи использования output в ЕС при provider/deployer в третьей стране; это шире простого экспорта и не равно наличию любого EU-посетителя.

<a id="status-istocnika-i-rol_-organizazii"></a>

## Статус источника и роль организации

Проверено 13.11.2026 по [опубликованному Regulation (EU) 2026/1744, CELEX 32026R1744](https://eur-lex.europa.eu/legal-content/EN/ALL/?uri=oj%3AL_202601744): акт от 08.07.2026, OJ L от 24.07.2026, вступление 27.07.2026 по Art. 4. Он изменяет Regulation 2024/1689; это принятый акт, не только предложение или политическое соглашение. [Консолидация от 27.07.2026](https://eur-lex.europa.eu/eli/reg/2024/1689/2026-07-27/eng) помогает читать редакцию, но сама не имеет юридического эффекта: аутентичны опубликованные акты. [AI Act Explorer](https://ai-act-service-desk.ec.europa.eu/en/ai-act-explorer) и [календарь Комиссии](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai) остаются навигацией и пояснением. Наши практики / артефакты — способы подготовки evidence, не доказанная полнота соответствия.

**До выбора строки:** установить provider/deployer/importer/distributor/product manufacturer, связь с Union market / output use по [Art. 2](https://eur-lex.europa.eu/eli/reg/2024/1689/2026-07-27/eng), intended purpose, exclusions и дату размещения / изменения. Проверяются, в частности, размещение в Союзе, местонахождение deployer и использование output в Союзе при provider/deployer в третьей стране; гражданство пользователя или случайное посещение сайта не заменяют эти условия. Внутренний Tier не равен high-risk по Art. 6. GPAI — отдельная ось модельных обязанностей: использование API не делает организацию автоматически provider базовой модели.

<a id="klassifikazia-riskov"></a>

## Классификация рисков

EU AI Act классифицирует ИИ-системы по уровню риска:

| Уровень | Категория | Требования | Главы MLSec |
|---------|-----------|------------|-------------|
| Unacceptable | Социальный скоринг, manipulative AI, biometric real-time в public spaces (с оговорками) | Запрещены | [14](../14-model-risk-governance.md) - политика соответствия |
| High-risk | Критическая инфраструктура, образование, employment, law enforcement, medical devices | Определить Art. 6(1)/(2), Annex I / III, исключения, роль и применимые обязанности | Все главы |
| Limited risk | Чат-боты, deepfake | Transparency obligations (ст. 50) | [14](../14-model-risk-governance.md), [12](../12-detection-protection-cicd-llm.md) |
| Minimal risk | Спам-фильтры, рекомендательные системы низкого риска | Voluntary codes | Базовые главы |
| GPAI | General-Purpose AI models | Ст. 51-56: документация, training data summary, safety | [04](../04-stage2-model-operations.md), [14](../14-model-risk-governance.md) |

<a id="high-risk-ai-trebovania-chapter-iii"></a>

## High-risk AI: требования Chapter III

<a id="section-2-requirements-for-high-risk-ai-systems"></a>

### Section 2: Requirements for high-risk AI systems

| Статья | Требование | Главы | Артефакты |
|--------|------------|-------|-----------|
| Art. 9 | Risk management system | [14](../14-model-risk-governance.md), [09](../09-threat-modeling.md) | [THREAT-MODEL-TEMPLATE](../templates/THREAT-MODEL-TEMPLATE.md) |
| Art. 10 | Data and data governance | [03](../03-stage1-data-operations.md) | Data lineage, bias testing |
| Art. 11 | Technical documentation | Все главы | Model cards, AI-BOM |
| Art. 12 | Record-keeping (logs) | [15](../15-ai-incident-response.md) | Audit log retention |
| Art. 13 | Transparency and information to deployers | [14](../14-model-risk-governance.md) | Instructions for use |
| Art. 14 | Human oversight | [10](../10-llm-agent-protection.md), [14](../14-model-risk-governance.md) | HITL design |
| Art. 15 | Accuracy, robustness, cybersecurity | [07](../07-red-teaming-testing-methods.md), [12](../12-detection-protection-cicd-llm.md) | Pentest, red team, DLP |

<a id="section-3-obligations-of-providers"></a>

### Section 3: Obligations of providers

| Статья | Требование | Главы | Артефакты |
|--------|------------|-------|-----------|
| Art. 16 | Obligations of providers | [14](../14-model-risk-governance.md) | Provider obligations checklist |
| Art. 17 | Quality management system | [14](../14-model-risk-governance.md) | QMS, ISO 9001 / ISO 42001 alignment |
| Art. 18 | Documentation keeping (10 years) | [15](../15-ai-incident-response.md) | Document retention |
| Art. 19 | Automatically generated logs | [15](../15-ai-incident-response.md) | SIEM, Rilio audit log |
| Art. 20 | Corrective actions and duty of information | [15](../15-ai-incident-response.md) | Incident response |
| Art. 21 | Cooperation with competent authorities | [18](../18-ru-compliance-deep.md) | [regulator-notifications/](../templates/regulator-notifications/) |
| Art. 22 | Authorised representatives | [14](../14-model-risk-governance.md) | Designated rep in EU |
| Art. 23 | Obligations of importers | [04](../04-stage2-model-operations.md) | Import due diligence |
| Art. 24 | Obligations of distributors | [14](../14-model-risk-governance.md) | Distribution agreements |
| Art. 26 | Obligations of deployers | [14](../14-model-risk-governance.md) | Deployer obligations |

<a id="section-5-standards-conformity-assessment-certificates-registration"></a>

## Section 5: Standards, conformity assessment, certificates, registration

| Статья | Требование | Главы | Артефакты |
|--------|------------|-------|-----------|
| Art. 40 | Harmonised standards | [14](../14-model-risk-governance.md) | Проверить публикацию ссылки на конкретный гармонизированный стандарт в Official Journal; сама сертификация ISO 42001 не доказывает соответствие AI Act |
| Art. 41 | Common specifications | [14](../14-model-risk-governance.md) | Commission-specified |
| Art. 43 | Conformity assessment | [14](../14-model-risk-governance.md) | Internal или notified body |
| Art. 47 | EU declaration of conformity | [14](../14-model-risk-governance.md) | DoC template |
| Art. 48 | CE marking | [14](../14-model-risk-governance.md) | Product marking |
| Art. 49 | Registration in EU database | [14](../14-model-risk-governance.md) | EU AI database entry |

<a id="general-purpose-ai-models-st-51-56"></a>

## General-Purpose AI Models (ст. 51-56)

| Статья | Требование | Главы | Артефакты |
|--------|------------|-------|-----------|
| Art. 53 | Obligations for providers of GPAI models | [04](../04-stage2-model-operations.md), [14](../14-model-risk-governance.md) | Model cards |
| Art. 53(1)(a) | Technical documentation | [04](../04-stage2-model-operations.md) | [AI-BOM-EXAMPLE](../templates/AI-BOM-EXAMPLE.json) |
| Art. 53(1)(b) | Documentation for downstream providers | [04](../04-stage2-model-operations.md) | Integration guide |
| Art. 53(1)(c) | Copyright compliance policy | [12](../12-detection-protection-cicd-llm.md) | Copyright policy, права / reservations и процесс соблюдения; scanner не заменяет правовое решение |
| Art. 53(1)(d) | Training data summary | [03](../03-stage1-data-operations.md) | Training data summary |
| Art. 55 | Systemic-risk GPAI obligations; презумпция high-impact capabilities по Art. 51(2) при training compute >10^25 FLOPs, возможны и другие основания | [14](../14-model-risk-governance.md) | Systemic risk assessment |
| Art. 55(1)(a) | Model evaluation | [07](../07-red-teaming-testing-methods.md) | Garak, PyRIT, adversarial |
| Art. 55(1)(b) | Systemic risk assessment and mitigation | [09](../09-threat-modeling.md) | Risk register |
| Art. 55(1)(c) | Serious incident tracking and reporting | [15](../15-ai-incident-response.md) | Incident playbook |
| Art. 55(1)(d) | Cybersecurity protection | [05](../05-stage3-model-deployment.md), [12](../12-detection-protection-cicd-llm.md) | Full MLSec stack |

<a id="obrabotka-spezial_nyh-kategorij-dla-proverki-bias-art-4a"></a>

## Обработка специальных категорий для проверки bias: Art. 4a

Новая [Art. 4a, введённая Art. 1(6) Regulation 2026/1744](https://eur-lex.europa.eu/legal-content/EN/ALL/?uri=oj%3AL_202601744), предусматривает исключительную обработку для выявления и исправления bias. Пункт 1 касается providers high-risk систем; пункт 2 — также providers/deployers других AI-систем и моделей и deployers high-risk систем, при его условиях. Пункт 2 не создаёт обязанности проводить такую обработку.

Legal и data owner документируют строгую необходимость и невозможность эффективно достичь цели другими данными, включая synthetic / anonymised; технические ограничения reuse, защиту и контроль доступа; отсутствие передачи / доступа других сторон; удаление после исправления bias либо окончания retention, смотря что наступит раньше; мотивировку в records of processing. Все условия пункта 1 применяются совокупно, наряду с применимым data protection law. Эта норма не разрешает произвольный training, не отменяет GDPR и не должна приписываться исходной редакции февраля 2025.

<a id="transparency-obligations-art-50"></a>

## Transparency obligations (Art. 50)

| Обязательство | Главы | Меры |
|---------------|-------|------|
| Inform natural persons of AI interaction | [14](../14-model-risk-governance.md) | UI disclosure |
| Mark synthetic content, Art. 50(2) | [29](../29-watermarking-attribution.md) | Machine-readable / detectable marking с условиями и исключениями; C2PA 2.5 — возможный механизм, не автоматический compliance |
| Deepfake disclosure, Art. 50(4) | [29](../29-watermarking-attribution.md) | Проверить применимый human-facing disclosure; metadata сама по себе не заменяет уведомление |
| Emotion / biometric categorisation disclosure, Art. 50(3) | [14](../14-model-risk-governance.md) | Уведомление exposed persons, отдельная проверка законности / запретов / data protection; disclosure не равно consent |

<a id="governance-chapter-vii"></a>

## Governance (Chapter VII)

| Структура | Статья | Применение |
|-----------|--------|------------|
| AI Office | Art. 64 | Центральный надзор GPAI |
| AI Board | Art. 65 | Координация государств-членов |
| National competent authorities | Art. 70 | Надзор в странах |
| European Data Protection Supervisor | Art. 74 | Для EU институтов |

<a id="penalties-chapter-xii"></a>

## Penalties (Chapter XII)

| Статья | Нарушение | Штраф |
|--------|-----------|-------|
| Art. 99(3) | Prohibited AI practices | До €35M или 7% global turnover |
| Art. 99(4) | Нарушение обязательств для high-risk AI | До €15M или 3% |
| Art. 99(5) | Supply of incorrect information | До €7.5M или 1% |
| Art. 101 | Penalties on GPAI providers | До €15M или 3% |

<a id="timeline-primenenia"></a>

## Timeline применения

Проверено 13.11.2026: юридическая основа — [Regulation 2026/1744, Art. 1(39)–(40)](https://eur-lex.europa.eu/legal-content/EN/ALL/?uri=oj%3AL_202601744), изменяющий Art. 111 и 113 AI Act. Сроки зависят от роли, категории и переходных положений. Перенос по новой Art. 113(c) охватывает **Chapter III Sections 1–3, кроме Art. 6(5)**; нельзя переносить эту дату автоматически на все high-risk положения, регистрацию или иной режим.

| Срок | Что применяется / переходное условие |
|------|---------------------|
| 2025-02-02 | Первоначальные запреты Art. 5 и AI Literacy; новый запрет Omnibus имеет отдельную дату |
| 2025-08-02 | Chapter V: обязанности GPAI providers, а не любого пользователя модели; governance и другие перечисленные в Art. 113(b) положения |
| 2026-08-02 | Общая дата применения, включая Art. 50 и enforcement по GPAI; исключения проверяются по конкретной статье |
| 2026-12-02 | Providers соответствующих синтетических AI-систем, размещённых до 02.08.2026: исполнение Art. 50(2) по новой Art. 111(4), не перенос всей Art. 50 |
| 2026-12-02 | Новые Art. 5(1)(ba)/(bb), 1a/1b: non-consensual intimate / sexually explicit material и CSAM с установленными условиями и исключениями |
| 2027-12-02 | Chapter III Sections 1–3, кроме Art. 6(5), для high-risk по Art. 6(2), Annex III |
| 2027-08-02 | Переходный срок для GPAI-моделей, размещённых до 02.08.2025 |
| 2028-08-02 | Те же разделы для high-risk по Art. 6(1), Annex I; учитывать сектор, Art. 2(2) и переходные положения |

Для новых запретов Art. 5 различаются intended purpose системы, предсказуемый и воспроизводимый результат без адекватных safeguards при её размещении и цель использования deployer. Наличие generative capability само по себе не заменяет условий Art. 5(1a)–(1b). Владелец допуска фиксирует сценарий, роль, safeguards и основания решения; на 13.11.2026 дата 02.12.2026 ещё предстоящая.

<a id="gap-analiz-dla-rossijskoj-organizazii-s-eksportom-v-es"></a>

## Gap-анализ для российской организации с экспортом в ЕС

Ключевые зоны, требующие отдельного внимания при продаже в ЕС:

1. **Representative в ЕС** — определить обязанность по роли: Art. 22 для соответствующего high-risk provider; для GPAI отдельный Art. 54, с применимыми условиями / исключениями.
2. **CE / conformity assessment** — только для применимого режима, не универсальная обязанность любого AI API / GPAI model.
3. **GPAI** — базовые обязанности provider по Art. 53, включая применимые documentation / copyright policy / public training summary, проверяются отдельно от дополнительных systemic-risk обязанностей Art. 55 и предусмотренных исключений.
4. **EU database registration** - регистрация high-risk систем.
5. **Human oversight design** - документированный HITL процесс.
6. **Incident reporting** — [Art. 73](https://eur-lex.europa.eu/eli/reg/2024/1689/2026-07-27/eng) для high-risk providers: report без промедления по условиям causal link; предел зависит от события (обычно до 15 дней, специальные случаи до 2 / до 10 дней), не «15 дней ожидания». Для providers систем под компетенцией AI Office новая [Art. 75(1a), Art. 1(31)(c) Regulation 2026/1744](https://eur-lex.europa.eu/legal-content/EN/ALL/?uri=oj%3AL_202601744) устанавливает специального адресата — AI Office, с применением Art. 73(2)–(9) соответственно. GPAI systemic-risk и иные режимы проверяются отдельно.

<a id="proverka-primenimosti-i-evidence-dva-raznyh-produkta"></a>

## Проверка применимости и evidence: два разных продукта

| Ситуация | Нормативный вопрос | Наша предлагаемая проверка | Evidence и открытый аспект |
|---|---|---|---|
| Чат-помощник пишет черновик письма | Роль по Art. 2, transparency по Art. 50, intended use; high-risk не выводится из самого слова LLM | Проверить уведомление пользователя, marking для соответствующих outputs и исключения; запретить незаявленные consequential actions | UI/format/cross-export tests на одной revision. Нет вывода о classification без intended-purpose assessment |
| Система ранжирует кандидатов для работодателя | Сопоставление с Art. 6 / Annex III и ролью provider/deployer; проверить дополнительные обязанности, включая применимость Art. 27 | Решение классификации, data governance/evaluation, oversight, техническая документация и post-market plan | Dataset/model/policy digests, subgroup evaluation, override/appeal records, release decision; перечень глав не заменяет полный technical file |

**Замыкание Art. 50:** сопоставить тип output и обязанного actor с конкретным пунктом; проверить clean output, экспорт/перекодирование, потерянный manifest и неизвестного signer. Human-readable disclosure и machine-readable marking проверяются отдельно. В C2PA 2.5 валидация integrity / trust не доказывает истинность содержания, достаточность disclosure или право использования; см. [29](../29-watermarking-attribution.md) и [официальную спецификацию](https://spec.c2pa.org/specifications/specifications/2.5/specs/C2PA_Specification.html).

**Замыкание Art. 73:** tabletop задаёт role/system/event, awareness time, признаки causal link, компетентного адресата и применимый крайний срок. Проверяется подготовка своевременного initial report даже при неполном расследовании, последующее дополнение и receipt. Неполная информация не используется как разрешение ждать полного RCA. Этот процесс не заменяет GDPR / РФ уведомления, которые имеют собственные условия.

**Не закрыто этой матрицей:** полный перечень обязанностей всех actors, отраслевое product law, все исключения / transitional cases, применимость конкретного harmonised standard и решение competent authority. Неизвестный пункт заносится в action register с владельцем и сроком; готовый Model Card / C2PA manifest не превращает его в pass.

<a id="sm-takje"></a>

## См. также

- [EU AI Act (Regulation (EU) 2024/1689) - Official Journal](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=OJ:L_202401689)
- [NIST-AI-RMF.md](NIST-AI-RMF.md)
- [ISO-42001.md](ISO-42001.md)
- Глава [14. Governance](../14-model-risk-governance.md)
- Глава [18. Российская специфика](../18-ru-compliance-deep.md)
