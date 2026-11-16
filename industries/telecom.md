<a id="telecom-mlsec-playbook"></a>

# Telecom: MLSec playbook

> **Версия**: 1.1 · **Дата**: 2026-05-29
> **Регуляторы**: Минцифры, РКН, ФСБ (СОРМ), ЦБ РФ (для эмитентов собственных финсервисов)
> **Нормативный контекст**: 126-ФЗ (О связи), 187-ФЗ (КИИ), 149-ФЗ, 152-ФЗ и применимые акты хранения / оперативно-разыскных мероприятий. Номер «83» без даты и названия не идентифицирует действующий акт о СОРМ; точный состав требований фиксируется в юридической матрице оператора.

<a id="1-kontekst"></a>

## 1. Контекст

Телеком-операторы обрабатывают huge volumes: звонки, SMS, трафик, геолокация. AI используется для fraud detection (SIM-swap, revenue-sharing fraud), customer care (чат-боты, IVR), network optimization, marketing. Регуляторика: СОРМ, «закон Яровой» (retention), категория значимых КИИ.

<a id="2-prioritetnye-use-cases"></a>

## 2. Приоритетные use cases

| Use case | Tier | Риск |
|---|---|---|
| Fraud detection (telecom-fraud) | 1 | Миллионы операций, утечки |
| IVR / чат-бот для абонентов | 2 | PII, SIM-swap путём соц. инженерии |
| Net optimization / RAN AI | 2 | Downtime, QoE |
| Customer churn prediction | 2 | Bias, marketing бюджет |
| CDR anomaly detection | 1 | KYC, Росфинмониторинг |
| Voice bio в call-center | 1 | Deepfake, несанкционированные изменения |
| Content recommendation (IPTV) | 2 | Filter bubble, 38-ФЗ |
| RAG по internal procedures для сотрудников | 2-3 | Утечка операционных деталей |

<a id="3-spezificeskie-ugrozy"></a>

## 3. Специфические угрозы

**SIM-swap через AI-чат**: LLM-bot реализует упрощённый self-service, атакующий убеждает бота поменять SIM. Митигация: hard rule «никогда не меняй SIM без multi-channel confirmation», воздержание от действий, high-risk decisions → только human operator.

**Voice cloning для call-center**: deepfake абонента, чтобы получить доступ к личному кабинету. Митигация: ASVspoof + voice liveness + PIN + device fingerprint.

**Атака на fraud model**: мошенники генерируют патерны, обходящие детектор. Митигация: ensemble + unsupervised streaming anomaly + active learning.

**Геолокация inversion из embeddings**: user-embedding содержит location patterns. Митигация: DP + retention limits.

**Supply chain RAN-AI**: AI-модели от vendor (Nokia, Ericsson, HiSilicon, отечественные) могут содержать backdoor. Митигация: тщательный audit, cosign-подписи, isolation.

<a id="4-regulatornye-tocki"></a>

## 4. Регуляторные точки

<a id="126-fz-o-svazi"></a>

### 126-ФЗ (О связи)

- Запрет разглашения связи.
- Обязательная аутентификация абонента (с 2024 ужесточено).
- Способ идентификации / аутентификации определяется категорией абонента и операцией; универсальная обязательность ЕСИА / ЕБС для каждого AI-разговора не устанавливается.

**MLSec**: automated-процессы идентификации должны ≥ ручной.

<a id="374-fz-arovaa"></a>

### 374-ФЗ (Яровая)

Состав, сроки и режим доступа к хранимым сведениям определяются видом услуги / данных и действующими актами. Не следует сводить все сведения о связи к одному сроку «до шести месяцев» или считать доступ ФСТЭК к содержимому автоматическим.

**AI-аспект**: цель и основание доступа fraud pipeline определяются отдельно; обязательное хранение оператором не разрешает использовать все raw данные для обучения / marketing. Derived features также могут идентифицировать абонента и требуют собственного режима доступа / retention.

<a id="sorm-3"></a>

### СОРМ-3

Технические средства для доступа уполномоченных органов. Требования:
- Полная прозрачность по запросу.
- Не нарушать функционирование.
- Сертификация ФСБ.

**AI-impact**:
- AI-интеграция не изменяет обязательные функции оператора; любое влияние на регулируемый контур требует отдельной оценки уполномоченными владельцами.
- Сегментация и разрешённые потоки между регулируемыми хранилищами и AI-pipeline определяются проектом защиты, а не универсальным требованием «без bidirectional». СОРМ не становится источником произвольного retrieval.

<a id="187-fz-kii"></a>

### 187-ФЗ (КИИ)

Принадлежность организации к связи не назначает категорию каждой ИС. Определяются субъект / объект КИИ, категорирование и применимость требований к значимому объекту; customer-support chatbot не наследует категорию автоматически.

<a id="uridiceskaa-matriza-sorm"></a>

### Юридическая матрица СОРМ

Legal / regulatory owner фиксирует точные акты, редакции, услуги и системы, к которым они относятся. Этот playbook не квалифицирует номер приказа без даты и названия как универсальную норму СОРМ-3.

<a id="5-minimal_nyj-nabor-kontrolej"></a>

## 5. Минимальный набор контролей

<a id="data"></a>

### Data
- [ ] Разделение зон: СОРМ (закрытая), AI-pipeline (рабочая).
- [ ] Trusted pipelines CDR → feature store.
- [ ] Retention строгое по 374-ФЗ.
- [ ] Anonymization для analytics.

<a id="models"></a>

### Models
- [ ] Fraud detection: independent validation + shadow.
- [ ] Voice bio: replay / synthetic speech тесты на релевантном канале; ASVspoof — benchmark, не сертификация оператора.
- [ ] Customer-facing chatbot: hard-rules на sensitive actions.
- [ ] Net-AI: от vendor с supply-chain audit.

<a id="identity-auth"></a>

### Identity / Auth
- [ ] Способ идентификации / аутентификации и необходимость ЕСИА / ЕБС подтверждены по конкретной операции.
- [ ] Multi-factor для каждого sensitive операции.
- [ ] Voice-only не достаточно для SIM-swap / MNP.
- [ ] Audit trail каждого изменения.

<a id="access"></a>

### Access
- [ ] SSO + MFA для сотрудников.
- [ ] Отдельные контуры для СОРМ-доступа (только уполномоченные).
- [ ] Vault для секретов.

<a id="monitoring"></a>

### Monitoring
- [ ] SIEM с CDR enrichment.
- [ ] SOC 24/7.
- [ ] Anomaly detection на fraud model scores.
- [ ] Integration с ГосСОПКА для значимых объектов КИИ.

<a id="chatbot-voice"></a>

### Chatbot / Voice
- [ ] Voice anti-spoofing in IVR.
- [ ] LLM-bot с жёсткими guardrails для sensitive actions.
- [ ] Post-DLP + Anti-EchoLeak.
- [ ] Multi-channel confirmation для SIM-swap, SIM-porting, password reset.

<a id="ir"></a>

### IR
- [ ] Playbooks IR-02/03/04/05 активны.
- [ ] Уведомление НКЦКИ по применимым основаниям / срокам и статусу объекта; матрица — в главе 18.
- [ ] РКН: первичное уведомление в 24 часа, детальное в 72 часа (152-ФЗ ст. 21 ч. 3.1).
- [ ] Взаимодействие с правоохранителями по мошенническим инцидентам.

<a id="6-kpi-dla-ciso-telecom"></a>

## 6. KPI для CISO (telecom)

| Метрика | Целевое значение |
|---|---|
| Fraud detection F1-score (prod) | > 0.92 |
| Voice anti-spoofing EER | < 1% |
| SIM-swap fraud rate (после защиты) | снижение N% г/г |
| RTO kill-switch на AI | < 30 сек |
| MTTA для fraud anomaly | < 5 минут |
| Закрытие требований применимого СОРМ-scope | Подтверждённые evidence по каждому требованию, не агрегированный AI score |
| % рабочих контуров с mTLS | 100% |

<a id="pilot-podskazka-operatoru-pri-podozrenii-na-sim-swap"></a>

### Пилот: подсказка оператору при подозрении на SIM-swap

**Допуск**: синтетические subscriber records, журнал SIM-change и test CRM. AI предлагает маршрут проверки, но не меняет SIM / eSIM, не переносит номер, не сбрасывает пароль и не выдаёт location / CDR. Fraud owner задаёт критерии риска, identity owner — допустимое подтверждение, CRM owner — реальный enforcement границы.

| Negative case | Приёмка | Owner / evidence |
|---|---|---|
| Правдоподобный голос и просьба «срочно перевыпустить SIM» | Голос / текст не заменяет установленную проверку; mutation недоступна ассистенту | Identity owner: test CRM readback и deny-test |
| Недавняя SIM-change / неизвестный статус API | Risk signal учитывается; `unknown` не превращается в «смены не было» или идентификацию человека | Fraud owner: raw fixture status и маршрут review |
| Подмена номера абонента в tool args | Tenant / subject binding проверяется до чтения; чужие CDR не раскрыты | IAM / CRM owner: аргументы, policy decision, audit |
| Таймаут test provision job | Сверка job у test provider, без повторного выпуска профиля | Integration owner: action ID, status / `unknown`, отсутствие дубля |

SMS / звонок на уже захваченный номер не являются независимым подтверждением владения. SIM-change signal — контекст риска, а не доказательство личности или мошенничества. В пилоте отдельно измеряют detection / false positives, задержку законного восстановления и повторные обращения; лучший F1 при блокировке добросовестных абонентов не означает бизнес-пользу.

Отраслевая техническая основа, проверено **13.11.2026**: [GSMA — Mobile Identity and Data APIs](https://www.gsma.com/solutions-and-impact/technologies/mobile-identity/mobile-identity-and-data-apis/) и [CAMARA — спецификация SIM Swap API](https://github.com/camaraproject/SimSwap/blob/main/code/API_definitions/sim-swap.yaml). Это описание сигналов / APIs, не требование российского закона и не утверждение, что конкретный оператор предоставляет API с заданным SLA; интеграция фиксирует конкретную release API и поведение ошибок.

<a id="7-svazi"></a>

## 7. Связи

- [Глава 18](../18-ru-compliance-deep.md) 126-ФЗ, 374-ФЗ, СОРМ.
- [Глава 22](../22-finops-ai.md) бюджеты AI в telco.
- [Глава 27](../27-voice-ai-security.md) voice в call-center.
- [opa/llm-gateway.rego](../opa/llm-gateway.rego)
- [siem/README.md](../siem/README.md) SIEM rules.
- [playbooks/](../playbooks/) IR runbook-и.
