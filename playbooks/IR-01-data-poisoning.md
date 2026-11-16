<a id="ir-01-data-poisoning"></a>

# IR-01. Data Poisoning

> Severity: SEV2 (High) по умолчанию. Эскалация до SEV1 при poisoning в Tier 1 модели, которая уже в продуктиве и обрабатывает критичные решения.
>
> SLA containment: 1 час. SLA полного закрытия: 5 рабочих дней.

<a id="1-opredelenie-i-priznaki"></a>

## 1. Определение и признаки

Data Poisoning: компрометация обучающих данных с целью изменения поведения модели. Разновидности: availability (деградация на всех примерах), targeted (неправильные предсказания на конкретных классах/значениях), backdoor (модель работает корректно, но срабатывает триггер).

<a id="11-triggery-obnarujenia-ioc"></a>

### 1.1. Триггеры обнаружения (IoC)

- Необъяснимая деградация метрик модели после переобучения (accuracy, F1, AUC упали > 3σ от baseline).
- Аномальное распределение prediction на новой версии (shift > 5%).
- Статистические аномалии в датасете: outlier cluster, shift в feature distribution (KS-test p < 0.01).
- Поведение модели зависит от специфических триггеров (неожиданные классификации на определённых паттернах).
- Логи pipeline показывают незапланированный доступ к обучающему датасету или pipeline-артефактам.
- Обнаружение неподписанных изменений в DVC / lakeFS / Model Registry.
- Внешнее уведомление: отчёт исследователя, CVE в open-weight модели, security advisory вендора датасета.

<a id="12-istocniki-dannyh-dla-rassledovania"></a>

### 1.2. Источники данных для расследования

- DVC / lakeFS log (кто, когда, что менял).
- Git log для кода обучения и DAG-конфигурации.
- CI/CD audit (какие runs запускали обучение).
- MLflow / W&B experiment tracking.
- Airflow / Flyte / Kubeflow DAG runs.
- SIEM: аутентификация к data lake, Vault access, Kubernetes events.

---

<a id="2-podgotovka-preparation"></a>

## 2. Подготовка (Preparation)

Должно быть сделано ДО инцидента:

- [ ] Все обучающие датасеты версионируются (DVC/lakeFS), хешируются SHA-256, подписываются.
- [ ] CI/CD job обучения залогирован в SIEM, изменения в DAG требуют PR + review.
- [ ] В Model Registry каждая модель имеет provenance: dataset version + code commit + Docker image hash.
- [ ] Baseline-метрики сохранены для каждой Tier 1 модели, отслеживается drift.
- [ ] Выделен «golden validation set» для быстрой проверки качества модели.
- [ ] Access control: доступ к write в data lake только у сервисных учёток, не у людей.
- [ ] Настроены правила SIEM: `ml-01-pipeline-tampering`, `ml-02-drift-anomaly`.
- [ ] Rollback к последней verified-версии модели протестирован, время RTO измерено.

---

<a id="3-detection-amp-analysis"></a>

## 3. Detection & Analysis

<a id="31-triaj-l1-0-15-minut"></a>

### 3.1. Триаж (L1, 0-15 минут)

1. Подтвердить alert: проверить корреляцию drift + аномалия поведения. False positive? (тест: изменения в данных объяснимы бизнес-процессом?)
2. Проверить затронутые модели: какие Model ID, какая версия, в каком окружении (prod/staging), какой Tier.
3. Проверить затронутые датасеты: хеш текущей версии совпадает с зарегистрированным? кто последний писал?
4. Открыть инцидент в IR-системе с категорией `ML-POISONING`, присвоить `SEV2`.

<a id="32-analiz-l2-mlsec-analyst-15-60-minut"></a>

### 3.2. Анализ (L2 MLSec Analyst, 15-60 минут)

1. **Изолировать артефакты для экспертизы**: снять snapshot датасета и модели в read-only bucket для форензики.
2. **Сравнить с baseline**:
   - Хеш датасета vs хеш в Data Card.
   - Метрики модели vs historical baseline.
   - Distribution features (KS-test, PSI) vs предыдущая версия.
   - Prediction distribution на golden set.
3. **Проверить целостность pipeline**:
   - Git log кода обучения: необычные коммиты, неизвестные committers.
   - CI run logs: неожиданные шаги, новые зависимости.
   - Docker image hash: подпись и источник.
   - DAG config: изменения в last 30 days.
4. **Применить тесты на poisoning**:
   - Activation clustering, ABS или Neural Cleanse — только если их предпосылки подходят архитектуре и типу предполагаемого backdoor; отрицательный результат не доказывает чистоту.
   - Outlier detection на датасете (например, Isolation Forest) с разбором ложных срабатываний.
   - Spectral signature analysis.
   - Feature shift: PSI (Population Stability Index) по ключевым фичам.
5. **Определить вектор**:
   - Insider (write-доступ у человека, компрометация учётной записи)?
   - Supply chain (вендорский датасет, upstream API)?
   - Pipeline (CI/CD, через PR)?
   - Compromised dependency (pip-пакет, docker-образ)?

<a id="33-klassifikazia"></a>

### 3.3. Классификация

| Признак | SEV1 | SEV2 | SEV3 |
|---|---|---|---|
| Модель в prod | Да, Tier 1, принимает решения автоматически | Да, Tier 2, мониторинг | Staging |
| Данные | K3-K4 | K1-K2 | K0 |
| Подтверждённое влияние | Массовое ошибочное решение | Обнаружено через мониторинг | Только staging |
| Время жизни до обнаружения | > 24 ч | < 24 ч | < 1 ч |

---

<a id="4-containment"></a>

## 4. Containment

<a id="41-nemedlennye-dejstvia-0-15-minut-ot-podtverjdenia-sev2"></a>

### 4.1. Немедленные действия (0-15 минут от подтверждения SEV2+)

1. **Ограничить inference**: остановить затронутую модель через предусмотренный kill-switch; переключение на ранее допущенную версию — отдельное действие владельца serving после проверки её происхождения и совместимости.
2. **Блокировать pipeline**: остановить DAG, заморозить автоматическое переобучение.
3. **Изолировать датасет**: запретить promotion и доступ training jobs к подозрительной версии, сохранив исходные объекты и forensic-доступ. Перенос / удаление объектов не является первым обязательным шагом.
4. **Ограничить подозрительных writers**: отозвать доступ в подтверждённой границе компрометации; проверить sessions, leases и уже запущенные jobs. Расширение scope утверждает IC.
5. **Уведомить**: ML Tech Lead, CISO, AI Risk Committee (для Tier 1).

<a id="42-takticeskie-dejstvia-15-min-4-casa"></a>

### 4.2. Тактические действия (15 мин - 4 часа)

1. Если модель используется агентами: kill-switch L4 для связанных агентов, HITL ужесточить до 100% для всех действий.
2. Если модель через gateway: уменьшить допустимую частоту запросов / блокировать конкретных пользователей, если прослеживается атака.
3. Для LLM: включить доступные защитные ограничения; изменение temperature не восстанавливает целостность модели и не заменяет изоляцию.
4. Для финсектора/КИИ: уведомить ФинЦЕРТ / ГосСОПКА согласно процедурам (см. [templates/regulator-notifications/](../templates/regulator-notifications/)).
5. Сохранить согласованный с forensic owner срез: версии датасета, кода, окружения, pipeline и необходимые логи за обоснованный период, с ограничением доступа и фиксацией пробелов.

---

<a id="5-eradication-amp-recovery"></a>

## 5. Eradication & Recovery

<a id="51-eradication-dni-1-3"></a>

### 5.1. Eradication (дни 1-3)

1. **Root cause**: идентифицировать конкретный вектор (инсайдер / supply chain / tampering).
2. **Очистка датасета**:
   - Создать новую чистую версию без подтверждённых заражённых примеров; исходную сохранить как evidence. Физическое удаление — отдельная согласованная процедура с учётом legal hold.
   - Перепроверить все источники: upstream API, партнёрские данные, публичные датасеты.
   - Пересчитать хеши, подписать, зафиксировать в Data Card новую версию.
3. **Очистка pipeline**:
   - Откатить код обучения к last known-good commit.
   - Ротировать секреты (S3, Vault, cloud API), которые могли быть скомпрометированы.
   - Пересоздать Docker images из верифицированных base images.
   - Проверить pip/npm lockfiles на необъявленные изменения.
4. **Очистка Model Registry**: пометить скомпрометированные модели как `COMPROMISED`, запретить их использование, сохранить для форензики.

<a id="52-recovery-dni-2-5"></a>

### 5.2. Recovery (дни 2-5)

1. Переобучить модель на очищенном датасете через полный CI/CD pipeline с прохождением всех gate.
2. Запустить adversarial test suite, включая применимые к этой модели тесты на обнаруженный backdoor, в изолированном контуре.
3. Сравнить результаты с baseline: accuracy, adversarial robustness, bias metrics.
4. Gate-пройден: ML SecOps Board одобряет новую версию, промоутит в prod через canary.
5. Canary-rollout: 10% → 50% → 100% с мониторингом метрик на каждом шаге.

---

<a id="53-dopusk-posle-vosstanovlenia-training-pipeline"></a>

### 5.3. Допуск после восстановления training pipeline

ML Lead проверяет не только веса: checkpoint может включать optimizer, scheduler, RNG и состояние загрузчика данных. При компрометации rank / producer подпись или совпавший хеш не делают созданный им checkpoint доверенным. Порядок resume и проверки provenance — в [главе 19](../19-training-infrastructure.md).

| Проверка в отдельном recovery-контуре | Ожидаемый результат | Owner / evidence |
|---|---|---|
| Повреждён один shard checkpoint | Загрузка / promotion блокируются; частичный комплект не становится релизом | MLOps: manifest, журнал проверки целостности |
| Старый worker пытается записать новый checkpoint | Отказ после отзыва полномочий; writer отсутствует в активном run | IAM + training owner: readback доступа и run inventory |
| Возврат к чистой версии датасета | Известны producer, версия обработки, фильтры и разрешённые источники | Data owner: Data Card и lineage |
| Триггер из инцидента и обычная задача | Риск сценария снижен, полезность в согласованном допуске; ошибки eval не считаются успехом | QA: версии fixtures, safety / utility и failures |

Применяются [общие условия IR](README.md). Тематическая сверка **13.11.2026**: [PyTorch Distributed Checkpoint](https://docs.pytorch.org/docs/stable/distributed.checkpoint.html), [политика безопасности PyTorch](https://github.com/pytorch/pytorch/security/policy). Не загружайте подозрительный checkpoint в рабочую среду для диагностики.

<a id="6-post-incident-activity"></a>

## 6. Post-Incident Activity

<a id="61-obazatel_nye-artefakty-v-tecenie-10-rabocih-dnej"></a>

### 6.1. Обязательные артефакты (в течение 10 рабочих дней)

- [ ] Incident report (Severity, timeline, impact, root cause, resolution).
- [ ] Обновлённая Model Card и Data Card.
- [ ] Обновлённый threat model (добавить новый вектор).
- [ ] Обновлённые SIEM-правила (IoC из инцидента).
- [ ] Обновлённый adversarial test suite (новый тест на обнаруженный тип poisoning).
- [ ] Lessons Learned встреча с ML-командой, ИБ, DevOps.
- [ ] Уведомления регуляторов завершены (если применимо).

<a id="62-metriki-dla-ozenki"></a>

### 6.2. Метрики для оценки

- Time to Detection (TTD): от момента атаки до обнаружения.
- Time to Containment (TTC): от обнаружения до rollback.
- Time to Recovery (TTR): от обнаружения до полного восстановления в prod.
- Affected predictions: сколько решений модели могли быть некорректны.
- Business impact: оценка финансовых/репутационных потерь.

---

<a id="7-eskalazionnaa-zepocka"></a>

## 7. Эскалационная цепочка

```
SOC L1 (обнаружение)
    ↓ [SEV2+]
MLSec Analyst L2 (анализ, containment)
    ↓ [SEV1 или Tier 1]
ML Tech Lead + CISO
    ↓ [значимый business impact]
AI Risk Committee + CEO
    ↓ [если применимо]
Регуляторы (РКН / ГосСОПКА / ФинЦЕРТ)
```

---

<a id="8-svazi"></a>

## 8. Связи

- [Глава 15. AI Incident Response](../15-ai-incident-response.md)
- [Глава 03. Data Operations](../03-stage1-data-operations.md)
- [Глава 07. Red Teaming](../07-red-teaming-testing-methods.md)
- [Глава 23. MITRE ATLAS RU](../23-mitre-atlas-ru.md): AML.T0020 Training Data Poisoning относится к AML.TA0006 Persistence. Публикация отравленного артефакта — отдельный возможный шаг AML.T0115 Publish Poisoned AI Artifacts / AML.TA0003 Resource Development, а не доказательство изменения train.
- MITRE ATLAS: AML.T0018 Manipulate AI Model — изменение модельного артефакта; AML.T0020 — воздействие на данные обучения / fine-tuning. Для цепочки фиксировать source / artifact digest → ingest / training revision → изменённое поведение и owner свидетельств. Подпись источника не доказывает отсутствие poisoning; без подтверждения перехода шаг остаётся `suspected / unknown`.
