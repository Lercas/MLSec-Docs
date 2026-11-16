<a id="vnedrenie-mlsec-i-ai-security-v-rossijskih-kompaniah-prakticeskij-plejbuk"></a>

# Внедрение MLSec и AI Security в российских компаниях. Практический плейбук

> Версия: 2.1 · Обновлено: 2026-05-29 · Теги: плейбук, roadmap, 152-ФЗ, ЦБ, ФСТЭК, зрелость, onboarding · Tier: 1-4
>
> **TL;DR**. Сводный внедренческий плейбук: roadmap 30/60/90 дней, модель зрелости, 152-ФЗ, ЦБ РФ, ФСТЭК, отечественный стек, OSS-инвентарь. В версии 2.0: два интерактивных сценария (запуск MLSec с нуля в банке и миграция от "shadow AI" к контролируемой Gateway-архитектуре), расширенный гайд "С чего начать по вашей роли" (7 ролей) с фокусом на российскую регуляторную среду.

> **Тематическое дополнение 2026-11-13**: допуск конкретного AI-сценария, свидетельства пилота, операционная ответственность и проверка действующих контролей. Базовая редакция сохранена; каталог продуктов и правовые утверждения не получили общего статуса повторно проверенных.




<a id="0-kak-pol_zovat_sa-etim-dokumentom"></a>

## 0. Как пользоваться этим документом

Документ собирает содержимое глав 01-12 в сквозной внедренческий сценарий. Если в организации ещё нет процессов MLSec, идите последовательно. Если что-то уже работает (Vault, SOC, SAST), используйте разделы 3 и 7 как карту пробелов.

Каталог инструментов — отправная точка для выбора, а не готовое разрешение на использование. Лицензию конкретной редакции, поддержку, место обработки данных и применимые требования проверяют перед внедрением; наличие OSS-аналога само по себе не доказывает правовую или техническую совместимость.

---

<a id="1-kogo-kasaetsa-mlsec-i-pocemu-sejcas"></a>

## 1. Кого касается MLSec и почему сейчас

Разделение ответственности в типичной российской компании к 2026 году выглядит так:

1. В продакшене уже есть или скоро появится: антифрод на ML, скоринг, рекомендательные системы, CV на производстве, чат-боты, ассистенты для поддержки, внутренние RAG-системы, копилоты для разработчиков, агентские пайплайны.
2. Регуляторы (ЦБ РФ, ФСТЭК, Роскомнадзор) уже включают AI в свои требования. Банк России в 2023 и 2024 годах выпустил документы о рисках ИИ в финансовой сфере. ФСТЭК формирует подход к безопасности ИИ через действующие приказы 117 (ранее 17), 21, 239 и 31.
3. ГОСТ Р 71476-2024 задаёт концепции и терминологию ИИ, а требования к системе менеджмента ИИ относятся к ISO/IEC 42001:2023. Назначение документов различается; терминологический стандарт нельзя предъявлять как подтверждение безопасности или внедрения AIMS.
4. Атаки на ML-системы в 2024-2025 годах стали массовыми. Prompt injection, утечки через логи LLM, отравление open-source датасетов, компрометация моделей из публичных хабов. Это уже не теория.

Вывод. MLSec нужен не «в будущем», а в рамках ближайшего цикла бюджетирования ИБ. Не внедрив MLSec сегодня, компания через 6-12 месяцев получает неуправляемый shadow AI, утечки ПДн и коммерческой тайны, неконтролируемые расходы на облачные LLM и невозможность пройти регуляторную проверку.

---

<a id="2-rossijskij-regulatornyj-kontekst"></a>

## 2. Российский регуляторный контекст

<a id="21-normativnaa-baza-kotoruu-nujno-ucityvat_"></a>

### 2.1. Нормативная база, которую нужно учитывать

| Документ | Зона действия | Что это даёт для MLSec |
|---|---|---|
| 152-ФЗ «О персональных данных» | Любая обработка ПДн | База для классификации данных, режимы трансграничной передачи, требования к оператору |
| 149-ФЗ «Об информации» | Информационные системы | Основа для режима защиты информации |
| 98-ФЗ «О коммерческой тайне» | Конфиденциальная коммерческая информация | Формальный режим КТ для датасетов, моделей, промптов |
| 187-ФЗ «О безопасности КИИ» | Критическая информационная инфраструктура | Учёт ML-сервисов как значимых объектов КИИ там, где применимо |
| ПП РФ 1119 | Уровни защищённости ИСПДн | УЗ1-УЗ4 для ML-систем, обрабатывающих ПДн |
| Приказ ФСТЭК 21 | Защита ПДн | Меры защиты, сертифицированные СЗИ |
| Приказ ФСТЭК 117 (ранее 17) | ГИС, иные названные государственные и муниципальные ИС; применимость по п. 1–3 | [Полный зарегистрированный текст](https://minjust.consultant.ru/files/55701): с 01.03.2026, отменяет 17; AI-пункты 34т, 49, 60–61. [Изменения 137](http://publication.pravo.gov.ru/file/pdf?eoNumber=0001202608110006) их не меняют; новый п. 32 — с 01.03.2027. Проверены эти два акта 13.11.2026, не все последующие изменения/методики; карта применимости и свидетельств — [18, §3.1.1](18-ru-compliance-deep.md) |
| Приказ ФСТЭК 239 | Защита КИИ | Категорирование, меры, аудит |
| Приказ ФСТЭК 31 | АСУ ТП | Для промышленных ML-сценариев |
| Положение ЦБ РФ 716-П, 850-П (ранее 787-П) | Операционные риски, операционная надёжность, аутсорсинг | Риски использования внешних AI-сервисов в банках |
| ГОСТ Р 57580.1, 57580.2 | Финансовая отрасль | Уровни защиты и оценка соответствия |
| ГОСТ Р 71476-2024 | Концепции и терминология ИИ | Единый язык описания AI-систем; не самостоятельный набор требований безопасности |
| ISO/IEC 42001:2023 | AI Management System | Требования к системе менеджмента ИИ; применимость национальной редакции и договорных требований проверяется отдельно |
| ГОСТ Р ИСО/МЭК 23894 | AI Risk Management | Управление рисками ИИ |
| Приказ Минцифры 311, Приказ ФСТЭК 156 | Реестр отечественного ПО | Импортозамещение СЗИ и платформ |

Назначение ГОСТ Р 71476-2024 сверено по [карточке Росстандарта](https://protect.gost.ru/gost/details/5718a44b-69aa-4491-b85f-1e08596edeb2); назначение AIMS — по [каталогу ISO/IEC 42001:2023](https://www.iso.org/standard/42001), проверено 13.11.2026. Таблица не заменяет оценку применимости конкретной нормы; подробный юридический контур — [глава 18](18-ru-compliance-deep.md).

<a id="22-prakticeskie-sledstvia-dla-mlsec"></a>

### 2.2. Практические следствия для MLSec

1. Классификация данных для ML-пайплайна строится с учётом ПДн, КТ, служебной тайны, и при необходимости - гостайны (отдельный контур).
2. Для систем, обрабатывающих ПДн, нужна модель угроз по методике ФСТЭК (актуально действующая редакция «Методики оценки угроз безопасности информации»), а не только STRIDE. STRIDE/STRIDE-AI используется как технический инструмент внутри сертифицированной методики.
3. Для значимых объектов КИИ нужна категоризация, учёт в ФСТЭК, журналы безопасности с хранением от 3 лет.
4. Для финансов (банк, НФО, страховой) нужен учёт ML-риска как операционного, а использование облачных LLM (OpenAI, Anthropic) как аутсорсинга с требованиями к поставщику.
5. Для передачи ПДн поставщику определить правовое основание, роли сторон, географию и применимые процедуры, включая трансграничную передачу. Наличие согласия, отечественного бренда или DLP-прокси по отдельности не является универсальным разрешением. Псевдонимизация не предполагается автоматическим прекращением режима ПДн; решение фиксируется с Legal/Compliance, см. главу 18.

---

<a id="3-model_-zrelosti-mlsec-kuda-dvigat_sa"></a>

## 3. Модель зрелости MLSec. Куда двигаться

Модель из 5 уровней. Используйте её для самооценки и план-трека.

| Уровень | Название | Признаки | Кто может так работать |
|---|---|---|---|
| 0 | Ad hoc | Есть ML в продакшене, MLSec нет. Датасеты не классифицированы. Секреты в коде. Чат-боты без guardrails. Модели скачиваются напрямую с HuggingFace. | Большинство компаний до старта программы |
| 1 | Initial | Появилась политика по AI. Есть Data Classification, Vault для секретов. Базовые guardrails (regex, блок-листы) на LLM-эндпоинтах. | Типичный старт после первого инцидента |
| 2 | Managed | Threat model на каждый ML-продукт. Автоматический pre-commit на секреты и PII. Model registry с хэшами и подписями. Базовый Red Teaming. Процесс Incident Response с SLA. | Зрелый финтех, телеком, крупный ритейл |
| 3 | Defined | Сквозной CI/CD для ML с gate-ами. Непрерывный drift detection и alerting. Runtime guardrails + DLP на каждом входе/выходе LLM. KPI по MLSec в отчётах для правления. | Крупные банки, платформы, госкорпорации с высоким уровнем цифровизации |
| 4 | Optimizing | MLSec интегрирован с SOC и TIP. Red Teaming автоматизирован (Garak, PyRIT) в рамках CI. Выводы feeding-ятся в дообучение (safety-fine-tuning). Compliance отчётность автогенерируется. | Топ 10-20 игроков рынка, ведущие платформы |

Практическая рекомендация. Целевой уровень на 12 месяцев: 2 (Managed). На 24 месяца: 3 (Defined). Прыжок с 0 сразу на 3 почти не случается и ведёт к срыву программы.

---

<a id="4-90-dnevnyj-plan-starta-quick-wins"></a>

## 4. 90-дневный план старта (Quick Wins)

Этот план рассчитан на команду из 1-2 AppSec/MLSec-инженеров и 1 владельца процесса со стороны ML. Если ресурсов меньше, см. раздел 11 про Rilio и аутстаф.



<a id="mesaz-1-inventarizazia-i-bazovye-kontroli"></a>

### Месяц 1. Инвентаризация и базовые контроли

1. Инвентаризация ML-активов. Составьте реестр моделей, данных, пайплайнов, чат-ботов, агентов, интеграций с внешними LLM (OpenAI, Anthropic, GigaChat, YandexGPT, T-Банк GigaChat-like, DeepSeek, Qwen). Источник для сбора: опрос команд, сетевой egress-log, счета за облако, API-gateway.
2. Классификация данных и проектов. 4 уровня: Public, Internal, Confidential, Restricted. Привяжите к каждому уровню матрицу допустимых инструментов и моделей (см. раздел 10).
3. Секреты в Vault или SOPS. Удалите хардкод. Pre-commit на gitleaks / trufflehog. Цель: ноль новых секретов в коммитах.
4. Определите политику по облачным LLM. До решения вопроса с ПДн и КТ - запрет отправки Confidential/Restricted данных в облачные LLM без прокси с DLP. Shadow AI выводится на ковер, но не запрещается. Запрет без альтернативы - это гарантия shadow AI.

<a id="pesocniza-detection-llm-provajder-tokenov-v-kommitah"></a>

#### Песочница: detection LLM-провайдер-токенов в коммитах

Pattern определяет токены OpenAI / Anthropic / HuggingFace / GigaChat / YandexGPT в diff. В реальности pre-commit hook gitleaks использует подобные правила, но широкий покрывный набор для всех LLM-провайдеров пока не из коробки.

```widget:regex-tester
{
  "id": "ch13-llm-tokens",
  "title": "Secret-подобные строки в diff: кандидаты review",
  "description": "Ищет выбранные префиксы и длины token-подобных строк. Не проверяет существование/актуальность credential и не отличает fixture от живого секрета по словам fake/test.",
  "defaultPattern": "(?:sk-(?:proj-|ant-api[0-9]{2}-)?[A-Za-z0-9_-]{20,})|(?:hf_[A-Za-z0-9]{30,})|(?:GIGACHAT_API_KEY=[A-Za-z0-9+/=]{40,})|(?:y0_[A-Za-z0-9_-]{40,})",
  "flags": "g",
  "tests": [
    {"id": "p1", "shouldMatch": true, "label": "Синтетическая строка с префиксом sk-proj: кандидат review", "text": "OPENAI_API_KEY=sk-proj-AbCdEfGhIj1234567890MnOpQrStUvWxYz9876543210"},
    {"id": "p2", "shouldMatch": true, "label": "Синтетическая строка с префиксом sk-ant-api03", "text": "client = Anthropic(api_key=\"sk-ant-api03-XYZabcdef0123456789ghijklmnop_qrstuvwxyz\")"},
    {"id": "p3", "shouldMatch": true, "label": "Синтетическая строка с префиксом hf_", "text": "huggingface_hub.login(token=\"hf_AbCdEfGhIjKlMnOpQrStUvWxYz0123456789\")"},
    {"id": "p4", "shouldMatch": true, "label": "Учебное значение GIGACHAT_API_KEY: кандидат review", "text": "GIGACHAT_API_KEY=NDg2MWNiNTktN2QwMS00OGM2LWFhM2YtNWM5MzQwNWY4MDI4"},
    {"id": "p5", "shouldMatch": true, "label": "Синтетическая строка с префиксом y0_", "text": "yandex_gpt.token = 'y0_AgAAAABCDEFG-HIJKLMNOPQRSTUVwXYz0123456789'"},
    { "id": "n1", "shouldMatch": false, "label": "Documentation placeholder", "text": "# Set OPENAI_API_KEY=sk-... before running" },
    { "id": "n2", "shouldMatch": false, "label": "Comment about not committing", "text": "# DO NOT COMMIT: store sk-proj-* tokens in Vault" },
    {"id": "n3", "shouldMatch": true, "label": "FP-сигнал: синтетическая fake-строка тоже подходит под формат", "text": "OPENAI_API_KEY=sk-test-fake-key-for-unit-tests"}
  ]
}
```

> Видим candidate secret по текстовой форме; даже явно синтетический пример может совпасть. Исключения для fixtures задают отдельно по проверенному пути/контексту с owner и review, а не глобальным пропуском слова FAKE. FP/FN измеряются на своём корпусе; эти примеры не дают процент качества или полного покрытия провайдеров. Подлинность ключей live-запросами здесь не проверяется.

<a id="mesaz-2-threat-modeling-i-guardrails"></a>

### Месяц 2. Threat modeling и guardrails

1. Threat model на 2-3 ключевых ML-продукта. DFD + STRIDE-AI, карточка угроз на каждый поток, привязка к OWASP LLM Top 10 и MITRE ATLAS.
2. Пилот LLM Gateway. Один эндпоинт (`/v1/chat/completions`) с DLP на входе и выходе, kill-switch, логированием. Подробнее в разделе 11 (Rilio).
3. Базовые guardrails на чат-ботах. Блок-листы, regex на секреты и PII, RAG-контекст с source-attribution, output-фильтры.
4. Минимальный Incident Response. Канал, дежурный, три плейбука: утечка секрета в LLM, prompt injection, компрометация модели из внешнего хаба.

<a id="mesaz-3-avtomatizazia-i-audit"></a>

### Месяц 3. Автоматизация и аудит

1. CI-gate на ML-пайплайне. Bandit, pip-audit, OSV-Scanner, Checkov на IaC, Trivy на образы, SBOM (Syft) на релиз. Подписание Sigstore/Cosign.
2. Model Registry. MLflow или внутреннее решение. SHA-256 на каждую версию, Model Card, запрет прямого скачивания с HuggingFace в прод (только через прокси с verifikatsiei).
3. Первый Red Teaming. Garak по дефолтным профилям на ваш LLM-эндпоинт, Promptfoo на регрессию. Фиксация топ-10 дефектов и устранение.
4. Отчёт на правление. KPI, найденные риски, план на следующий квартал.

Результат 90 дней: уровень 1 (Initial) уверенно, ряд компонентов на уровне 2.

<a id="konstruktor-90-dnevnogo-quick-wins-plana"></a>

#### Конструктор 90-дневного quick-wins плана

Включайте задачи, которые реально успеете за 90 дней с командой из 1-2 AppSec/MLSec и 1 ML-owner. Конструктор покажет реалистичный coverage и предупредит о over-commitment.

```widget:policy-builder
{
  "id": "ch13-quickwins-90",
  "title": "90-дневный план: реалистичный scope",
  "description": "Пункты имеют условные веса трудоёмкости, а не фактические FTE-недели. Полная сумма 120 пунктов. Плановый лимит примера 100 пунктов проверяйте по сырой сумме: индикатор показывает долю от 120, а не вероятность выполнения. Реальный capacity считают по owners, доступным часам и резерву.",
  "scoreLabel": "Выбранный вес / полный список",
  "scoreMax": 120,
  "groups": [
    {
      "name": "Месяц 1: Инвентаризация и базовые контроли",
      "items": [
        {
          "id": "m1-inv",
          "label": "AI Inventory: реестр моделей / данных / интеграций (опрос + egress logs)",
          "weight": 8,
          "default": true,
          "recommended": true,
          "description": "Без inventory всё дальше повисает в воздухе. Самая важная задача месяца 1."
        },
        {
          "id": "m1-class",
          "label": "Классификация данных в 4 уровня (Public/Internal/Confidential/Restricted)",
          "weight": 6,
          "default": true,
          "recommended": true,
          "description": "Привязка к матрице допустимых инструментов."
        },
        {
          "id": "m1-secrets",
          "label": "Vault / SOPS + pre-commit gitleaks",
          "weight": 5,
          "default": true,
          "description": "Не пускать новые secrets в commits + миграция текущих."
        },
        {
          "id": "m1-llm-policy",
          "label": "AI Use Policy: запрет Confidential/Restricted в cloud LLM без DLP-прокси",
          "weight": 5,
          "default": true,
          "recommended": true,
          "description": "Shadow AI выводим на ковёр, но даём alternative."
        }
      ]
    },
    {
      "name": "Месяц 2: Threat modeling и guardrails",
      "items": [
        {
          "id": "m2-tm",
          "label": "Threat Model для 2-3 ключевых ML-продуктов (STRIDE-AI + DFD)",
          "weight": 12,
          "default": true,
          "recommended": true,
          "description": "Не делайте 10 — успешно 2-3 это уже win. Один tabletop-session в комнате > трёх документов."
        },
        {
          "id": "m2-gw",
          "label": "LLM Gateway pilot (один endpoint с DLP + kill-switch)",
          "weight": 10,
          "recommended": true,
          "description": "Pilot, не enterprise rollout. Используйте Rilio / LiteLLM / Portkey out-of-the-box."
        },
        {
          "id": "m2-guardrails",
          "label": "Базовые guardrails на чат-ботах (blocklist + regex + RAG attribution)",
          "weight": 6,
          "recommended": true,
          "description": "Первый слой: проверить на своих positive/negative/adaptive сценариях. Доля блокировок заранее неизвестна."
        },
        {
          "id": "m2-ir",
          "label": "Минимальный IR: канал + дежурство + 3 playbook (secret leak / injection / model compromise)",
          "weight": 5,
          "recommended": true,
          "description": "Без IR на момент инцидента команда теряется."
        }
      ]
    },
    {
      "name": "Месяц 3: Автоматизация и аудит",
      "items": [
        {
          "id": "m3-ci",
          "label": "CI gates: Bandit + pip-audit + Checkov + Trivy + Sigstore",
          "weight": 8,
          "default": true,
          "recommended": true,
          "description": "Стандартные SAST/SCA/IaC/container — обязательные gates."
        },
        {
          "id": "m3-registry",
          "label": "Model Registry с SHA-256 + запрет прямого pull с HF в prod",
          "weight": 6,
          "default": true,
          "description": "MLflow + signed cosign + ML-BOM запись."
        },
        {
          "id": "m3-redteam",
          "label": "Первый Red Teaming через Garak + Promptfoo regression",
          "weight": 6,
          "recommended": true,
          "description": "Default-профили достаточны для baseline; глубже — на следующий квартал."
        },
        {
          "id": "m3-board",
          "label": "Отчёт правлению: KPI + риски + план Q2",
          "weight": 5,
          "default": true,
          "description": "Без report’а правлению ваш бюджет не возобновят."
        }
      ]
    },
    {
      "name": "Опциональное (over-commit risk)",
      "items": [
        {
          "id": "opt-mfa",
          "label": "MFA rollout на все интерактивные аккаунты",
          "weight": 8,
          "description": "Полезно, но 90 дней мало для full rollout. Сделайте на Q2."
        },
        {
          "id": "opt-dpia",
          "label": "DPIA для каждой ML-системы с PII",
          "weight": 12,
          "description": "DPIA качественный требует 2-4 недели каждая. Реалистично — 1 DPIA в первые 90 дней."
        },
        {
          "id": "opt-mrm",
          "label": "Полный MRM и сопоставление с применимыми требованиями ЦБ",
          "weight": 18,
          "description": "Внутренняя программа управления модельным риском; 716-П не задаёт универсальный MRM для всех AI-систем. Объём и сроки планируются отдельно."
        }
      ]
    }
  ],
  "rules": [
    {
      "id": "must-inv",
      "type": "require-all",
      "items": [
        "m1-inv"
      ],
      "message": "Без AI Inventory всё последующее не имеет фундамента. Это #1 задача."
    },
    {
      "id": "must-tm",
      "type": "require-all",
      "items": [
        "m2-tm"
      ],
      "message": "Без Threat Model на ключевые продукты — vulnerable spots не известны."
    },
    {
      "id": "must-ci",
      "type": "require-all",
      "items": [
        "m3-ci"
      ],
      "message": "Без CI gates любые улучшения regress'ятся при следующем коммите."
    }
  ],
  "thresholds": [
    {
      "from": 0,
      "to": 50,
      "label": "Выбрано до 60 пунктов; проверьте обязательные задачи и доступные часы",
      "tone": "info"
    },
    {
      "from": 50,
      "to": 83.33333333333333,
      "label": "Выбрано 60–100 пунктов; лимит ещё не доказывает выполнимость",
      "tone": "warn"
    },
    {
      "from": 83.33333333333333,
      "to": 100,
      "label": "На границе 100 пунктов или выше: проверьте сырую сумму и перепланируйте превышение",
      "tone": "warn"
    }
  ]
}
```

---



<a id="41-ot-reestra-modeli-k-dopusku-szenaria"></a>

### 4.1. От реестра модели к допуску сценария

**Проблема**: в реестре есть «корпоративный AI-ассистент», но одна команда использует его для публичного текста, другая — для RAG по клиентским обращениям, третья — для автономной отправки писем. Общий model ID не описывает различия данных, получателей и полномочий.

Единица допуска — **сценарий с границами действий**, связанный с общей карточкой AI-системы. Не создавать параллельный реестр: дополнить существующий ID перечнем разрешённых сценариев и их версий.

| Поле сценария | Что фиксировать | Пример для внутреннего support-RAG |
|---|---|---|
| Назначение и результат | Какую задачу решаем и что считается правильным итогом | Найти действующий регламент, дать ответ со ссылкой на доступный документ |
| Пользователи и полномочия | Роли, tenant/подразделение, разрешённые действия | Support-reader; чтение своих регламентов, без отправки писем |
| Данные и производные | Источники, классификация, embeddings, память, логи | Регламенты + ACL; журнал без полного текста обращений |
| Получатели | Модели, routing/fallback, grader, connectors, observability | Только утверждённые endpoints; отдельная оценка каждого получателя |
| Исполнение | Sync/streaming/background/schedule, identity и лимиты | Интерактивные запросы; нет фоновых задач и долгоживущих write-токенов |
| Контроли и отказ | Где принимается решение и что происходит при сбое | ACL до retrieval, policy на tool-call, отказ при недоступном авторизаторе |
| Ответственность | Business owner, технический operator, дежурный, data owner | Именованные роли с замещением и каналом эскалации |
| Срок допуска | Review date, основания пересмотра, способ остановки | Пересмотр при смене corpus/модели/прав; отзыв через контроллер и IAM |

**Порядок регистрации:**

1. Сопоставить опросы команд с runtime-источниками: IdP/OAuth grants, gateway/egress, счета, CI, cron/webhooks и connector registry. Отдельно записать зоны, для которых наблюдаемости нет; отсутствие трафика в одном proxy не равно отсутствию AI.
2. Для каждого сценария указать бизнес-пользу, неприемлемый результат и безопасный ручной процесс. Допустим и вывод «AI для этой операции не требуется».
3. Разделить чтение, подготовку черновика и исполнение. Переход от ответа в интерфейсе к записи в CRM/отправке сообщения требует нового допуска, даже если модель и промпт не изменились.
4. Привязать путь данных и действия к техническим enforcement points. Gateway контролирует LLM-трафик, но не обязательно видит локальный shell, прямой API коннектора или задания планировщика.
5. До пилота согласовать допустимый объём данных, участников, стоимость, продолжительность и критерии остановки. Исключения ограничить владельцем, scope и сроком; истечение срока не продлевается автоматически.

**Основа**: [NIST AI RMF Playbook, GOVERN 1.6](https://airc.nist.gov/airmf-resources/playbook/govern/) связывает inventory и управление риском с жизненным циклом; решение о целесообразности и допуске рассматривается в [MANAGE 1.1](https://airc.nist.gov/airmf-resources/playbook/manage/). Схема карточки и последовательность выше — корпоративный шаблон, проверка источников 13.11.2026.

<a id="42-pilot-ot-ustanovlennogo-produkta-k-proverennomu-kontrolu"></a>

### 4.2. Пилот: от установленного продукта к проверенному контролю

Не измерять успех пилота количеством включённых переключателей. Для каждого риска заранее записать **действие → контроль → ожидаемое наблюдение → владелец свидетельства**. Пилот начинается на синтетических данных/тестовых аккаунтах, затем расширяется только в утверждённой границе.

| Проверка | Положительный сценарий | Отрицательный сценарий | Что сохраняем |
|---|---|---|---|
| Доступ к документам | Пользователь читает свой документ | Соседний tenant или отозванная роль не получают chunk, цитату и cached answer | Решения ACL, test IDs, readback прав |
| Передача модели | Разрешённые данные идут утверждённому provider | Прямой SDK/альтернативный URL/fallback не обходят маршрут | Egress-проверка и фактический model/endpoint ID |
| Действия агента | Разрешённый черновик доступен для review | Подмена адресата/объекта после согласования не исполняется | Policy decision, аргументы, executor log и readback |
| Сбой контроля | Безопасная операция работает в штатном режиме | Timeout авторизатора/DLP не открывает запрещённый путь | Результат fault injection, причина отказа |
| Отзыв доступа | Активная роль выполняет разрешённую задачу | Старая сессия, connector и scheduled job не сохраняют прежнее право | Deny/readback каждого затронутого компонента |
| Остановка | Оператор останавливает сценарий в согласованное время | Повтор очереди/webhook не запускает запрещённое действие снова | Состояния очередей, scheduler и IAM после остановки |

**Пакет свидетельств пилота:**

- ID и версия сценария; digests конфигурации, политики, prompt/tool schema; точный model ID и доступный revision поставщика.
- Состав тестов и реально завершённые прогоны, включая ошибки/пропуски. Для критичных проверок `timeout` или отсутствие журнала — не положительный результат.
- Исходная линия качества без контроля и candidate с контролем на сопоставимых задачах: безопасность, полезность, задержка/стоимость, ложные блокировки.
- Независимое подтверждение эффекта: журнал исполнителя и состояние объекта, а не только текст «операция запрещена» в ответе модели.
- Остаточные риски, срок исключений, operational owner, порядок отзыва и приёмочная запись о передаче в эксплуатацию.

**Правило расширения**: новый пользовательский cohort, класс данных, источник retrieval, write-инструмент или получатель требует оценки затронутых проверок. Не переносить локальный `pass` в утверждение о готовности всего product/tenant. При недостаточной полезности результат — доработка либо отказ от сценария; хорошее подавление атак не доказывает пользу бизнесу.

Рекомендуемый переход: `зарегистрирован → ограниченный пилот → принят в эксплуатацию → пересмотр/ограничение → вывод`. Переход разрешён только при наличии свидетельств и назначенного владельца; календарное окончание 90 дней само по себе статус не меняет. Основу оценки и release-контракта см. [07](07-red-teaming-testing-methods.md), [12](12-detection-protection-cicd-llm.md), для агентов — [36](36-ai-agents-production-checklist.md). [NCSC secure AI guidelines](https://www.ncsc.gov.uk/files/Guidelines-for-secure-AI-system-development.pdf) связывают release с оценкой, известными ограничениями и incident-подготовкой; проверено 13.11.2026.

---

<a id="5-etalonnaa-zelevaa-arhitektura"></a>

## 5. Эталонная целевая архитектура

Ниже - упрощённая целевая архитектура MLSec для типичной российской компании. Её удобно использовать как референс при проектировании и при защите бюджета.

```mermaid
flowchart LR
    subgraph USERS[Пользователи]
        DEV["Разработчик / IDE"]
        BOT["Чат-бот, ассистент"]
        AG["Агент, RAG"]
    end
    subgraph PERIM[Периметр ИБ]
        direction TB
        WAF["WAF - Coraza<br/>Rate Limit, IP allowlist, mTLS"]
        GW["LLM Gateway Rilio<br/>Auth, Budget, Kill-Switch<br/>DLP pre/post, Guardrails<br/>Audit, SIEM export"]
        POL["Policy Engine<br/>per-user / per-model / per-project"]
        WAF --> GW --> POL
    end
    subgraph STORE[Сервисы данных]
        MLF["MLflow Registry<br/>Sigstore / Cosign"]
        VEC["Vector DB<br/>Qdrant / Weaviate / pgvector"]
    end
    subgraph MODELS["Облако / Локальные модели"]
        LOCAL["Локальные модели<br/>Ollama, LM Studio, vLLM"]
        CLOUD["Облачные LLM<br/>GigaChat, YandexGPT, DeepSeek"]
    end
    DEV -- HTTPS --> WAF
    BOT -- HTTPS --> WAF
    AG -- HTTPS --> WAF
    POL --> MLF
    POL --> VEC
    POL --> LOCAL
    POL --> CLOUD
```

Инфраструктура - Kubernetes (Pod Security Standards: Restricted), Istio/Linkerd, Cilium NetworkPolicy. Наблюдаемость - Prometheus, Grafana, Loki, OpenTelemetry, Evidently AI (drift). Secrets/KMS - HashiCorp Vault + Transit, SOPS для GitOps. SIEM/SOC - MaxPatrol SIEM, KUMA, ArcSight, Splunk или open-source Wazuh + OpenSearch. Runtime - Falco, Tetragon, eBPF-детекторы. SAST/SCA - Bandit, Semgrep, pip-audit, OSV-Scanner, Trivy, Syft. CI/CD - GitLab CI, Jenkins, Drone с MLSec gate-ами перед deploy.

Если организация работает в режиме импортозамещения, большинство ролей имеет отечественные или open source аналоги. См. раздел 6.

---

<a id="6-otecestvennyj-i-importozamesausij-stek"></a>

## 6. Отечественный и импортозамещающий стек

MLSec-стек, который закрывает ключевые функции и вписывается в требования по импортозамещению и реестр отечественного ПО.

| Функция | Международный стандарт | Российский или OSS вариант |
|---|---|---|
| KMS, secrets | HashiCorp Vault | OSS Vault (1.14.x — последняя под MPL 2.0; с 1.15, сентябрь 2023 — BSL 1.1), форк OpenBao (MPL 2.0), Infotecs ViPNet KMS, КриптоПро HSM, самохостинг Bitwarden Secrets Manager |
| SIEM | Splunk, ArcSight | MaxPatrol SIEM, KUMA (Kaspersky), RuSIEM, Wazuh + OpenSearch |
| SOAR | Cortex XSOAR | R-Vision SOAR, Security Vision, Shuffle (OSS) |
| WAF | Cloudflare, Imperva | PT Application Firewall (Positive Technologies), Solar webProxy, Coraza (OSS), NGINX + ModSecurity |
| DLP | Symantec, Forcepoint | InfoWatch Traffic Monitor, Solar Dozor, Staffcop, Rilio для LLM-трафика |
| Container Scan | Trivy, Grype | Trivy/Grype (OSS), PT Container Security |
| SAST | Checkmarx | PT Application Inspector, Solar appScreener, Svace, Semgrep (OSS) |
| IAM, SSO | Okta | Keycloak (OSS), Blitz Identity Provider, Avanpost FAM, Indeed Access Manager |
| ML Registry | MLflow | MLflow (OSS), self-hosted ClearML, Weights & Biases on-prem |
| PII / ПДн детекция | Presidio (Data Privacy Stack) | Presidio + custom-расширение для ру-ПДн (паспорт, ИНН, СНИЛС, КПП, ОГРН), Natasha, DeepPavlov, Rilio DLP с российскими паттернами |
| LLM провайдеры | OpenAI, Anthropic | GigaChat (Сбер), YandexGPT (Яндекс), T-Технологии, Cotype (МТС), локальные open weights: Qwen, DeepSeek, YandexGPT-lite, LLaMA-производные через Ollama, vLLM |
| Облачная инфра | AWS, GCP | Yandex Cloud, VK Cloud, SberCloud, Cloud.ru, MWS, Selectel, on-prem Kubernetes |

Рекомендация. Не пытайтесь заменить всё сразу. Построение «полностью импортонезависимого» MLSec за один квартал - путь к параличу. Сначала - работающая архитектура на opensource и том, что уже куплено. Параллельно - миграционный трек по критичным компонентам СЗИ.

---

<a id="6a-proverennyj-open-source-po-domenam-mlsec"></a>

## 6A. Проверенный open-source по доменам MLSec

Ниже подборка компонентов для оценки; в ней смешаны open-source, source-available и коммерческие редакции. BSL/SSPL/ELv2 нельзя автоматически считать OSI open source. Поле лицензии, maintenance status и состав Enterprise-функций сверять по конкретному release и договору; таблица старой редакции не доказывает совместимость любого сочетания.

<a id="6a1-secrets-i-kms"></a>

### 6A.1. Secrets и KMS

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| HashiCorp Vault | BSL 1.1 (с 2023), OSS-совместимый self-host | Central secrets, PKI, Transit, KV, динамические секреты | Основной выбор, если принимаете BSL |
| OpenBao | MPL 2.0 (форк Vault в Linux Foundation) | Полноценный fork Vault до BSL | Для тех, кому нужен строгий OSS без BSL |
| Mozilla SOPS | MPL 2.0 | Шифрование YAML/JSON/ENV с KMS, GitOps-friendly | Парный к Vault для конфигов |
| Infisical | MIT (OSS + платный SaaS) | Secrets management, web-UI, integrations | Альтернатива Vault с акцентом на DX |
| age, rage | BSD-3, MIT | Современная замена GPG для шифрования файлов | Для межкомандного обмена |
| gitleaks | MIT | Сканирование репозиториев на секреты | Обязательно в pre-commit и CI |
| trufflehog | AGPL-3.0 (OSS), Apache 2.0 для детекторов | Сканирование репозиториев, verified-секреты | Более глубокие детекторы, чем gitleaks |
| detect-secrets (Yelp) | Apache 2.0 | Pre-commit плагин, baseline-файл | Хороший компромисс для репозиториев с легаси |
| External Secrets Operator | Apache 2.0 | Мост между Vault/Cloud KMS и Kubernetes Secrets | Стандарт для K8s |
| Secrets Store CSI Driver | Apache 2.0 | Монтирование секретов в поды без K8s Secret | Альтернатива ESO, без промежуточного Secret |
| Vaultwarden | AGPL-3.0 | Self-hosted Bitwarden-совместимый сервер | Для хранения user-паролей и API-ключей команды |

<a id="6a2-identity-access-fine-grained-authorization"></a>

### 6A.2. Identity, Access, Fine-Grained Authorization

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Keycloak | Apache 2.0 | IdP, SSO (OIDC, SAML, LDAP), brokering | Де-факто стандарт OSS IdP |
| Authentik | MIT | Альтернатива Keycloak с акцентом на UX | Для небольших команд |
| Authelia | Apache 2.0 | Portal + policy engine перед reverse-proxy | Часто в паре с Traefik/NGINX |
| Zitadel | Apache 2.0 | Cloud-native IdP, multi-tenant | Для SaaS-архитектур |
| OpenFGA | Apache 2.0 | Fine-grained authorization (ReBAC/Zanzibar) | Для RAG per-tenant / per-document ACL |
| Permify | Apache 2.0 | ReBAC-движок, альтернатива OpenFGA | Выбор по API и SDK под стек |
| OPA | Apache 2.0 | Policy as code (Rego) | Унифицированные политики по всей инфраструктуре |
| Boundary (HashiCorp) | BSL | Zero-trust PAM | Для контроля доступа к bastion/базам |
| Teleport Community | AGPL-3.0 | SSH/K8s/DB access, identity-aware | Альтернатива Boundary |
| SPIFFE, SPIRE | Apache 2.0 | Workload identity, SVID | Для mTLS между сервисами |
| cert-manager | Apache 2.0 | TLS в Kubernetes, ACME | Обязателен в K8s |

<a id="6a3-container-i-kubernetes-security"></a>

### 6A.3. Container и Kubernetes security

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Trivy | Apache 2.0 | Сканирование образов, IaC, SBOM, secrets | Один из самых зрелых OSS-сканеров |
| Grype + Syft | Apache 2.0 | CVE-сканирование и SBOM-генерация | Хорошая связка с Sigstore |
| Clair | Apache 2.0 | Сканирование образов в registry | Часто в связке с Harbor |
| Harbor | Apache 2.0 | Container registry с подписями и сканированием | Self-hosted альтернатива Nexus/Artifactory |
| Kubescape | Apache 2.0 | Сканирование K8s по NSA/MITRE ATT&CK/CIS | Ориентирован на MLSec и compliance |
| kube-bench | Apache 2.0 | CIS Kubernetes Benchmark | Обязательный шаг перед прод |
| kube-hunter | Apache 2.0 | Pen-test в отношении K8s-кластера | Для периодического аудита |
| Kyverno | Apache 2.0 | Policy engine для Kubernetes (YAML-based) | Проще Rego для типовых политик |
| OPA Gatekeeper | Apache 2.0 | Admission controller на базе OPA | Для организаций с OPA-стандартом |
| Cilium | Apache 2.0 | CNI с eBPF, NetworkPolicy, Hubble | Стандарт для сетевой изоляции ML-нагрузок |
| Tetragon | Apache 2.0 | eBPF-based runtime visibility | Дополняет Falco |
| Falco | Apache 2.0 | Runtime security, behavioural rules | Де-факто OSS-стандарт |
| Tracee (Aqua) | Apache 2.0 | eBPF tracing, threat detection | Альтернатива Falco |
| Trivy Operator | Apache 2.0 | Непрерывное сканирование внутри кластера | Auto-VulnerabilityReport/SBOMReport CRDs |
| Chainguard Images, Distroless | Apache 2.0, BSD | Минимальные базовые образы | Резко снижают surface CVE |

<a id="6a4-supply-chain-artefakty-i-sbom"></a>

### 6A.4. Supply chain, артефакты и SBOM

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Sigstore (Cosign, Rekor, Fulcio) | Apache 2.0 | Подпись артефактов, прозрачный журнал, короткоживущие ключи | Стандарт индустрии, поддерживается OpenSSF |
| in-toto | Apache 2.0 | Attestation на шаги пайплайна | Базовый инструмент SLSA |
| SLSA Framework | Спецификация | Требования к защите source/build и provenance по выбранной редакции | Track и уровень фиксировать отдельно; наличие подписи не равно выполнению уровня |
| Dependency-Track (OWASP) | Apache 2.0 | SBOM-репозиторий, CVE-трек, PURL | Централизованное управление SBOM |
| OSV-Scanner | Apache 2.0 | CVE-сканирование по OSV базе | Хорош для lockfile и SBOM |
| OWASP Dep-Scan | MIT | Мультистек SCA | Альтернатива pip-audit/OSV для не-Python |
| Scorecard (OpenSSF) | Apache 2.0 | Оценка безопасности open-source проекта | Критерий для включения зависимости |
| GUAC | Apache 2.0 | Граф supply-chain-метаданных | Для крупных программ с сотнями артефактов |

<a id="6a5-sast-sca-iac"></a>

### 6A.5. SAST, SCA, IaC

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Semgrep (OSS) | LGPL 2.1 / Semgrep Ecosystem | Static analysis, свои правила | Быстрый, многоязычный |
| Bandit | Apache 2.0 | Python SAST | Обязателен для ML-кода |
| CodeQL | MIT (CLI), спец. лицензия для коммерческих анализов | SAST от GitHub | Мощный, ограниченная коммерческая лицензия |
| Horusec | Apache 2.0 | Multilanguage SAST | Лёгкая интеграция в CI |
| SonarQube Community | LGPL 3.0 | Code quality и safety | База для качества кода |
| pip-audit | Apache 2.0 | Сканирование Python-зависимостей | В CI и pre-commit |
| Safety | MIT | Альтернатива pip-audit с DB Safety | Для быстрых проверок |
| Checkov | Apache 2.0 | IaC-сканирование (Terraform, K8s, CloudFormation) | Стандарт OSS |
| tfsec | MIT | Scan Terraform | Часто вместе с Checkov |
| KICS | Apache 2.0 | IaC + Docker + K8s | Более широкий охват форматов |
| Terrascan | Apache 2.0 | IaC + OPA policies | Гибкая политика |
| Grafeas | Apache 2.0 | Метаданные об артефактах и уязвимостях | Для крупного supply-chain |

<a id="6a6-dast-fuzzing-api-security"></a>

### 6A.6. DAST, fuzzing, API security

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| OWASP ZAP | Apache 2.0 | DAST web и API | Классика, есть headless-режим для CI |
| Nuclei | MIT | Template-based vulnerability scanner | Быстрый и расширяемый |
| Wapiti | GPL-2.0 | Web-application vulnerability scanner | Альтернатива ZAP для отдельных кейсов |
| sqlmap | GPL-2.0 | SQL injection tester | Не забывать про LLM-промпты с SQL |
| Schemathesis | MIT | API fuzzing по OpenAPI | Отлично ложится на `/v1/chat/completions` |
| RESTler (MSR) | MIT | Fuzzer REST-сервисов | Для глубоких проверок API |
| fuzzingbook, atheris, AFL++ | Apache 2.0 / MIT / Apache 2.0 | Python/Java/нативный fuzzing | Для библиотек, обрабатывающих input |

<a id="6a7-observability-logi-metriki-trejsing"></a>

### 6A.7. Observability, логи, метрики, трейсинг

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Prometheus | Apache 2.0 | Metrics | База |
| Grafana OSS | AGPL-3.0 (с 2021) | Дашборды | Аккуратно читайте условия AGPL для клиентов |
| Loki | AGPL-3.0 | Log aggregation | Лёгкая альтернатива ELK |
| Tempo | AGPL-3.0 | Distributed tracing | Дополняет Loki |
| OpenTelemetry | Apache 2.0 | Стандарт инструментирования | Главный общий knob |
| OpenSearch, OpenSearch Dashboards | Apache 2.0 | Полноценная замена Elasticsearch 7.10 | Часто внутри SIEM-сборок |
| Graylog Open | SSPL | Log aggregation и SIEM-функции | Альтернатива Wazuh/ELK |
| Vector (Datadog) | MPL 2.0 | Высокопроизводительный pipeline логов и метрик | Полезен как замена Fluentd |
| Fluent Bit, Fluentd | Apache 2.0 | Lightweight и полнофункциональный лог-коллекторы | Базовый tier |
| Jaeger | Apache 2.0 | Distributed tracing | Альтернатива Tempo |
| SigNoz | MIT | OSS-аналог Datadog APM | Всё-в-одном для небольших команд |

<a id="6a8-siem-soar-i-detection"></a>

### 6A.8. SIEM, SOAR и detection

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Wazuh | GPL-2.0 | HIDS + SIEM, rules + agents | Базовый выбор SIEM для SMB и среднего enterprise |
| SecurityOnion 2 | Apache 2.0 + GPL | Полноценный стек NSM/SIEM с ELK/Zeek/Suricata | Для сетевого уровня |
| TheHive 5, Cortex | AGPL-3.0 | Incident Response + enrichment | Для SOC-операций |
| Shuffle | AGPL-3.0 | SOAR-платформа | Связка с TheHive |
| Sigma | DRL 1.0 (спецификация) + OSS-конверторы | Общий язык detection rules | Переносимость правил между SIEM |
| OSSEC | GPL-2.0 | Классический HIDS | Устарел относительно Wazuh, но жив |
| Suricata, Zeek | GPL-2.0, BSD | IDS/IPS и network monitoring | Для сетевого контура ML |
| CrowdSec | MIT | Коллаборативный IPS с community-списками | Быстрое усиление egress/WAF |

<a id="6a9-waf-api-gateway-edge"></a>

### 6A.9. WAF, API-gateway, edge

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Coraza | Apache 2.0 | WAF-движок, ModSecurity-совместимый | Рекомендуется как современная замена ModSecurity |
| ModSecurity 3 | Apache 2.0 | WAF-модуль для NGINX/Apache | Trustwave прекратила поддержку 01.07.2024, проект перешёл под управление OWASP; правила OWASP CRS активно поддерживаются. Рекомендуется миграция на Coraza |
| OWASP Core Rule Set (CRS) | Apache 2.0 | Набор правил WAF | Базовый набор для Coraza/ModSec |
| Envoy | Apache 2.0 | L4/L7 proxy, WASM filters | База для Istio, хорошо расширяется |
| Traefik | MIT | Reverse proxy, K8s-native | Часто в паре с Rilio |
| APISIX | Apache 2.0 | API gateway с плагинами (включая AI) | Быстрый Lua-based |
| Kong OSS | Apache 2.0 | API gateway, плагины AI | Тяжелее, но с крупной экосистемой |
| NGINX OSS | BSD-2 | Базовый proxy/LB | Универсальный |

<a id="6a10-llm-gateway-proxy-routing"></a>

### 6A.10. LLM gateway, proxy, routing

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Rilio | Self-hosted, коммерческая | Security-first LLM firewall, DLP, kill-switch, agent platform | См. раздел 11 |
| LiteLLM | MIT | OpenAI-совместимый proxy, 100+ провайдеров | Хорош как роутер, DLP и guardrails придётся приносить свои |
| Helicone (self-hosted) | Apache 2.0 | Observability + proxy | Больше про metrics и debug |
| Langfuse | MIT | Трейсинг и аналитика LLM-приложений | Self-host доступен |
| OpenLLMetry | Apache 2.0 | OpenTelemetry для LLM | Для унификации трейсов |
| Arize Phoenix | Elastic License 2.0 (OSS-ish) | LLM observability + evaluations | Self-host, но осторожно с ELv2 |
| Portkey Gateway (OSS) | MIT | Router и гайдрэйлы | Часть функций open |

<a id="6a11-llm-guardrails-i-prompt-injection-defense"></a>

### 6A.11. LLM guardrails и prompt injection defense

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| NeMo Guardrails (NVIDIA) | Apache 2.0 | DSL-гайдрэйлы, integration с RAG | Подходит для структурных диалогов |
| Guardrails AI | Apache 2.0 | Проверка входа/выхода по JSON-schema и rail-ам | Хорошая экосистема валидаторов |
| LlamaFirewall (Meta, PurpleLlama) | MIT | Сканеры prompt injection, alignment и небезопасного кода для агентов | Модели сканеров разворачиваются отдельно |
| LLM-Guard, Rebuff (Protect AI) | MIT / Apache 2.0 | Сканеры input/output и prompt injection | Архивированы; только для сопровождения старых интеграций |
| Vigil-LLM (deadbits) | MIT | Экспериментальный детектор jailbreak (alpha) | Без коммитов с января 2024; для исследований |

<a id="6a12-red-teaming-i-llm-evaluation"></a>

### 6A.12. Red Teaming и LLM-evaluation

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Garak (NVIDIA) | Apache 2.0 | Классический LLM red-team сканер | Профили: OWASP LLM, jailbreak, toxicity |
| PyRIT (Microsoft) | MIT | Framework для кампаний по red-teaming | Сильный в orchestration |
| Promptfoo | MIT | Регрессионные тесты промптов и моделей | Отлично в CI |
| Giskard | Apache 2.0 | Evaluation и red-team для ML и LLM | Универсальный, есть ML-модели |
| Inspect AI (UK AISI) | MIT | Eval framework для LLM | Активно развивается |
| DeepEval (Confident AI) | Apache 2.0 | LLM eval с готовыми метриками | Полезен для RAG-оценки |
| RAGAS | Apache 2.0 | Evaluation RAG | Стандарт для RAG-метрик |
| TruLens | MIT | LLM observability + evaluations | Локальный запуск |
| AttackGen | MIT | Генерация сценариев атак на GenAI | Для threat modeling |

<a id="6a13-adversarial-ml"></a>

### 6A.13. Adversarial ML

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Adversarial Robustness Toolbox (ART, IBM) | MIT | Атаки и защиты для CV/NLP/таб. моделей | Зрелый стандарт |
| CleverHans | MIT | Adversarial examples для DL | Базовый для исследований |
| Foolbox | MIT | Adversarial attacks на PyTorch/TF/JAX | Практичный API |
| TextAttack | MIT | NLP adversarial и data augmentation | Для текстовых моделей |
| Counterfit (Microsoft) | MIT | Оркестратор атак на ML | Заархивирован в июле 2025 года; для новых задач — ART и Garak |
| AugLy (Meta) | MIT | Data augmentation и тестовые возмущения | Полезен для robustness-тестов |

<a id="6a14-data-validation-i-kacestvo"></a>

### 6A.14. Data validation и качество

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Great Expectations | Apache 2.0 | Декларативная валидация данных | Основной выбор в pipeline |
| Deepchecks | AGPL-3.0 (Community) / Commercial | Проверки моделей и данных | Покрывает ML-модели комплексно |
| Pandera | MIT | Схемы и валидация pandas DataFrame | Лёгкая альтернатива GE |
| Soda Core | Apache 2.0 | Data quality as code | Хорошо ложится на DWH |
| Evidently AI | Apache 2.0 | Drift и качество моделей в проде | Стандарт для monitoring |
| WhyLogs (WhyLabs) | Apache 2.0 | Профили данных и детекция drift | Лёгкий, хранит профили, а не сырые записи; без коммитов с января 2025 года |

<a id="6a15-pii-i-pdn-detection"></a>

### 6A.15. PII и ПДн detection

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Presidio (Data Privacy Stack) | MIT | PII-анализ и анонимизация | С расширением под ру-ПДн - основной выбор |
| Natasha | MIT | Русскоязычный NLP (PER, LOC, ORG, DATES, MONEY) | Дополняет Presidio |
| DeepPavlov | Apache 2.0 | NLP-модели для русского (NER, интенты) | Для более точных ру-детекций |
| Razdel, Slovnet | MIT | Токенизация и морфология | База под Natasha |
| spaCy ru | MIT | Общий NLP-движок с ру-моделями | Часто как baseline |
| Scrubadub | Apache 2.0 | Чистка PII в текстах | Лёгкий в интеграции |
| PrivateAI (OSS-компоненты) | Commercial / OSS частично | Enterprise PII-детекция | Использовать избирательно |

<a id="6a16-mlops-i-model-registry"></a>

### 6A.16. MLOps и Model Registry

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| MLflow | Apache 2.0 | Tracking, Model Registry, Deployments | Базовый выбор |
| DVC | Apache 2.0 | Data и model versioning поверх Git | Отлично дополняет MLflow |
| ClearML | Apache 2.0 | Experiments, orchestration, serving | Полноценная альтернатива MLflow для команды |
| Kubeflow | Apache 2.0 | K8s-native ML pipelines | Для зрелых платформ |
| ZenML | Apache 2.0 | MLOps framework с плагинами | Для ускорения DX |
| Metaflow | Apache 2.0 | Орг-level ML workflow (Netflix) | Прост в onboarding |
| Feast | Apache 2.0 | Feature Store | Для продовых фич |
| BentoML | Apache 2.0 | Модель-servis | Для serving |
| KServe | Apache 2.0 | K8s-native inference | Устойчивый стандарт |
| Ray Serve | Apache 2.0 | Scale-out inference | Для больших моделей |
| Triton Inference Server | BSD-3 | Inference от NVIDIA | Для GPU-продакшена |

<a id="6a17-self-hosted-llm-inference"></a>

### 6A.17. Self-hosted LLM inference

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Ollama | MIT | Локальный запуск моделей (GGUF) | Самый простой старт |
| LM Studio | Проприетарная (free для indie) | Локальный запуск + UI | Для ноутбуков разработчиков |
| vLLM | Apache 2.0 | Высокопроизводительный inference (PagedAttention) | Прод на GPU |
| Text Generation Inference (HF) | Apache 2.0 | Prod-ready HF-inference | Полноценная альтернатива vLLM |
| LocalAI | MIT | Drop-in OpenAI-совместимый OSS | Удобен для home-lab и тестов |
| llama.cpp, gguf | MIT | CPU/GPU inference | База для многих решений |
| SGLang | Apache 2.0 | Новые runtime-фичи (prefix cache) | Растущий выбор |
| Aphrodite Engine | AGPL-3.0 | Fork vLLM | Для тонких настроек |
| OpenWebUI | MIT | UI поверх локальных моделей | Для поддержки и пилотов |

<a id="6a18-vector-dbs-i-rag-infrastruktura"></a>

### 6A.18. Vector DBs и RAG-инфраструктура

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| pgvector | PostgreSQL License | Векторный поиск в Postgres | Первый выбор, если есть Postgres |
| Qdrant | Apache 2.0 | Векторная БД, payload-фильтры, RBAC | Русскоязычный проект с open-core |
| Weaviate | BSD-3 | Векторная БД с schema | Сильная экосистема модулей |
| Milvus | Apache 2.0 | Масштабируемая векторная БД | Для больших объёмов |
| Chroma | Apache 2.0 | Локальная векторная БД | Для прототипов и малых решений |
| Vespa | Apache 2.0 | Поиск + векторы в одном | Для гибридного поиска |
| Typesense | GPL-3.0 | Full-text + vector | Лёгкая интеграция |
| Haystack (deepset) | Apache 2.0 | RAG-framework | Продакшн-ориентирован |
| LlamaIndex | MIT | RAG-framework | Хорош в экспериментах |
| LangChain (OSS) | MIT | Orchestration | Использовать осторожно: много зависимостей |

<a id="6a19-zasita-picklemodel_nyh-artefaktov"></a>

### 6A.19. Защита pickle/модельных артефактов

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| ModelScan (Protect AI) | Apache 2.0 | Сканирование pickle, pytorch, tensorflow, keras, h5 на malware | Обязателен перед прод-загрузкой |
| picklescan (Hugging Face) | Apache 2.0 | Анти-pickle сканер | Часть цепочки в HF |
| fickling (Trail of Bits) | LGPL-3.0 | Анализ и декомпиляция pickle | Для ручного расследования |
| SafeTensors | Apache 2.0 | Безопасный формат весов | Переходить с pickle, когда возможно |
| safe-coerce, tuf | MIT, Apache 2.0 | The Update Framework для ML-артефактов | Signed updates |

<a id="6a20-threat-modeling-i-modelirovanie-riskov"></a>

### 6A.20. Threat modeling и моделирование рисков

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| OWASP Threat Dragon | Apache 2.0 | DFD-редактор и threat catalog | Для ручных моделей |
| pytm | MIT | Threat modeling as code | Для автоматизации |
| Microsoft Threat Modeling Tool | Бесплатный | Классический STRIDE-инструмент | Для офлайн-сессий |
| MITRE ATLAS Navigator | Apache 2.0 | Матрица тактик/техник для AI | Для трекинга покрытия |
| IriusRisk Community | Proprietary (free tier) | Полноценная платформа | Для зрелых программ |
| Cartography (Lyft) | Apache 2.0 | Граф инфраструктуры для моделирования | Дополняет threat modeling |

<a id="6a21-agent-security"></a>

### 6A.21. Agent security

| Инструмент | Лицензия | Назначение | Комментарий |
|---|---|---|---|
| Agentic Radar | Apache 2.0 | Сканирование конфигурации агентов и tool-интеграций | Для инвентаризации |
| LlamaFirewall | MIT | Входной и tool-level guardrail агента | Сопровождается в составе PurpleLlama |
| Autogen, CrewAI, LangGraph | MIT, MIT, MIT | Фреймворки многоагентных систем | Смотреть на встроенные контроли, добавлять внешний Gateway |
| MCP (Model Context Protocol) | Apache 2.0 | Стандарт инструментов для LLM | Контролировать tool allowlist и scopes |

<a id="6a22-prakticeskij-minimum-kotoryj-dostatocno-imet_-iz-korobki"></a>

### 6A.22. Практический минимум, который достаточно иметь «из коробки»

Для старта (уровень 1 зрелости) и для большинства SMB-кейсов достаточно следующей OSS-связки:

1. Secrets: Vault или OpenBao, External Secrets Operator, gitleaks в pre-commit и CI.
2. Identity: Keycloak с OIDC + MFA, OPA/Kyverno на K8s, OpenFGA для RAG-уровня.
3. Containers: Trivy + Syft, Kubescape, kube-bench. Chainguard/Distroless базовые образы.
4. Supply chain: Sigstore (Cosign + Rekor), Dependency-Track, OSV-Scanner.
5. CI gate: Bandit, Semgrep, pip-audit, Checkov. Отказ при CVSS >= 7.0.
6. Runtime: Falco + Tetragon, Cilium NetworkPolicy, cert-manager.
7. Observability: Prometheus + Grafana + Loki + OpenTelemetry.
8. SIEM: Wazuh + OpenSearch, Sigma-правила.
9. WAF и edge: Coraza + OWASP CRS, Envoy/Traefik.
10. LLM gateway: Rilio, если нужен security-first. LiteLLM, если нужен только роутер.
11. LLM guardrails: NeMo Guardrails / Guardrails AI + LlamaFirewall.
12. Red Teaming: Garak + Promptfoo в CI, PyRIT как кампания раз в квартал, ART для CV/таб.
13. Data: Great Expectations, Evidently AI, DVC, MLflow.
14. PII/ПДн: Presidio + Natasha + DeepPavlov.
15. Model scanning: ModelScan, SafeTensors как формат.
16. Threat modeling: OWASP Threat Dragon + pytm + MITRE ATLAS Navigator.

Совместимость выбранных компонентов с конкретным Linux-дистрибутивом, ядром, crypto policy, GPU-драйвером и системой обновлений подтверждается пилотом. Общее наличие Linux-пакета не доказывает поддержку любого отечественного дистрибутива или выполнение требований импортозамещения.

---



<a id="7-kontrol_nye-tocki-po-glavam"></a>

## 7. Контрольные точки по главам

Карта, которая помогает проверить, что закрыто, а что нет. Используйте как чек-лист на внутреннем аудите.

| Контроль | Документ | Критерий «готово» |
|---|---|---|
| Архитектура MLSec и принципы | 01 | Принципы secure-by-design/default/deployment задокументированы и встроены в стандарт проектирования ИТ-систем |
| ML System Design Review | 02 | DFD, PIA, Data Classification обязательны до старта проекта. Шаблон один на организацию |
| Валидация данных и PII | 03 | Great Expectations / Deepchecks в пайплайне. Presidio + правила под ру-ПДн. DVC или альтернатива |
| SAST, SCA, container scan | 04, 12 | Bandit + pip-audit + OSV-Scanner + Trivy в каждом пайплайне. CVSS >= 7.0 блокирует merge |
| Model Registry и подписи | 04, 05 | Каждая модель с SHA-256, Model Card, Sigstore/Cosign подписью. Запрет прямого скачивания в прод |
| Kubernetes security | 05 | Pod Security Standards: Restricted. NetworkPolicy default-deny. Seccomp RuntimeDefault. Без hostPath |
| Service Mesh, mTLS | 05 | Istio или Linkerd, mTLS STRICT между всеми ML-сервисами |
| Мониторинг и drift | 06 | Evidently AI или WhyLabs. Drift-алерты в SOC |
| Incident Response | 06, 11 | IR-плейбук на 5 типов ML-инцидентов. SLA: P1=1ч, P2=4ч, P3=24ч |
| Vault, SOPS | 08 | Ноль секретов в коде. Ротация 90 дней. Audit device in Vault |
| IAM, RBAC | 08 | Keycloak или аналог, SSO, MFA для админов, PoLP, сервисные аккаунты с TTL <= 1ч |
| Threat Model | 09 | STRIDE-AI + методика ФСТЭК на каждый ML-продукт, ревизия раз в 6 месяцев |
| Agent Security | 10 | Sandbox, HITL на destructive-действия, scoped tokens, allowlist инструментов |
| Chatbot guardrails | 11 | Input-фильтры, output-фильтры, blacklist тем, rate limit, аудит |
| CI/CD security | 12 | Gate на каждом этапе, подпись артефактов, SBOM, DAST для LLM, fuzzing промптов |
| Red Teaming LLM | 07 | Garak + Promptfoo на регрессию, PyRIT на кампании, отчёт в квартал |
| LLM Gateway | 11, 13 | Rilio или аналог с DLP pre/post, kill-switch, аудитом, SIEM-экспортом |

---

<a id="71-peredaca-v-ekspluataziu-raci-i-pravo-ostanovki"></a>

### 7.1. Передача в эксплуатацию: RACI и право остановки

**Принцип**: технический оператор способен остановить риск в рамках заранее утверждённого runbook, а business owner принимает решение о полезности и остаточном риске. Подпись ИБ не делает ИБ владельцем бизнес-процесса.

Ниже пример RACI. `A` — один ответственный за итог строки, `R` — исполнитель, `C` — обязательная консультация, `I` — информирование. В небольшой компании роли совмещаются, но критичную self-approval компенсирует независимый review.

| Решение/процесс | Business owner | Data owner | Platform/operator | MLSec/валидатор | SOC/IR |
|---|---|---|---|---|---|
| Назначение и границы сценария | A/R | C | C | C | I |
| Разрешение источника и получателя данных | C | A/R | R | C | I |
| Исполнение контрольных тестов и заключение | C | C | R | A/R | C |
| Принятие остаточного риска и ограничений пилота | A/R | C | C | C | I |
| Эксплуатация, дежурство и технический отзыв | I | C | A/R | C | R |
| Координация активного инцидента | C | C | R | C | A/R |
| Возобновление после устранения блокировки | A/R | C | R | C | C |

При наличии Legal/Compliance их включают в применимые решения о данных, договорах, уведомлениях и retention. Закон не выводится из этой RACI: она задаёт внутренний порядок ответственности.

**Приёмка оператором:** найдены runbook и его версия, назначен заместитель, доступны необходимые права, выполнен остановочный drill, проверены revoke/readback и рабочий ручной маршрут. Критичный сценарий не принимается с контактом «общий чат команды» без дежурного и эскалации.

**Изменения после приёмки:** смена провайдера/fallback, расширение scopes, включение памяти, новый schedule, перенос tenant, update tool schema и изменение классификации данных попадают в change review. Оператор может технически применить конфигурацию, но не расширяет утверждённое назначение единолично. Практическая компетенция людей и передача роли — [21](21-people-process.md); agent operating/runtime — [32](32-ai-agents-operating-overlay.md), [34](34-ai-agents-runtime-procedure.md).

**Основа**: [NIST GOVERN 2.1–2.3](https://airc.nist.gov/airmf-resources/playbook/govern/) — ясные роли, обучение и ответственность руководства; [ISO/IEC 42001:2023](https://www.iso.org/standard/42001) — система менеджмента ИИ. Источники проверены 13.11.2026; таблица — адаптируемый operating model, не цитата стандарта и не сертификат соответствия.

---

<a id="8-tipicnye-osibki-vnedrenia"></a>

## 8. Типичные ошибки внедрения

1. Запрет без альтернативы. «Запретили ChatGPT». Через месяц все пользуются с личных почт через VPN. Нужен легальный канал с контролем.
2. Политика без enforcement. Красивая 40-страничная политика, но ни одного автоматического контроля. В реальных инцидентах документ не помогает.
3. Безопасность как финальный этап. Threat Model пишется на ревью релиза. Изменить архитектуру уже нельзя. Результат - формальная модель и реальные риски.
4. Игра в соответствие. Сертификаты есть, модель обучается на непроверенных данных с HuggingFace, никто не делает Red Teaming. Ложное чувство защищённости.
5. Поручение MLSec одной команде без ML-компетенций. Традиционный AppSec без ML-знаний не закроет data poisoning и model extraction.
6. Поручение MLSec ML-команде без ИБ. Получается локальный энтузиазм без интеграции с SOC, Vault, IAM.
7. Облачные LLM для всех задач. Стандартный контракт OpenAI/Anthropic не подходит для ПДн и КТ без дополнительных мер. Gateway + DLP обязательны.
8. Открытые векторные БД без ACL. Pgvector/Qdrant/Weaviate без per-tenant и per-document access-control. Утечка через RAG - типовой сценарий в 2025.
9. Промпты в коде. System prompt в репозитории с публичной видимостью. Поиск по GitHub выдаёт бизнес-логику и ограничения.
10. Логирование всего ввода без DLP. Секреты и ПДн из логов LLM утекают в SIEM, S3, логовые бакеты. DLP нужен и на логах.

---

<a id="9-kpi-i-metriki"></a>

## 9. KPI и метрики

Что отчитывать раз в месяц. Минимум, который позволяет видеть прогресс без погружения в детали.

| Категория | Метрика | Порог зрелости (уровень 2) |
|---|---|---|
| Покрытие | % ML-продуктов с Threat Model | >= 80% |
| Покрытие | % ML-образов с SBOM и подписью | >= 95% |
| Покрытие | % LLM-эндпоинтов через Gateway с DLP | >= 95% |
| Гигиена | Секреты в коммитах за месяц | 0 |
| Гигиена | Критичные CVE в прод-образах > 14 дней | 0 |
| Устойчивость | Прохождение Garak-дефолт-профиля | > 85% |
| Устойчивость | Кол-во успешных prompt injection в регрессе | 0 |
| Реагирование | MTTR для P1-инцидентов MLSec | <= 1ч |
| Реагирование | MTTD для аномалий в LLM-трафике | <= 15 минут |
| Затраты | Стоимость LLM-запроса на пользователя | отслеживается |
| Затраты | Доля shadow AI в трафике egress | < 5% |

<a id="kal_kulator-budjet-mlsec-programmy-po-ob_emu-ml-portfela"></a>

#### Калькулятор: бюджет MLSec-программы по объёму ML-портфеля

```widget:threshold-slider
{
  "id": "ch13-budget-calc",
  "title": "Бюджет программы MLSec → размер ML-портфеля",
  "description": "Учебная модель с условными формулами, не медианы рынка и не оценка стоимости для вашей компании. Реальный бюджет считают по сценариям, критичности, уже действующим контролям и трудозатратам; число моделей само по себе не определяет ROI.",
  "min": 1,
  "max": 100,
  "step": 1,
  "default": 10,
  "unit": " моделей",
  "axisLabel": "Количество ML-моделей в production",
  "tracks": [
    {
      "label": "Условный FTE-сценарий",
      "compute": "Math.max(0.5, 1 + Math.log(x) * 1.4)",
      "format": "fixed1",
      "tone": "info",
      "hint": "Формула 1 + 1.4 ln(N):10 моделей≈4.2FTE,50≈6.5,100≈7.4. Логарифм растёт медленнее линейной функции; это допущение об общей инфраструктуре, не норматив штата."
    },
    {
      "label": "Условный annual budget ($k)",
      "compute": "150 + x * 35",
      "format": "fixed1",
      "tone": "warn",
      "hint": "Сценарий 150+$35k на модель:10 моделей=$500k. Это отдельная формула расходов, не расчёт из FTE; зарплаты, налоги и инструменты здесь не разложены."
    },
    {
      "label": "Бюджет / условный revenue$200M (%)",
      "compute": "(150 + x * 35) / 1000 * 100 / 200",
      "format": "fixed2",
      "tone": "info",
      "hint": "Явно фиксированный знаменатель$200M:на 10 моделей 0.25%,на 100—1.825%. Это арифметика сценария, не отраслевая норма."
    }
  ],
  "regions": []
}
```

---

<a id="91-metriki-dejstvuusego-kontrola-i-operazionnyj-obzor"></a>

### 9.1. Метрики действующего контроля и операционный обзор

Число зарегистрированных endpoints и процент реально защищённых сценариев — разные показатели. Покрытие считается по явно заданному списку активных сценариев и наблюдаемым enforcement paths; слепые зоны показываются отдельно.

| Показатель | Числитель / знаменатель | Какое решение поддерживает |
|---|---|---|
| Полнота inventory | Сценарии с подтверждённым owner/data/action mapping / обнаруженные активные сценарии | Где нельзя назначить ответственного или оценить риск |
| Проверка enforcement | Пути с успешными positive+negative проверками / все заявленные пути сценария | Где продукт установлен, но обход или отказ ещё не проверены |
| Проверка отзыва | Сценарии с подтверждённым deny старой роли / сценарии, где нужен отзыв | Какие полномочия продолжают действовать после отключения |
| Операционная готовность | Сценарии с принятым runbook, дежурством и завершённым drill / сценарии в эксплуатации | Что нельзя передавать в штатную поддержку |
| Полезность пилота | Завершённые допустимые бизнес-задачи / сопоставимые задачи baseline/candidate | Имеет ли смысл продолжать rollout при текущих false positives |
| Change debt | Изменения scopes/model/data, не прошедшие затронутые проверки / обнаруженные изменения | Где прежнее разрешение больше не покрывает фактический сценарий |
| Reporting и triage | Время от сигнала пользователя до назначения owner; отдельно неизвестные timestamps | Где сигнал теряется, даже если detection dashboard работает |

Периодичность review назначается по критичности; отдельный событийный review нужен при инциденте, изменении получателей/полномочий и потере владельца. В обзор входят незавершённые проверки и просроченные исключения. Падение количества жалоб не трактуется как улучшение без проверки доступности reporting-канала и активной аудитории.

**Контрольная ситуация**: gateway показывает 100% трафика подключённого web-чата, но background connector ещё использует прямой token. В отчёте это «один проверенный путь и один незакрытый», а не «система защищена на 100%». Отдельно фиксируются план исправления, владелец и временное ограничение.

Эти показатели — рекомендуемый operating dashboard, а не обязательные нормативные проценты. Для общего мониторинга рисков и решения о продолжении эксплуатации см. [NIST MANAGE](https://airc.nist.gov/airmf-resources/playbook/manage/), для действий после deployment — [NCSC guidelines](https://www.ncsc.gov.uk/files/Guidelines-for-secure-AI-system-development.pdf); проверено 13.11.2026.

---

<a id="10-matriza-instrumentov-po-urovnam-dannyh"></a>

## 10. Матрица инструментов по уровням данных

Упрощённая матрица, с которой можно стартовать. Адаптируется под контур компании.

| Класс данных | Можно обрабатывать в... | Нельзя |
|---|---|---|
| Public (маркетинг, публичные релизы) | Любые облачные и локальные LLM | - |
| Internal (внутренние документы, код, переписка) | Только локальные модели (Ollama, vLLM) и облачные через sanitizing LLM Gateway с DLP и политикой удержания запросов | Прямые API-ключи пользователей к OpenAI/Anthropic |
| Confidential (ПДн клиентов, КТ, финмодели, пароли) | Только локальные модели в контуре + Gateway. Облачные - только через прокси после согласованной редактуры (PII-mask, де-персонализация) | Отправка «как есть» в облачные LLM, включая отечественные, без оценки рисков |
| Restricted (гостайна, банковская тайна, данные СЗИ) | Изолированный контур, локальные модели. Облачные запрещены | Любой egress, в том числе через прокси |

Важное замечание про отечественные облачные LLM. GigaChat, YandexGPT, Cotype формально размещаются в РФ. Это снимает часть рисков (трансгранзация), но не снимает KT и коммерческую тайну автоматически. Отдельный договор с поставщиком, SLA, положение о неучёбе на ваших данных, аудит - обязательны.

---

<a id="11-rilio-gotovaa-platforma-mlsec-i-variant-autstafa"></a>

## 11. Rilio. Готовая платформа MLSec и вариант аутстафа

В разделе 5 показано, что критический контур MLSec проходит через LLM Gateway. Это место, где сходятся DLP, kill-switch, аудит, наблюдаемость, guardrails, бюджетирование и соответствие. Построить такую точку с нуля - 4-8 месяцев работы команды из 3-5 человек.

Rilio - это готовый self-hosted LLM Firewall & Proxy, который закрывает эту роль. Решение построено как open-source-совместимый контур, полностью разворачивается в периметре заказчика (Docker Compose, Kubernetes Helm), работает с локальными и облачными моделями, имеет OpenAI-совместимый API.

<a id="111-cto-zakryvaet-rilio"></a>

### 11.1. Что закрывает Rilio

| Функция | Как это в Rilio |
|---|---|
| LLM Gateway | OpenAI-совместимый `/v1/chat/completions`, мультипровайдерная маршрутизация, fallback, стриминг SSE |
| DLP на входе и выходе | Многоуровневый движок: Regex + Luhn/ИНН-валидаторы, Go DLP (~100 мкс), Presidio NER, Semantic Guard, LLM Guard, опционально Lakera Guard |
| Российские ПДн | Правила под паспорт, ИНН, СНИЛС, телефон, адрес, номер карты, банковская тайна |
| Prompt Injection защита | Паттерны jailbreak, SQL-инъекции в контексте, семантический фильтр |
| Anti-EchoLeak | Защита от класса атак эксфильтрации через markdown-изображения/ссылки (по мотивам EchoLeak, CVE-2025-32711 в M365 Copilot): блок внешних URL в markdown-изображениях, защита от эксфильтрации через ответы |
| Unicode bypass prevention | NFKC-нормализация, удаление zero-width / invisible chars |
| Streaming DLP | Сканирование чанков в реальном времени, редактура секретов по ходу ответа |
| Kill-Switch | 5 уровней: L0 (глобальный стоп), L1 (пользователь), L2 (модель), L3 (облачный egress), L4 (агент) |
| Бюджет и cost attribution | По пользователю, команде, модели, проекту. Прогноз израсходования |
| Агентская платформа | Registry агентов, step-level трейсинг, HITL-очередь, kill-switch на агента, webhooks |
| Аудит и комплаенс | Structured logs, HMAC-подписанные записи, экспорт в SIEM (CEF, syslog), compliance-отчёты |
| Наблюдаемость | Prometheus, Grafana, WebSocket live feed, Loki-совместимые логи |
| RBAC и SSO | 5+ ролей, JWT, API keys, OIDC (Keycloak) |
| Поддержка провайдеров | OpenAI, Anthropic, Google, DeepSeek, Qwen, Ollama, LM Studio, GigaChat |
| Developer Experience | Установочный скрипт, совместимость с Claude CLI, Cursor, Codex, Aider, Continue, Cline, Windsurf, Copilot, Playground для тестов |

<a id="112-gde-rilio-zakryvaet-probely-metodiki"></a>

### 11.2. Где Rilio закрывает пробелы методики

Ссылки на главы в левой колонке соответствуют документам 01-12.

| Требование методики | Реализация в Rilio |
|---|---|
| Gateway с DLP (12) | DLP pre-call и post-call, 6-layer engine |
| Kill-switch (06) | 5 уровней, admin-only, полный audit-log |
| Guardrails для агентов (10) | HITL-очередь, allowlist инструментов, agent budget, per-run kill |
| IR для LLM-инцидентов (06, 11) | SIEM-экспорт, webhook-нотификации, журнал событий, dashboard алертов |
| Аудит и логирование (08) | HMAC-подписи, экспорт CEF/syslog, retention по политике |
| Бюджетирование (22) | 80% warning, 100% block, прогноз и аномалия-детекция |
| Shadow AI (13/14) | Network enforcement: PAC + DNS + firewall-правила на egress |
| RBAC и SSO (08) | 5+ ролей, OIDC/Keycloak, MFA |
| Технические меры для задач защиты ПДн | Локальное развёртывание, DLP по ру-ПДн, логи в контуре; сами по себе не подтверждают выполнение всех требований 152-ФЗ |

<a id="113-varianty-ispol_zovania"></a>

### 11.3. Варианты использования

1. Self-hosted. Разворачивается в контуре заказчика за 5-15 минут (Docker Compose) или через Helm в Kubernetes. Полный контроль, без vendor lock-in. Подходит для компаний, у которых есть DevOps-ресурс.
2. Self-hosted + платная поддержка. Установка, настройка политик, интеграция с SIEM/Vault/Keycloak, обучение команды. Годовой контракт.
3. Аутстаф MLSec под ключ. Команда MLSec-инженеров на стороне Rilio берёт на себя выстраивание MLSec-процесса целиком: инвентаризация, классификация, threat modeling, CI/CD-gate-ы, Red Teaming, SOC-интеграция, IR-плейбуки, отчётность. Подходит компаниям, у которых есть понимание ценности MLSec, но нет людей, и нанимать свою команду на 1-2 года раньше, чем развернётся продукт, невыгодно.

Важное. Rilio покрывает LLM-контур (точки 5 раздела «Эталонная архитектура», связанные с Gateway и агентами). Классические ML-системы (антифрод, скоринг, CV), Model Registry, SAST, SIEM - остаются за инструментами из разделов 4-6. Rilio интегрируется с ними (экспорт логов, Prometheus-метрики, OIDC), но не заменяет их.

---

<a id="12-szenarii-vnedrenia-po-otraslam"></a>

## 12. Сценарии внедрения по отраслям

<a id="121-bank-nfo-strahovaa"></a>

### 12.1. Банк, НФО, страховая

- Подход ЦБ к AI как к источнику операционного риска. Учёт ML-систем в реестре критических процессов, аутсорсинг AI-сервисов по положению 850-П (ранее 787-П).
- Запрет передачи банковской тайны и данных по транзакциям в зарубежные облака. Gateway + DLP + локальные модели для внутренних задач.
- Для AI-ассистентов для клиентов - обязательный human-in-the-loop на финансовых решениях.

<a id="122-ritejl-i-e-commerce"></a>

### 12.2. Ритейл и e-commerce

- Shadow AI у разработчиков и маркетологов. Gateway + DLP снижает часть рисков на наблюдаемых путях; конкретное покрытие подтверждается проверками обхода и полезности, а не универсальными «80%».
- Персонализация на ML: внимание к membership inference и privacy. Differential privacy и per-tenant изоляция в векторных БД.
- Чат-бот с возвратами и скидками. Guardrails на «выдать скидку 100%», HITL на суммы выше лимита.

<a id="123-promyslennost_-asu-tp"></a>

### 12.3. Промышленность, АСУ ТП

- Применимость 31-го приказа ФСТЭК, ПП 127 и режима КИИ определяется для конкретной АСУ ТП/субъекта. Сам факт ML в промышленности не присваивает категорию значимости; требования к контуру фиксируются после оценки, см. главу 18.
- CV для контроля качества и безопасности труда. Adversarial robustness - критично.
- Predictive maintenance. Атаки на model skewing через подделку телеметрии с датчиков.

<a id="124-gossektor-i-kontury-fstek-117-ranee-17"></a>

### 12.4. Госсектор и контуры ФСТЭК 117 (ранее 17)

- Только on-premise, сертифицированные СЗИ, реестр отечественного ПО.
- Локальные модели, изолированный контур. Gateway, SIEM, WAF - из реестра.
- Отдельная модель угроз по методике ФСТЭК, формальные АМБ и технический паспорт.

<a id="125-telekom"></a>

### 12.5. Телеком

- Большие объёмы абонентских данных. Фокус на минимизации и анонимизации.
- Чат-боты поддержки - топовый источник prompt injection и утечек.
- RAG на биллинг - требует per-user авторизации на уровне вектора, не только на уровне запроса.

<a id="kakoj-otraslevoj-szenarij-vnedrenia-u-vas"></a>

#### Какой отраслевой сценарий внедрения у вас

```widget:decision-tree
{
  "id": "ch13-industry-scenario",
  "title": "Подбор стратегии внедрения MLSec под вашу отрасль",
  "start": "q1",
  "nodes": {
    "q1": {
      "type": "question",
      "text": "В какой отрасли работает ваша организация?",
      "sub": "Отрасль помогает найти применимые вопросы. Разрешённый стек, УЗ, категория КИИ и обязанности устанавливаются по конкретной системе, данным, роли и цели, а не одним названием организации.",
      "choices": [
        { "label": "Банк / НФО / страховая (финсектор)", "next": "leaf-finance" },
        { "label": "Ритейл / e-commerce / маркетплейс", "next": "leaf-retail" },
        { "label": "Промышленность / производство / АСУ ТП", "next": "leaf-industrial" },
        { "label": "Госсектор / госзакупки / гос-АИС", "next": "leaf-gov" },
        { "label": "Телеком / интернет-провайдер", "next": "leaf-telecom" },
        { "label": "Медицина / Healthtech", "next": "leaf-medicine" },
        { "label": "Стартап без специфичной регуляции", "next": "leaf-startup" }
      ]
    },
    "leaf-finance": {
      "type": "leaf",
      "tone": "err",
      "title": "Финсектор: операционные риски, надёжность, ПДн и применимость КИИ",
      "summary": "Разделите операционный риск, внутренний MRM, ПДн/тайны, допустимость решений и применимость КИИ. У каждого режима свои основания и владельцы.",
      "details": [
        "Внутренний реестр систем, Tier, независимый review и MRC — выбранная программа; не приписывать все элементы 716-П автоматически",
        "Маршрут банковской тайны/ПДн проверяется по получателям, основаниям, копиям и договору; локальный бренд провайдера сам по себе не даёт допуска",
        "Для выбранных операций — currentACL, transaction/approval binding, лимиты и независимый readback; two-person rule определяется политикой",
        "Обязанности уведомления и начало отсчёта — по объекту/событию главы 18"
      ],
      "links": [
        { "label": "Глава 14. Model Risk Governance", "href": "/ch/14-model-risk-governance" },
        { "label": "Глава 18. Российский compliance", "href": "/ch/18-ru-compliance-deep" }
      ]
    },
    "leaf-retail": {
      "type": "leaf",
      "tone": "warn",
      "title": "Ритейл: фокус на Shadow AI + защиту чат-ботов",
      "summary": "Проверьте реальные потоки разработчиков, маркетинга, поддержки и возвратов. Масштаб клиентских данных и доступ к платежам важнее общей оценки «умеренная регуляция».",
      "details": [
        "AI Use Policy и разрешённый маршрут проверяются на обходы и полезность",
        "Approval для возврата/скидки назначается по сумме, получателю и действующим правилам, а не универсальным $50",
        "Tenant/object ACL для retrieval/cache; отдельные проверки разрешённой покупки/возврата и запрещённого чужого объекта",
        "При ПДн определить применимость норм, категории, угрозы и УЗ; типичного автоматического УЗ 3 из отрасли нет"
      ],
      "links": [
        { "label": "Глава 24. Vector DB Security", "href": "/ch/24-vector-db-security" }
      ]
    },
    "leaf-industrial": {
      "type": "leaf",
      "tone": "err",
      "title": "Промышленность: 31-й приказ ФСТЭК + 187-ФЗ КИИ",
      "summary": "Определить применимость требований к АСУ ТП и КИИ. Наличие ML не означает автоматическую категорию значимости; меры выбираются для конкретного объекта.",
      "details": [
        "Проверить статус субъекта/объекта, категорирование и применимые меры; изолировать управляющие действия согласно модели угроз",
        "CV для quality / safety: adversarial robustness критична — атака на distinguisher = пропуск брака",
        "Predictive maintenance: защита телеметрии от model skewing (signed sensor data)",
        "Уведомления и оценка соответствия определяются применимым режимом объекта и обстоятельствами инцидента; проверить матрицу главы 18"
      ]
    },
    "leaf-gov": {
      "type": "leaf",
      "tone": "err",
      "title": "Госсектор: 117-й приказ ФСТЭК (ранее 17-й) + реестр отечественного ПО",
      "summary": "Определить вид системы, оператора, применимые требования защиты и закупки. Один ярлык «госсектор» не означает универсальное on-prem, сертификат или перечень разрешённых моделей.",
      "details": [
        "Сверить актуальный текст применимого акта и переходные положения; непроверенные детали 117/137 не выдавать за установленную норму",
        "Обосновать требования к системе, средствам защиты и конкретным исполнениям/сертификатам",
        "Проверить реестр ПО и закупочные ограничения для конкретной процедуры, а не считать любой локальный бренд допущенным",
        "Назначить владельца применимости, evidence мер и проверок разрешённых/запрещённых действий"
      ]
    },
    "leaf-telecom": {
      "type": "leaf",
      "tone": "warn",
      "title": "Телеком: фокус на минимизацию + per-user авторизацию",
      "summary": "Большие объёмы абонентских данных. RAG на биллинг — типичный случай требующий per-user ACL на уровне вектора.",
      "details": [
        "Минимизация до векторизации; токенизация не доказывает прекращения режимаПДн",
        "Support-бот: session/object authorization, attachments и недоверенный контент",
        "Биллинг: currentACL на retrieval/cache, transaction binding для изменения услуг",
        "Отраслевые требования связи, тайна сообщений и обязанности взаимодействия проверяются отдельно; «лицензия СОРМ» не используется как универсальный AI-контроль"
      ]
    },
    "leaf-medicine": {
      "type": "leaf",
      "tone": "err",
      "title": "Медицина: врачебная тайна, ПДн и применимость биометрического режима",
      "summary": "По составу данных и цели обработки проверить врачебную тайну по 323-ФЗ и категории ПДн по 152-ФЗ. Биометрическая идентификация, применимость 572-ФЗ/ЕБС, УЗ и состав мер требуют отдельной оценки сценария; отрасль сама их не назначает.",
      "details": [
        "Оценить риски и применимость обязательной оценки воздействия до обработки реальных медицинских данных",
        "DP и её параметры выбирать по методике и utility/privacy требованиям; универсального нормативного ε здесь не задано",
        "Разделить медицинские данные и биометрию для идентификации; применимость режима ЕБС оценить отдельно",
        "Проверить статус медицинского изделия и требования юрисдикции; FDA/HIPAA не считать прямыми аналогами российского режима",
        "Определить УЗ и состав мер по применимым условиям, а не только факту специальной категории ПДн"
      ],
      "links": [
        { "label": "Глава 17. PET", "href": "/ch/17-privacy-enhancing-tech" }
      ]
    },
    "leaf-startup": {
      "type": "leaf",
      "tone": "info",
      "title": "Стартап: lightweight программа",
      "summary": "Небольшая команда может начать с компактной программы по фактическому риску. Размер не откладывает правовые основания и контроль данных до роста бизнеса.",
      "details": [
        "Владелец, сценарий, данные, получатели и допустимые действия до начала пилота",
        "Минимальные credentials, проверяемый маршрут и остановка/отзыв на безопасных данных",
        "Применимость ПДн/отраслевых норм и договоров проверить до обработки, а не после появления enterprise-клиента",
        "Глубина MRM/evaluation соразмерна последствиям; рост scope требует повторного review"
      ]
    }
  }
}
```

---

<a id="13-osibki-kotorye-lomaut-programmu-mlsec-zelikom"></a>

## 13. Ошибки, которые ломают программу MLSec целиком

1. «Сделаем всё сами за 3 месяца». Сначала зафиксируйте baseline и scope пилота, владельцев и проверяемые milestones. 90 дней или год — примеры плановых окон; достижение уровня зрелости подтверждают evidence контролей, а не календарь.
2. «MLSec = ещё один сканер». Без процессов (IR, Red Teaming, ревью моделей, gate-ов) инструменты не работают.
3. «Купим продукт и всё закроем». Даже лучший продукт без ролевой модели, SLA и ответственных - это ящик на полке.
4. «ИБ стопит ML». Ставьте ИБ в роль соавтора. Участие ИБ в design review с первого дня снижает количество переделок.
5. Отсутствие owner-а MLSec. Должен быть один ответственный с мандатом. Не виртуальная команда на волонтёрских началах.
6. Игнорирование юридического трека. ПДн, КТ, контракты с вендорами LLM, SLA на доступность - это не «потом».

<a id="programmnye-provaly-mlsec-spravocnik-dla-ciso"></a>

#### Программные провалы MLSec — справочник для CISO

```widget:flashcards
{
  "id": "ch13-program-failures",
  "title": "10 программных ошибок, которые ломают MLSec целиком",
  "description": "Учебные сценарии программных ошибок. Анонимные кейсы и числовые иллюстрации не являются опубликованным исследованием российских enterprise; используйте их для разбора процесса, а не как статистику эффекта.",
  "shuffle": false,
  "cards": [
    {
      "tag": "scope · timing",
      "front": "«Сделаем всё за 3 месяца»",
      "subFront": "Over-commit",
      "back": "Учебный сценарий: команда обещает внедрить всё за квартал, но несколько направлений остаются незавершёнными и без проверенного evidence.\n\nFix: owner программы фиксирует inventory и baseline, выбирает ограниченный пилот и release-critical контроли, назначает владельцев и критерии завершения. Срок согласуют с доступной командой, зависимостями и проверкой результата; 90 дней или год — внутренние плановые окна, не гарантированный переход L1→L2→L3. Пересмотр плана — по подтверждённым milestones, failed/pending проверкам и изменениям scope, а не по календарю зрелости."
    },
    {
      "tag": "tooling-only",
      "front": "«Купили SIEM/Sigstore — закрыли MLSec»",
      "subFront": "Tools без процессов",
      "back": "Учебный сценарий: SIEM и подписи внедрены, но никто не проверял обработку alert, запрет неразрешённого deploy и восстановление.\n\nFix: у каждого инструмента назначить control owner, входные данные и проверяемый outcome. Выполнить разрешённый и запрещённый сценарии, потерю telemetry и recovery; сохранить версии, status и evidence. Баланс затрат на tools, процессы и людей определяют по выявленным пробелам и workload; универсальной доли «tools = 30% программы» нет."
    },
    {
      "tag": "ownership",
      "front": "«MLSec — задача всей компании»",
      "subFront": "Размазанная ответственность",
      "back": "Симптом: за compliance-аудитом никто не отвечает; «это AppSec», «это ML team», «это compliance»…\n\nFix: один MLSec Owner с мандатом и budget'ом. Не виртуальная команда. RACI-матрица с подписью CISO."
    },
    {
      "tag": "blocker",
      "front": "«ИБ стопит все ML-проекты»",
      "subFront": "Adversarial relationship",
      "back": "Симптом: ML-команда обходит ИБ через shadow AI; ML-проекты задерживаются на security-review месяцами.\n\nFix: ИБ — соавтор архитектуры с дня 1. Threat Model на design-фазе сокращает rework на 60%. Quick-win paths для скорости + deep review для критики."
    },
    {
      "tag": "shadow",
      "front": "«Запретили cloud LLM — никто не пользуется»",
      "subFront": "Запрет без альтернативы",
      "back": "Симптом: год спустя egress-логи показывают, что 40% разработчиков используют ChatGPT через personal accounts.\n\nFix: AI Use Policy с разрешённым списком + Gateway с DLP-прокси для cloud-моделей. Запрет без alternative = shadow AI гарантировано."
    },
    {
      "tag": "regulator",
      "front": "«152-ФЗ потом разберёмся»",
      "subFront": "Откладывание legal",
      "back": "Учебный сценарий: после инцидента команда не показывает цели, основания, роли и решение о допуске. Отсутствие документа с названием DPIA не означает автоматически нарушение 152-ФЗ или «30 дней штрафов».\n\nFix: Legal и Data Owner до обработки определяют применимые обязанности и оценку вреда; DPIA по GDPR Art. 35 — при его условиях, FRIA по Art. 27 AI Act — отдельно. Договор с поставщиком связывает поручение, цели, доступ, reuse, регионы и уведомление оператора. No-train clause и data residency не заменяют остальные основания; сохранить data-flow, решение и evidence мер."
    },
    {
      "tag": "tier-creep",
      "front": "«Все модели стали Tier-1»",
      "subFront": "Tier inflation",
      "back": "Симптом: чтобы получить «approval», команды объявляют все модели Tier-1; программа MRM перегружена; реальные Tier-1 теряются в шуме.\n\nFix: формальные критерии Tier (data class × decision impact × volume); MRC ревью с возможностью downgrade."
    },
    {
      "tag": "red team",
      "front": "«Red team раз в год — достаточно»",
      "subFront": "Stale assessments",
      "back": "Симптом: между annual red-team отчётами выходят новые техники (Crescendo, Skeleton Key) — текущая защита не покрывает.\n\nFix: continuous automated red team (PyRIT / Garak в CI); external — раз в 6 мес для Tier-1, раз в год для Tier-2."
    },
    {
      "tag": "training",
      "front": "«Security training — это для AppSec»",
      "subFront": "ML-команда не умеет MLSec",
      "back": "Симптом: ML-инженеры не знают про prompt injection, MIA, model extraction; security-control'ы саботируются по неведению.\n\nFix: обязательный MLSec onboarding для всех ML/DS-инженеров; quarterly refresh; включить в performance review."
    },
    {
      "tag": "metrics",
      "front": "«Не отчитываемся — будет тишина»",
      "subFront": "Невидимая программа",
      "back": "Учебный сценарий: руководство не видит scope программы, открытые риски и результаты проверок; решение о ресурсах принимается без evidence.\n\nFix: owner согласует формат и cadence отчётности — например, краткая ежемесячная сводка и review руководством по значимому изменению. Показывать inventory/release scope, выполненные и pending проверки, критичные findings, сроки containment/recovery, фактические затраты и следующий шаг. «Предотвращённые инциденты × цена» — контрфактический сценарный расчёт с допущениями и диапазоном, не наблюдённая прибыль или доказанный ROI. Не подменять снижение риска уменьшением числа зарегистрированных сигналов."
    }
  ]
}
```

---

<a id="14-cto-doljno-lejat_-na-stole-u-ciso-cerez-god"></a>

## 14. Что должно лежать на столе у CISO через год

1. Утверждённая политика AI и MLSec, с привязкой к 152-ФЗ, ЦБ РФ (для финансов), ФСТЭК (для КИИ).
2. Реестр ML-активов и карта зрелости. Оценка раз в полгода.
3. LLM Gateway (Rilio или аналог) с 100% покрытием egress, DLP pre/post, kill-switch, SIEM-экспорт.
4. Model Registry с подписанием и Model Card.
5. Threat model и IR-плейбуки на ключевые ML-продукты.
6. CI/CD MLSec-gate. Автоматические проверки, без которых merge/deploy невозможны.
7. Отчёт Red Teaming за квартал. Метрики, дефекты, трек исправлений.
8. KPI из раздела 9, защищённые перед правлением.
9. Программа обучения. Разработчики, ML/DS, поддержка, бизнес-юниты.
10. План на следующий год с приоритетами и бюджетом.

---

<a id="15-svaz_-s-drugimi-dokumentami-repozitoria"></a>

## 15. Связь с другими документами репозитория

| Тема | Документ |
|---|---|
| Архитектура и принципы | [01](01-overview-architecture.md) |
| System Design review | [02](02-stage0-ml-system-design.md) |
| Данные, PII, качество | [03](03-stage1-data-operations.md) |
| Разработка моделей и SAST/SCA | [04](04-stage2-model-operations.md) |
| Развёртывание и K8s | [05](05-stage3-model-deployment.md) |
| Эксплуатация, мониторинг, IR | [06](06-stage4-operations-platform.md) |
| Red Teaming | [07](07-red-teaming-testing-methods.md) |
| Секреты и доступ | [08](08-access-secrets-management.md) |
| Threat Modeling | [09](09-threat-modeling.md) |
| LLM-агенты | [10](10-llm-agent-protection.md) |
| Чат-боты | [11](11-chatbot-conversational-security.md) |
| CI/CD и защита LLM | [12](12-detection-protection-cicd-llm.md) |

---

<a id="16-itog"></a>

## 16. Итог

MLSec в российской компании в 2026 году - это не отдельный продукт и не «секция» в политике ИБ. Это сквозная практика, которая начинается с инвентаризации и классификации и заканчивается автоматизированным Red Teaming в CI. В центре контура практически всегда стоит LLM Gateway с DLP, kill-switch и аудитом. Именно он закрывает самые болезненные риски (утечка ПДн и КТ, shadow AI, prompt injection, unbounded consumption) и становится точкой, с которой имеет смысл начинать.

Если команды MLSec у вас нет, а собрать её за квартал нереально, Rilio закрывает роль Gateway продуктово, а в режиме аутстафа - роль всей команды MLSec под конкретные цели и SLA. Это экономит 6-12 месяцев калибровки и снимает риск «красивый документ, нулевой enforcement».


---

<a id="interaktivnye-szenarii-vnedrenia"></a>

## Интерактивные сценарии внедрения

<a id="szenarij-1-start-mlsec-v-banke-iz-top-30-s-nula"></a>

### Сценарий 1. Старт MLSec в банке из топ-30 с нуля

```widget:attack-stepper
{
  "title": "Первые 90 дней MLSec в банке",
  "steps": [
    {
      "title": "День 1-7: Инвентаризация",
      "actor": "CISO + ML Lead",
      "action": "Для учебного пилота соберите реестр ML/AI-сценариев, владельцев и фактических data/action flows; добавьте SaaS, IDE, фоновые агенты и shadow use cases.",
      "defense": "Сочетать согласованные опросы и доступные client/proxy/network receipts. DNS может быть неполным, особенно при VPN; домен не устанавливает пользователя или цель обработки."
    },
    {
      "title": "День 8-30: Classification и Tier",
      "actor": "AI Risk",
      "action": "Каждой системе присвойте Tier 1-4 (влияние на клиента/финансы/регулятора) и классификацию данных K0-K4.",
      "defense": "Tier/K — внутренние оси методики. Применимость конкретных норм определяется отдельно; 716-П не назначает универсальный AI Tier или уровень защиты."
    },
    {
      "title": "День 31-60: Gateway deployment",
      "actor": "Platform + SecOps",
      "action": "Выбрать совместимые допущенные клиент/API-маршруты через gateway. Проверить модели, authentication, streaming, tools, файлы и режимы отказа; для несовместимого клиента требуется другой согласованный маршрут.",
      "defense": "Положительный тест полезного сценария и отрицательные direct/fallback/child routes на фактических egress controls. DNS/PAC/CA и один gateway-IP сами по себе не доказывают охват всего обращения."
    },
    {
      "title": "День 61-75: AI Use Policy",
      "actor": "Compliance + HR",
      "action": "Опубликуйте AI Use Policy: что можно/нельзя, классификация данных, обязательное обучение для всех пользователей LLM.",
      "defense": "Политика и LMS — свидетельства процесса, но не доказательство runtime enforcement или компетентности. Проверить практические действия по ролям, reporting и текущие ограничения данных."
    },
    {
      "title": "День 76-90: Red Team + Report",
      "actor": "Red Team + CISO",
      "action": "Проведите базовый Red Team по OWASP LLM Top 10. Итоги в Совет директоров с планом на следующий квартал.",
      "defense": "В отчёте разделить выполненные проверки, unknown/not_run и принятые ограничения; отдельно показать transport, content/control, эксплуатацию и бизнес-пользу на сопоставимом baseline."
    }
  ]
}
```

```widget:quiz
{"id": "ch13-q1", "question": "В банке только начинается программа MLSec. Как выбрать первый пакет действий без обещания «закрыть риск за 30 дней»?", "options": ["Назначить owner и сценарий, сдержать подтверждённые опасные потоки, проверить маршрут/gateway/DLP на ограниченном пилоте и параллельно установить governance процесса", "Ждать полного MRM, не ограничивая обнаруженную утечку", "Купить gateway и считать все данные защищёнными", "Запустить активный red team всех production-сервисов без scope"], "answer": 0, "explanation": "Первые действия зависят от наблюдаемого риска. Gateway/DLP может быть частью пилота, но не гарантирует устранение утечки за фиксированный срок. Реестр, owner и критерии допуска задаются сразу; рабочий MRM не обязательно ждать 6–12 месяцев."}
```

<a id="szenarij-2-migrazia-ot-shadow-ai-k-kontroliruemoj-gateway-arhitekture"></a>

### Сценарий 2. Миграция от shadow AI к контролируемой Gateway-архитектуре

```widget:attack-stepper
{
  "title": "Ликвидация shadow AI без блокирования бизнеса",
  "steps": [
    {
      "title": "Discovery",
      "actor": "SecOps",
      "action": "В условном примере опрос и разрешённая telemetry показывают use cases разных сотрудников; числа 47/12/3 иллюстративны. Одни DNS/proxy-логи не позволяют достоверно разобрать назначения внутри зашифрованного VPN.",
      "defense": "Зафиксировать видимость, пропуски и цель сбора; минимизировать данные. Discovery не является доказательством намерения нарушить политику."
    },
    {
      "title": "Выявление use cases",
      "actor": "Product + AI Risk",
      "action": "Интервью с топ-10 пользователями: что именно делают? Саммаризация документов, ревью кода, перевод.",
      "defense": "Список use cases для легитимного enterprise LLM."
    },
    {
      "title": "Rollout Gateway с allow-list",
      "actor": "Platform",
      "action": "Запустить отдельно допущенные модели и маршруты с совместимым клиентом. Новый endpoint нельзя автоматически подставить в любой браузерный SaaS или закрытый SDK.",
      "defense": "Проверить SSO, текущие grants, DLP и минимизированные decision/usage receipts. «Логирование 100%» не означает хранение всех prompts или отсутствие слепых маршрутов."
    },
    {
      "title": "Блокировка shadow",
      "actor": "SecOps",
      "action": "Применить согласованные egress/endpoint restrictions и объяснить пользователям рабочую альтернативу. Нельзя считать HTTPS redirect/DNS-подмену прозрачной совместимостью с чужим API или отключать проверку сертификатов ради такого перенаправления.",
      "defense": "Проверить direct/provider fallback, CLI/MCP/background и разрешённый рабочий сценарий. Доменный список обновляется по фактическим маршрутам и не является вечной гарантией отсутствия обхода."
    },
    {
      "title": "Communication + training",
      "actor": "HR + CISO",
      "action": "Email всем сотрудникам: 'shadow AI отключён, используйте <внутренний URL>'. Обучающий webinar.",
      "defense": "Проверить понятность процесса, реальную доступность разрешённого use case и reporting проблем. Согласие с политикой не гарантирует принятие пользователями или отсутствие обходов."
    }
  ]
}
```

```widget:quiz
{"id": "ch13-q2", "question": "Вы обнаружили shadow AI в компании (сотрудники используют ChatGPT напрямую). Что корректно в первую неделю?", "options": ["Всегда одинаково заблокировать все LLM независимо от данных и последствий", "Исследовать реальные потоки и потребности, ограничить подтверждённый опасный scope без ожидания альтернативы, предложить согласованный маршрут и проверить обходы", "Уволить пользователей без расследования", "Отложить любые меры до покупки корпоративного продукта"], "answer": 1, "explanation": "Discovery и change management помогают выбрать полезный допустимый маршрут. При инциденте или подтверждённом риске containment не должен ждать готовой альтернативы. Масштаб ограничений и восстановления выбирается по данным, эффектам и текущим правам."}
```

<a id="s-cego-nacat_-po-vasej-roli-rossijskij-kontekst"></a>

## С чего начать по вашей роли (российский контекст)

<a id="ciso"></a>

### CISO

| Горизонт | Действия |
|----------|----------|
| День 1 | Инвентаризация ML/AI (использование LLM в бизнесе, shadow AI, регуляторные риски). Назначение AI Risk Owner. |
| Неделя 1 | Roadmap MLSec на 90 дней для Совета директоров. Бюджет (ориентиры: 10-30М ₽ для среднего банка на Gateway + DLP + SOC rules). |
| Месяц 1 | Gateway запущен, DLP baseline собран, первый отчёт в Совет. AI Use Policy опубликована. |

<a id="ai-risk-mrm-owner"></a>

### AI Risk / MRM Owner

| Горизонт | Действия |
|----------|----------|
| День 1 | Реестр моделей с классификацией по влиянию. Для финансовых моделей мэппинг на ЦБ 716-П / 850-П (ранее 787-П). |
| Неделя 1 | Методика валидации моделей (независимая команда). Стандартные метрики: discrimination, stability, concept drift. |
| Месяц 1 | Первая независимая валидация топ-3 критичных моделей. Квартальный отчёт в Правление. |

<a id="urist"></a>

### Юрист

| Горизонт | Действия |
|----------|----------|
| День 1 | Инвентаризация обработки ПДн в LLM (входящие промпты, fine-tune датасеты, RAG-источники). |
| Неделя 1 | Обновление политики ПДн. Трансграничная передача по 152-ФЗ (если используется OpenAI/Anthropic). Уведомление в РКН. |
| Месяц 1 | DPIA для каждой высокорисковой LLM-системы. DSR-процесс для пользователей бота. |

<a id="head-of-compliance"></a>

### Head of Compliance

| Горизонт | Действия |
|----------|----------|
| День 1 | Мэппинг LLM-рисков на существующие политики (ОПК, ИБ, комплаенс). Gap analysis. |
| Неделя 1 | Контрольные процедуры внутри: approval new AI use cases, quarterly re-certification, external audit readiness. |
| Месяц 1 | Обновлённые политики согласованы с юристами и управлением делами. Подписаны CEO. |

<a id="platform-devsecops-lead"></a>

### Platform / DevSecOps Lead

| Горизонт | Действия |
|----------|----------|
| День 1 | Gateway (Rilio) в staging. Подключение к Keycloak, Vault. Network policy deny-all + allowlist к LLM-провайдерам. |
| Неделя 1 | DLP слой 0-3 активен. Rate-limit по ролям. Audit-лог в SIEM. |
| Месяц 1 | Prod rollout с canary. SLO: p99 latency < 500мс, 99.9% uptime. Kill-switch dry run. |

<a id="secops-soc-manager"></a>

### SecOps / SOC Manager

| Горизонт | Действия |
|----------|----------|
| День 1 | Sigma/KUMA правила для детекции: prompt injection, DLP hits, rate-limit breach, kill-switch triggers. |
| Неделя 1 | Runbook incident response для LLM (preserve context, revoke sessions, notify Юрист и ЦБ). |
| Месяц 1 | Tabletop exercise: утечка ПДн через бота. Dry-run ГосСОПКА-уведомления. |

<a id="product-owner-linia-biznesa"></a>

### Product Owner (линия бизнеса)

| Горизонт | Действия |
|----------|----------|
| День 1 | Список use cases AI в вашем продукте. Оценка Tier (1-4) и Data class (K0-K4). |
| Неделя 1 | User journey с disclaimer и HITL на критичных шагах. Согласие на обработку ПДн в UI. |
| Месяц 1 | Метрики качества и безопасности в дашборде. Квартальное ревью с AI Risk. |

```widget:quiz
{"id": "ch13-q3", "question": "Банк установил событие по ч.3.1 ст.21 152-ФЗ при утечке через бота. Что делать в первые 24 часа?", "options": ["Сначала закончить расследование и только потом оценить уведомление", "Параллельно сдержать затронутый scope, сохранить необходимые evidence, подключить IR/юриста и направить РКН первичное уведомление в установленный срок; другие адресаты проверяются отдельно", "Уволить разработчика вместо containment", "Исправить код без фиксации инцидента"], "answer": 1, "explanation": "Сроки 24/72 часа для РКН имеют один установленный законом момент выявления. Выбор L0/L1/L2/L4 зависит от реального scope, а не названия «бот». Сохранение evidence не должно задерживать containment; обязанности НКЦКИ/ЦБ определяются отдельно по главе 18."}
```

```widget:quiz
{"id": "ch13-q4", "question": "Startup из 20 человек хочет внедрить LLM в продукт без MLSec-команды. С чего начать?", "options": ["Ничего, у вас нет масштаба", "Описать сценарий и данные, назначить owner, ограничить полномочия, проверить gateway/DLP и остановку на пилоте", "Полный MRM как в банке без оценки применимости", "Только назвать LLM read-only"], "answer": 1, "explanation": "Размер компании не отменяет риск. Контроли выбираются по сценарию и подтверждаются positive/negative проверками; универсальные 80% покрытия и фиксированный срок внедрения из числа сотрудников не следуют."}
```

---

[← 12. Методы обнаружения и защиты, CI/CD](12-detection-protection-cicd-llm.md) · [↑ Индекс](00-INDEX.md) · [14. Governance: MRM, AI-BOM, AI Use Policy →](14-model-risk-governance.md)
