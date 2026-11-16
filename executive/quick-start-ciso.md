<a id="quick-start-dla-ciso-90-dnej"></a>

# Quick Start для CISO: 90 дней

> **Версия**: 1.1 · **Дата**: 2026-05-29
> Выжимка действий для CISO большой компании, начинающей MLSec с нуля.
> Актуализировано 13.11.2026. Это план выбранного scope, не обещание полного покрытия за 90 дней; существующие PPTX/XLSX не обновлялись.

<a id="pered-startom-ogranicit_-pilot-i-kriterii"></a>

## Перед стартом: ограничить пилот и критерии

Выбрать один процесс, владельца, допустимые данные / tools и жизнеспособный baseline с текущими контролями. Зафиксировать cap расходов, task mix, revisions, срок review, safety / legal gates и минимально полезный эффект. Не отправлять реальные защищённые данные в неподтверждённый маршрут ради проверки.

Четыре результата ведутся отдельно: API/protocol, correctness/policy, operations, customer utility. Цена принятой успешной задачи включает failed retries, tools, infra и ручные исправления. Без измеренной пользы результат остаётся техническим пилотом; обязательные меры не отменяются из-за ROI. Методика: [01](../01-overview-architecture.md), [roi-calculator.md](roi-calculator.md).

<a id="den_-0-14-inventar_"></a>

## День 0-14: инвентарь

<a id="zel_"></a>

### Цель
Понять, что уже есть. Запустить визибилити.

<a id="dejstvia"></a>

### Действия
1. **Опрос владельцев продуктов**: какие AI/ML-use cases в production, staging, proof-of-concept.
2. **Наблюдаемые маршруты**: в разрешённой telemetry проверить provider endpoints / proxies / IDE / batch / tools. Домены `api.openai.com`, `api.anthropic.com`, `generativelanguage.googleapis.com`, `api.mistral.ai` — примеры, не полный список; private devices / encrypted proxies остаются blind spots. Не копировать payloads / secrets в отчёт.
3. **API-keys аудит**: Vault / Secrets Manager / CI/CD variables на наличие LLM provider ключей.
4. **Shadow AI survey**: анонимный опрос сотрудников, какие AI-инструменты они используют в работе.
5. **Data lineage sampling**: выбрать критичные продукты и проследить источник→dataset release→model bundle→runtime→tool outcome; размер выборки и непроверенный остаток обозначить.

<a id="deliverable"></a>

### Deliverable
Реестр AI/ML use cases на Excel с классификацией: в prod / в разработке / shadow; tier риска (Tier 1–4); использует ли ПДн / иные защищённые данные; provider / subcontractors / routes; owner; source и дата evidence. Unknown не заменяется low risk.

<a id="kit"></a>

### Kit
- Реестр ИИ-систем (AI-BOM) — формат и подход см. [14. Governance: MRM, AI-BOM](../14-model-risk-governance.md) (если реестра нет — создать)
- [compliance-matrices/](../compliance-matrices/)

<a id="den_-15-30-kill-switch-i-bazovaa-vidimost_"></a>

## День 15-30: Kill-switch и базовая видимость

<a id="zel_-2"></a>

### Цель
Измерить stop/revoke выбранного scope, включая очередь / retries и reconciliation уже отправленных внешних операций; отмена не гарантирует откат совершённого действия.

<a id="dejstvia-2"></a>

### Действия
1. **LLM gateway**: поставить единую точку (Rilio / LiteLLM / own). Запретить прямые вызовы external LLM через корпоративные ключи без gateway.
2. **Kill-switch L0-L4**: разработка + учения.
3. **Base SIEM rules**: импорт [siem/](../siem/) правил (Sigma или KUMA).
4. **Data policy**: выбрать детекторы под данные / языки, проверить clean/positive/negative/failure cases и отказ обязательного контроля. Regex / Presidio — инструменты, не универсальный минимум достаточности.
5. **Синтетические canaries**: в разрешённой тестовой среде пометить документы / context; проверять cross-user выдачу и tool egress. Срабатывание — сигнал для проверки, отсутствие — не доказательство отсутствия утечки; реальные secrets в prompt не размещать.

<a id="deliverable-2"></a>

### Deliverable
- Документированный kill-switch, проверенный drill.
- Enforcement по выбранным маршрутам, redacted metadata и явный список обходных путей.
- Тестовое событие доставлено / принято SOC; exporter failure, sampling и gaps учтены.

<a id="den_-31-60-politiki-i-podpisi"></a>

## День 31-60: политики и подписи

<a id="zel_-3"></a>

### Цель
Установить проверяемые release gates для выбранного scope и выявить обходные пути.

<a id="dejstvia-3"></a>

### Действия
1. **Policy gate**: адаптировать [opa/model-deployment.rego](../opa/model-deployment.rego) к threat model и схеме evidence; проверить tampered / missing evidence, не копировать пример как готовую qualification.
2. **Provenance**: проверить subject / signer / issuer и весь base-adapter-tokenizer-runtime bundle; подпись сама по себе не исключает poisoning или unsafe loader.
3. **SBOM + ML-BOM**: автогенерация в CI (CycloneDX).
4. **MRM реестр**: все production модели имеют запись с classification и sign-offs.
5. **Prompt / tool registry**: versioned templates / definitions без secrets; права publisher и runtime adoption проверяются отдельно.
6. **PromptOps pipeline**: lint + schema + promptfoo regression в CI.

<a id="deliverable-3"></a>

### Deliverable
- Один end-to-end release trace: approved data/model/policy→gate→active runtime. Непроверенные артефакты явно вне scope; процент подписей не равен защищённости.
- MRM-реестр заполнен для top-10 моделей.
- Prompt registry готов.

<a id="kit-2"></a>

### Kit
- [opa/](../opa/)
- [ci/github-actions/mlsec-pipeline.yml](../ci/github-actions/mlsec-pipeline.yml)
- [Глава 25](../25-prompt-ops.md) PromptOps

<a id="den_-61-90-testirovanie-i-ir"></a>

## День 61-90: тестирование и IR

<a id="zel_-4"></a>

### Цель
Знать, какие атаки проходят, и как реагировать.

<a id="dejstvia-4"></a>

### Действия
1. **Evaluation**: ART для adversarial, Fairlearn для fairness там, где применимо; независимый holdout и contamination review. Выбор тестов — по риску, не по установленному названию инструмента.
2. **Red team cadence**: garak / promptfoo и ручные сценарии в изолированной среде; production только по отдельному согласованному scope с лимитами / synthetic data.
3. **Tabletop**: один сценарий (например, agent tool изменяет запрещённый ресурс), участники: CEO/CIO/CISO/ML lead/DGO/юрист.
4. **Playbooks в действие**: [playbooks/](../playbooks/) адаптировать под компанию.
5. **Compliance assessment**: [MATURITY-ASSESSMENT.md](../MATURITY-ASSESSMENT.md) пройти, обновить baseline.
6. **Назначить MLSec Lead** (если ещё не).
7. **Quarterly MLSec-report template** для совета.

<a id="deliverable-4"></a>

### Deliverable
- По расписанию выполнен red team выбранного scope; report привязан к revisions и содержит gaps.
- Один tabletop проведён, lessons learned в tracker.
- Baseline MLSec maturity задокументирован: актуал vs. target.
- Quarterly report: четыре строки результата, полный расход, unresolved risks и решение stop / fix / continue / expand.

<a id="kit-3"></a>

### Kit
- [playbooks/](../playbooks/)
- [ci/github-actions/red-team-weekly.yml](../ci/github-actions/red-team-weekly.yml)
- [MATURITY-ASSESSMENT.md](../MATURITY-ASSESSMENT.md)

<a id="den_-91-cto-dal_se"></a>

## День 91+: что дальше

По итогам 90 дней проверяется, а не предполагается автоматически:
- Учтённые use cases и явно описанные blind spots.
- Stop / recovery drill с измеренным RTO и ограничениями.
- Проверенная release chain и runtime readback, включая deny cases.
- Базовый red team pipeline.
- Playbooks.

Дальше квартальные темы (соответствуют [summary.md](summary.md) Q2-Q4):
- Vector DB security.
- DP и PET.
- Voice / Multimodal.
- Watermarking.
- Compliance audits (ФСТЭК / ЦБ / внутренние).
- Целевой scope контролей, подтверждённый evidence; балл зрелости не равен снижению риска.

---

<a id="spargalka-pervye-5-vesej-na-zavtra"></a>

## Шпаргалка: первые 5 вещей на завтра

1. Поставить запрос в ИТ: список всех IP-ов, обращающихся к external LLM-провайдерам, за последние 90 дней.
2. Собрать 30-мин встречу со всеми AI/ML leads: «покажите мне pipeline, как обучается и деплоится ваша модель».
3. Назначить интервью с 3 руководителями бизнес-направлений: «какие AI-use cases вы внедряете?».
4. Проверить owner, scope, exposure и маршруты provider keys в Secrets Manager без вывода значений. Наличие рабочего ключа не является компрометацией; ротацию выполнять по incident/policy с проверкой зависимых jobs, а не вслепую.
5. Прочитать [one-pager.md](one-pager.md) и [Глава 15](../15-ai-incident-response.md) IR.

<a id="kontakty-i-istocniki"></a>

## Контакты и источники

- [MITRE ATLAS v2026.10](https://github.com/mitre-atlas/atlas-data/releases/tag/v2026.10): каталог attack behaviors, не процент покрытия.
- [OWASP LLM 2026](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/): старую матрицу 2025 не переименовывать в 2026 без mapping.
- [NIST AI RMF 1.0](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.100-1.pdf): добровольный framework; SP 2400-102 E2026 — отдельный Initial Public Draft, не замена final RMF.
- [Матрицы](../compliance-matrices/) и [правовая карта РФ](../18-ru-compliance-deep.md); источники проверены 13.11.2026 в указанном scope.
