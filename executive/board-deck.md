<a id="board-deck-mlsec-program"></a>

# Board Deck: MLSec Program

> Актуализировано 13.11.2026: применимость, пилот, evidence и экономика. Числа бюджета — учебный сценарий, не предложение цены / данные компании. PPTX/XLSX не обновлялись и не подтверждают эту редакцию Markdown.


> **Версия**: 1.1 · **Дата**: 2026-05-29 · **Формат**: 16 слайдов · **Длительность**: 20-25 минут

Исходник для презентации совету директоров. PPTX из прежней редакции не обновлялся; его слайды не считаются синхронизированными с этим текстом.

<a id="slajd-1-titul"></a>

## Слайд 1: Титул

**MLSec Program**
Безопасность AI/ML систем компании

Редакционный review / 13 ноября 2026

Докладчик: CISO
Соавторы: CIO, ML Lead, Юрист

<a id="slajd-2-povestka"></a>

## Слайд 2: Повестка

1. Почему MLSec, почему сейчас.
2. Ландшафт угроз: 5 категорий.
3. Наша позиция: baseline и gap.
4. Roadmap на 12 месяцев.
5. Бюджет и ROI.
6. Решения, которые нужны от совета.

<a id="slajd-3-landsaft-ai-v-kompanii-uje-est_"></a>

## Слайд 3: Ландшафт: AI в компании уже есть

Числа по компании (заполнить в ходе инвентаря):
- Активных AI/ML use cases в prod: `N`
- В разработке: `M`
- Shadow AI (инструменты, используемые сотрудниками вне контроля ИБ): `K`
- API-ключей внешних LLM-провайдеров в корпоративных системах: `X`
- Объём PII, проходящий через AI pipeline в квартал: `Y GB`

Отраслевые проценты без первичного источника, периода и denominator не используются. Вместо них: scope собственного inventory, источники наблюдения, охват устройств / маршрутов и неизвестное. Нулевые alerts при отсутствии telemetry не являются baseline безопасности.

<a id="slajd-4-dopolnitel_nye-granizy-mlai"></a>

## Слайд 4: Дополнительные границы ML/AI

| Параметр | Классический ИБ | MLSec |
|---|---|---|
| Что атакуют | Код, сеть, доступы | Модель, данные, промпты |
| Где | Инфраструктура | Pipeline от обучения до inference |
| Контроли | WAF, DLP на файлы | Prompt firewall, model signing, OPA gate |
| Детект | Logs, SIEM | AI-сигналы: drift, hallucination, jailbreak |
| Регуляторика | 152-ФЗ, PCI | + 187-ФЗ, EU AI Act, ЦБ 716-П (система управления операционным риском; применимость проверяется отдельно), 572-ФЗ |

Вывод: MLSec дополняет существующую ИБ контролем данных, model bundle, agent authority и проверяемым stop; повторно покупать каждый слой не требуется.

<a id="slajd-5-pat_-kategorij-riska"></a>

## Слайд 5: Пять категорий риска

1. **Утечка данных через LLM**. Неразрешённая передача внутреннего документа внешнему AI-сервису; training/retention зависят от продукта и условий.
2. **Prompt injection и jailbreak**. Скрытая инструкция в input или во внешнем документе, LLM её исполняет.
3. **Supply chain моделей**. Pretrained модель с backdoor, подмена в CI/CD, неподписанный artifact.
4. **Agent breach**. Autonomous AI-агент выполняет опасное действие (удаление БД, prod-коммит, транзакция).
5. **Compliance gap**. Проверить применимость GDPR Art. 22 / 152-ФЗ ст. 16 по последствиям и исключительно автоматизированному решению; explanation не закрывает всё требование.

Сценарии для tabletop: передача документа, deepfake payment, agent action без полномочий. Это тестовые сценарии, не статистика частоты или ожидаемого ущерба.

<a id="slajd-6-rossijskaa-regulatorika-sroki"></a>

## Слайд 6: Российская регуляторика: сроки

- **Россия:** определить обработку / организацию / объект. 152-ФЗ ст. 21 ч. 3.1 предусматривает 24/72 часа при соответствующем событии; 716-П касается операционного риска применимых субъектов, 239 — значимых объектов КИИ. Это разные акты и даты, не единый дедлайн 01.09.2022; [глава 18](../18-ru-compliance-deep.md).
- **02.08.2025 (в силе)**: EU AI Act — обязательства для GPAI (моделей общего назначения).
- **02.08.2026**: EU AI Act — transparency Art. 50 и enforcement-полномочия Еврокомиссии по GPAI.
- **02.12.2027**: high-risk Annex III после Digital Omnibus, вступившего в силу 27.07.2026.
- **02.08.2027**: переходный срок для GPAI-моделей, размещённых до 02.08.2025.
- **02.08.2028**: high-risk, встроенные в регулируемые продукты (Annex I).
- **Маркировка в РФ:** подтвердить опубликованный акт, редакцию и дату по конкретному контенту; неподтверждённая дата законопроекта не считается законом.

Вывод: даты связываются с ролью и use case; календарь не является прогнозом штрафов или упущенной прибыли.

<a id="slajd-7-nasa-pozizia-segodna"></a>

## Слайд 7: Наша позиция сегодня

Шаблон baseline; все значения заполняются по evidence, это не проведённый аудит:

| Домен | Балл | Gap |
|---|---|---|
| Governance & Policy | не оценено | политики, роли и независимый review |
| Data Security | не оценено | permitted use, classification, provenance / отзыв |
| Model Security | не оценено | bundle provenance, evaluation и допуск |
| Runtime Security | не оценено | identity / ACL / tool authority и отказные пути |
| Detect & Respond | не оценено | доставка telemetry, stop / recovery / IR drills |
| Compliance | не оценено | реестр применимости, незакрытые пункты и owners |

Отчёт показывает проверенный scope, target revisions, test outcomes и gaps. Средний maturity score не равен вероятности инцидента / проценту соответствия.

<a id="slajd-8-arhitektura-zelevogo-sostoania"></a>

## Слайд 8: Архитектура «целевого состояния»

Стек MLSec:
1. **Data layer**: классификация K0-K4, permitted use / provenance, Data Card и отзыв.
2. **Model layer**: MRM, cosign, SBOM/ML-BOM, backdoor-scan, red team.
3. **Runtime**: LLM gateway, DLP (6 слоёв), prompt firewall, kill-switch L0-L4.
4. **Policy**: OPA/Rego deployment и runtime gate.
5. **Observability**: SIEM rules, OpenTelemetry GenAI, dashboards.
6. **IR**: 5 playbook-ов, quarterly tabletop.

Диаграмма архитектуры см. [DIAGRAMS.md](../DIAGRAMS.md).

<a id="slajd-9-roadmap-q1"></a>

## Слайд 9: Roadmap Q1

Фокус: видимость.

- Реестр моделей (MRM) + классификация.
- Data classification шаблоны и Data Card.
- LLM gateway (единая точка).
- Базовые SIEM rules.
- Kill-switch L0-L4 + drill.

Выход: известный scope и blind spots; измеренный stop с проверкой очередей / retries / внешних effects.

Бюджет Q1: 18-22 млн руб.

<a id="slajd-10-roadmap-q2"></a>

## Слайд 10: Roadmap Q2

Фокус: стандартизация и supply chain.

- OPA policy для deployment и runtime.
- Cosign подписи + Sigstore Model Transparency.
- SBOM и ML-BOM в CI.
- Adversarial + bias suite автоматически (ART, Fairlearn).
- Prompt registry + PromptOps.

Выход: проверен допуск выбранного scope; обходы через admin/batch/fallback и emergency paths тестируются отдельно.

Бюджет Q2: 18-23 млн руб.

<a id="slajd-11-roadmap-q3"></a>

## Слайд 11: Roadmap Q3

Фокус: hardening и zero-trust.

- Vector DB security (RLS, encrypted payload).
- mTLS для всех ML-сервисов.
- Vault для секретов, BYOK для tenant.
- PET по threat model и разрешённой обработке; DP — только с заданным механизмом / accounting.
- Voice и multimodal защита.

Выход: проверенные негативные сценарии supply chain / lateral access и документированные gaps.

Бюджет Q3: 16-21 млн руб.

<a id="slajd-12-roadmap-q4"></a>

## Слайд 12: Roadmap Q4

Фокус: continuous и compliance.

- Регулярный red team в изолированной среде; production-проверки только в согласованном scope.
- Tabletop exercises раз в квартал.
- Маркировка / C2PA 2.5 там, где применимо; проверить disclosure и экспорт, не обещать истинность контента.
- Compliance audits (ФСТЭК, ЦБ, DPIA).
- Maturity assessment: подтвердить baseline и изменение конкретных контролей.

Выход: evidence для применимого audit scope; открытые требования имеют владельца.

Бюджет Q4: 18-23 млн руб.

<a id="slajd-13-investizii"></a>

## Слайд 13: Инвестиции

Итого 12 месяцев: **70-89 млн руб**.

| Категория | Учебный бюджет, млн руб / 12 мес |
|---|---|
| Инструменты | 25–44 |
| Команда (условные 2 FTE) | 20 |
| Audit / certification | 12 |
| Red team / pentest | 8 |
| Обучение | 5 |
| **До резерва** | **70–89** |

При условных 10% резерва: 77–97,9 млн руб. Это авторский сценарий, не рыночная цена или расчёт от выручки. Для пилота согласовать отдельный меньший scope и cap; учесть интеграцию, runtime и ручной review без двойного учёта FTE.

<a id="slajd-14-vozvrat-investizij-i-pilot"></a>

## Слайд 14: Возврат инвестиций и пилот

- **Контрфактический baseline:** текущий процесс с существующими контролями, либо жизнеспособный ручной / non-AI вариант.
- **Польза:** принятые задачи, время / исправления и полная стоимость результата; tokens/API success отдельно.
- **Риск:** сценарные avoided losses с диапазонами, источниками и остаточным риском; blocked alerts не равны предотвращённым штрафам.
- **Расходы:** интеграция, эксплуатация, failed retries, tools, review, обучение, выход / перенос.

Окупаемость не обещается; неопределённый эффект или no-lift — допустимый отрицательный результат. Методика: [roi-calculator.md](roi-calculator.md); прежний XLSX не обновлялся.

<a id="slajd-15-resenie-po-evidence"></a>

## Слайд 15: Решение по evidence

До пилота: task / population / revisions, safety и operations gates, бюджет, duration и минимально полезный эффект. После — четыре независимых строки: protocol, correctness / policy, operational non-regression, customer utility.

| Решение | Условие |
|---|---|
| Stop / containment | Нарушен обязательный контроль или неприемлемый эффект |
| Доработать / повторить | Недостаточно данных или пользы, ошибки / цена review выше baseline |
| Продолжить в scope | Gates пройдены, ограничения и owner зафиксированы |
| Расширить | Польза подтверждена на нужных сегментах, операционные пределы и расходы допустимы |

Неизвестное не становится pass. Обязательные меры не отменяются из-за отрицательного коммерческого ROI.

<a id="slajd-16-resenia-kotorye-nujny-ot-soveta"></a>

## Слайд 16: Решения, которые нужны от совета

1. **Одобрить MLSec как отдельное направление** в программе ИБ.
2. **Назначить владельца пилота и независимый review**; объём FTE и оргструктуру обосновать scope.
3. **Утвердить cap пилота** и review; Q1 18–22 млн руб выше — лишь сценарий полной программы до резерва.
4. **Включить MLSec KPI** в quarterly scorecard CIO/CISO.
5. **Запустить ежеквартальный MLSec-report** в совет.

Следующий шаг: согласовать конкретные scope / cap / критерии и назначить review; production rollout требует отдельного решения.

---

<a id="appendix-opzional_no"></a>

## Appendix (опционально)

- A1: Топ-10 угроз MLSec 2026.
- A2: Кейсы индустрии с потерями.
- A3: Сравнение open-source инструментов (Presidio / LlamaFirewall / garak / promptfoo).
- A4: Compliance mapping (152-ФЗ / EU AI Act / ЦБ 716-П (система управления операционным риском; применимость проверяется отдельно) / 187-ФЗ).

<a id="primecania-dla-prezentuusego"></a>

## Примечания для презентующего

1. Слайды 3, 7, 13 требуют numbers-in (подстановка реальных данных компании).
2. Слайд 15 — решение по результатам пилота, не календарь неизбежных штрафов.
3. Слайд 16 заранее согласовать с CIO и ML Lead (co-sponsor).
4. Q&A готовить отдельно: доказательства, gaps, альтернатива, полная цена и условия остановки. Источники / статус файлов: [README](README.md).
