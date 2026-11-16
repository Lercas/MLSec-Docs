<a id="industrial-kii-mlsec-playbook"></a>

# Industrial / КИИ: MLSec playbook

> **Версия**: 1.0 · **Дата**: 2026-04-22
> **Регуляторы**: ФСТЭК, ФСБ, ГосСОПКА (НКЦКИ), отраслевые (Ростехнадзор для ОПО)
> **Нормативный контекст**: 187-ФЗ, применимые требования ФСТЭК к АСУ ТП / значимым объектам КИИ и действующий порядок информирования НКЦКИ. IEC 62443 — международная техническая серия; банковский ГОСТ Р 57580 не является универсальным OT-требованием.

<a id="1-kontekst"></a>

## 1. Контекст

Промышленные AI/ML-системы: predictive maintenance, process optimization, computer vision на линиях, голосовые ассистенты для операторов, digital twins. В OT важны безопасность людей, устойчивость процесса и критичность downtime. Статус КИИ и категория определяются отдельно; ни air-gap, ни отсутствие интернета не являются универсальным свойством всех объектов. Архитектуру выбирают по угрозам, процессу и применимым требованиям.

<a id="2-prioritetnye-use-cases"></a>

## 2. Приоритетные use cases

| Use case | Tier | Риск |
|---|---|---|
| Predictive maintenance (PdM) | 1-2 | Ложный не-сигнал → авария |
| Computer Vision на линии контроля качества | 1-2 | False accept брака → репутация, кара |
| Управление процессом (closed-loop) | 1 | Компромисс модели → физический ущерб |
| Chatbot для операторов | 2 | Дезинформация в критической ситуации |
| Digital twin с ML-симуляцией | 2-3 | Раскрытие секретов производства |
| RAG по техдокументации | 2-3 | Утечка know-how |
| Code-assistant для SCADA-разработки | 3 | Backdoor в control systems |

<a id="3-spezificeskie-ugrozy"></a>

## 3. Специфические угрозы

**Атаки на sensors / adversarial в physical world**:
- Adversarial patch на линзе камеры, стикеры на продуктах, сбивающие CV.
- Электромагнитные помехи на датчики.
- GPS-spoofing для autonomous систем.

**Supply chain предобученных моделей**:
- Pretrained на датасете вендора, содержащем backdoor.
- Fine-tune на демо-данных без проверки.

**Air-gap обход**:
- USB-стики для обновления моделей: носитель malware.
- Через CI/CD-сервер (если был bridge для обновлений).
- Через service-laptop сотрудника вендора.

**Манипуляция через HMI**:
- Оператор атакуется социальной инженерией через LLM-chat bot, встроенный в HMI.
- LLM по ошибке даёт неверную инструкцию в критической ситуации.

<a id="4-regulatornye-tocki"></a>

## 4. Регуляторные точки

<a id="187-fz-prikaz-fstek-239-znacimye-kii"></a>

### 187-ФЗ + Приказ ФСТЭК 239 (значимые КИИ)

Категория определяется по действующим правилам категорирования и применимым показателям, а не упрощённой таблицей людей / рублей. Субъект, состав объекта и решение о категории документируются отдельно — см. [главу 18](../18-ru-compliance-deep.md). Внутренний AI Tier не равен категории значимости КИИ.

**Требования**:
- Адекватные СЗИ, соответствующие категории.
- Subject to проверки ФСТЭК.
- Обязательное уведомление НКЦКИ.
- Сертифицированные продукты.

**MLSec**:
- Порядок безопасного отключения AI согласован с технологом и safety owner. Остановка модели не подменяет аварийный останов оборудования и не должна сама нарушать безопасное состояние процесса.
- Контроль целостности артефакта перед запуском: digest из доверенного release manifest. Защита от изменений после проверки требует отдельно проверенных read-only storage / loader и runtime-контролей; совпадение hash не доказывает safety поведения модели.
- Резервная heuristic / rule-based система, на которую можно переключиться.

<a id="prikaz-fstek-31-asu-tp"></a>

### Приказ ФСТЭК 31 (АСУ ТП)

Требования для АСУ ТП:
- Разделение функциональных зон (офисная сеть ≠ технологическая сеть).
- Отдельные средства защиты для каждой зоны.
- Защита целостности программно-технического комплекса.

**Integration**: AI-компонент классифицируется по своей роли в зоне. ML-pipeline для обучения часто в офисной сети, inference в технологической. Граница: защищённая шлюз с контролем подписи.

<a id="iec-62443-mejdunarodnyj-standart"></a>

### IEC 62443 (международный стандарт)

Уровни безопасности (Security Levels 1-4). Международная серия может использоваться как техническая / договорная основа; она не объявляется здесь универсальной обязательной нормой РФ и не заменяет функциональную безопасность оборудования.

Ключевые разделы:
- IEC 62443-3-3 (System Security): SR 3.4 Software and information integrity.
- IEC 62443-4-1 (Development): SDL для indust. products.
- IEC 62443-4-2 (Components): требования к компонентам.

**MLSec-импликация**: SDL для ML-pipeline должен включать code signing, secure update, backdoor scan.

<a id="opo-opasnye-proizvodstvennye-ob_ekty"></a>

### ОПО (опасные производственные объекты)

Объекты, подлежащие контролю Ростехнадзора (нефтегаз, химия, горная добыча). Внедрение AI:
- Обоснование безопасности в проекте ОПО.
- Обязательная экспертиза промышленной безопасности.
- При авариях: расследование с учётом участия AI.

<a id="5-minimal_nyj-nabor-kontrolej"></a>

## 5. Минимальный набор контролей

<a id="arhitektura"></a>

### Архитектура
- [ ] Физическая сегментация (офис / технологическая / DMZ).
- [ ] Связность / сегментация определены моделью угроз; пути updates, vendor laptops и telemetry проверены даже при заявленном air-gap.
- [ ] Однонаправленные шлюзы (data diode) для данных из техзоны в офис.
- [ ] Резервная rule-based система с ручным переключением.

<a id="modeli"></a>

### Модели
- [ ] Целостность и происхождение моделей проверяются по утверждённому trust policy; криптографические требования определены для конкретного контура.
- [ ] Backdoor-scan обязательно (см. [главу 30](../30-interpretability-for-security.md)).
- [ ] Adversarial testing на physical perturbations.
- [ ] Retraining и изменения допускаются по change-control и повторной оценке риска; квартальная частота не является универсальным ограничением.

<a id="deployment"></a>

### Deployment
- [ ] Проверка сначала на simulator / hardware-in-the-loop стенде; испытание на линии — отдельный технологический допуск, а не обычный web-canary.
- [ ] Hash check модели при каждом запуске.
- [ ] Integrity monitoring runtime.
- [ ] Безопасный переход при отключении / timeout AI проверен независимо от модели; authority технологического / safety контура сохранена.

<a id="access"></a>

### Access
- [ ] Роли и квалификация сотрудников определены процессом допуска к конкретному оборудованию; универсального уровня «KIM» этот playbook не устанавливает.
- [ ] MFA + аппаратные токены.
- [ ] Физический доступ к control-room контролируемый.
- [ ] Vendor-acess only через jumphost + recorded.

<a id="monitoring"></a>

### Monitoring
- [ ] SIEM с OT-detection (KICS, Nozomi, Claroty для зарубежных, ПТ ISIM, Kaspersky ICS для отечественных).
- [ ] Интеграция с ГосСОПКА.
- [ ] Anomaly detection на sensor data.
- [ ] CV-system self-monitoring (sanity-check frames).

<a id="supply-chain"></a>

### Supply chain
- [ ] Vendor audits вендоров AI-решений.
- [ ] Signed firmware + модели.
- [ ] SBOM + ML-BOM (см. [opa/supply-chain.rego](../opa/supply-chain.rego)).
- [ ] Update Process: signed, staged, reversible.

<a id="ir"></a>

### IR
- [ ] Playbook с участием оператора + OT-инженера + ИБ.
- [ ] НКЦКИ: применимость / срок / точка отсчёта по действующему порядку и статусу объекта, см. главу 18.
- [ ] Rollback + downtime planning.
- [ ] Physical safety review post-incident.

<a id="6-kpi-dla-ot-ciso"></a>

## 6. KPI для OT CISO

| Метрика | Целевое значение |
|---|---|
| % AI в техзоне с проверенным безопасным переходом при отказе | 100% в установленном scope |
| Backdoor scan before deploy | 100% |
| Adversarial robustness на physical perturbations | ≥ 0.80 |
| RTO восстановления при отказе AI на линии | ≤ 5 минут |
| MTTA on OT SIEM alert | ≤ 15 минут |
| % обучающих данных с provenance | 100% |
| Vendor supply chain audit | раз в год |

<a id="pilot-predictive-maintenance-bez-upravlenia-prozessom"></a>

### Пилот: predictive maintenance без управления процессом

**Допуск**: синтетические sensor traces и simulator оборудования. Модель выдаёт advisory о проверке узла, но не меняет setpoint, не снимает interlock и не командует остановом / запуском. OT owner отвечает за границу управления, инженер надёжности — за качество предупреждений, safety owner — за допустимую деградацию. Тест не проводится на работающем оборудовании.

| Fault / negative fixture | Приёмка | Evidence / owner |
|---|---|---|
| Stale / пропущенный sensor sample, неверные единицы | Явная недостоверность входа, нет уверенного «узел исправен» | Reliability engineer: timestamp / unit checks и expected outcome |
| Модель / GPU / сеть недоступны | Процесс simulator остаётся в предусмотренном состоянии, локальные защиты независимы | OT + safety owner: журнал переходов и trace simulator |
| Изменённый update bundle с совпадающим именем | Не проходит проверку доверенного producer / digest; старая допущенная версия доступна | Platform owner: manifest, отказ promotion, offline restore test |
| Advisory содержит инструкцию изменить PLC | Команда физически / логически недоступна AI, а не только запрещена prompt | OT owner: deny-test test interface и network evidence |

Security-приёмка не измеряется одной accuracy. В пилоте отдельно считают пропуски известных отказов, ложные выезды и время review инженером на фиксированном наборе. Снижение simulated downtime — отдельная гипотеза, не обещанный эффект на производстве; переход к closed-loop требует нового safety case, технического допуска и проверки процесса управления изменениями.

Техническая основа, проверено **13.11.2026**: [NIST SP 800-82 Rev. 3 — OT Security](https://csrc.nist.gov/pubs/sp/800/82/r3/final), учитывающий performance, reliability и safety OT. На странице указан initial public draft Rev. 4; draft не выдаётся за действующую финальную редакцию. Это рекомендация, а не норма РФ или сертификация AI-системы; юридическая применимость — [глава 18](../18-ru-compliance-deep.md).

<a id="7-svazi"></a>

## 7. Связи

- [Глава 18](../18-ru-compliance-deep.md) 187-ФЗ, Приказ 239.
- [Глава 19](../19-training-infrastructure.md) защита training infra (применимо для on-prem).
- [Глава 26](../26-multimodal-cv-security.md) физические adversarial.
- [opa/supply-chain.rego](../opa/supply-chain.rego) supply chain.
- [siem/](../siem/) OT-alert-ы можно расширять из этих templates.
- [playbooks/IR-04-agentic-breach.md](../playbooks/IR-04-agentic-breach.md) если AI управляет действиями.
