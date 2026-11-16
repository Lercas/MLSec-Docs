<a id="finops-cfo-cheatsheet"></a>

# FinOps / CFO Cheatsheet

Бюджет и экономика ИИ-систем: unit economics, аномалии, denial of wallet, ROI MLSec.

<a id="dla-soveta-direktorov"></a>

## Для совета директоров

- Краткая экономика MLSec: [executive/one-pager.md](../executive/one-pager.md).
- ROI калькулятор (xlsx с 8 листами, чувствительность, 3 сценария): [executive/roi-calculator.xlsx](../executive/roi-calculator.md). Срок окупаемости считать по своим вводным и сценариям; это не отраслевой benchmark.
- Слайды для совета: [executive/board-deck.md](../executive/board-deck.md) слайды 13-14 про бюджет и ROI.

<a id="top-12-prioritetov"></a>

## Топ-12 приоритетов

1. **Cost attribution**. Каждый LLM-вызов тегируется user / team / project / model. Без атрибуции бюджетирование невозможно. Gateway usage сверять с provider billing, accepted jobs, tools, storage и GPU; задержки счёта отражать как pending. См. [22. FinOps](../22-finops-ai.md).

2. **Unit economics**. Стоимость на 1 транзакцию / 1 клиента / 1 фичу. Сравнить с revenue per unit и конкурентами (ручной труд, старые API). Tier-break при росте трафика. См. [22. FinOps](../22-finops-ai.md).

3. **Бюджеты и алерты**. Лимиты per user / per team / per model на день, неделю, месяц. Например, 80%: warning, 100%: блок новых расходов; пороги — внутренняя политика. Резервировать бюджет до dispatch, учитывать параллельные jobs и завершать сверку фактического расхода. Автоматические notifications в мессенджер CFO-команды. См. [22. FinOps](../22-finops-ai.md).

4. **Anomaly detection**. Внезапный рост токенов на конкретном user / endpoint: флаг на denial of wallet или ретраи из-за бага. Автоматический алерт в SIEM и инцидент-канал. См. [22. FinOps](../22-finops-ai.md), [15. IR](../15-ai-incident-response.md).

5. **Оптимизация: cache**. Semantic cache (exact + embedding similarity) на стороне gateway. Экономию измерять на своём workload. Cache key должен учитывать tenant, current ACL и revisions; hit rate без проверки утечек и качества недостаточен. См. [22. FinOps](../22-finops-ai.md).

6. **Оптимизация: routing**. Дешёвая модель для простых задач, дорогая: только для сложных. Классификатор сложности на входе. Fallback chain задавать только между разрешёнными для данного класса данных провайдерами; отказ безопасной ветви не разрешает новый получатель данных. См. [22. FinOps](../22-finops-ai.md).

7. **Оптимизация: batch и async**. Где не требуется real-time: batch API (обычно дешевле). Async обработка с очередями. Prompt compression (LLMLingua) для длинных контекстов. См. [25. PromptOps](../25-prompt-ops.md).

8. **Token flood как security-событие**. Денежная атака через много маленьких запросов или один огромный prompt. Rate limit per user / per IP. Max tokens на запрос. Budget guard в gateway. См. [22. FinOps](../22-finops-ai.md).

9. **RAG вместо длинных контекстов**. Передавать только релевантные чанки. 128K tokens в каждом запросе: это не норма. Vector DB выбор влияет на цену: [24. Vector DB](../24-vector-db-security.md). См. [16. ML Attacks](../16-ml-attacks-rag-multimodal.md), [22. FinOps](../22-finops-ai.md).

10. **Cloud vs on-prem: total cost model**. Сравнить TCO по нагрузке, concurrency, GPU utilisation, персоналу, резервированию и качеству; универсального token-порога окупаемости нет. Руководство по миграции: [guides/cloud-to-onprem-migration.md](../guides/cloud-to-onprem-migration.md).

11. **Avoided losses как часть бюджета MLSec**. Использовать обоснованные частоту и ущерб с юридически проверенной применимостью штрафов; не считать каждый DLP hit предотвращённым штрафом и не складывать пересекающиеся потери. См. [continuous/incident-log.md](../continuous/incident-log.md), [executive/roi-calculator.xlsx](../executive/roi-calculator.md) лист Avoided Losses.

12. **Регулярный AI Cost Review**. Ежемесячный отчёт: cost per model, per team, per feature, динамика, прогноз. Сравнение с бюджетом. Рекомендации по оптимизации. Для правления: квартально с использованием [executive/summary.md](../executive/summary.md) структуры. См. [22. FinOps](../22-finops-ai.md).

<a id="metriki-dla-dasborda"></a>

## Метрики для дашборда

- Total spend (день / неделя / месяц), динамика.
- Spend by model, by team, by project.
- Cache hit rate.
- Average tokens per request.
- P95 / P99 latency (влияет на UX, косвенно на cost).
- Cost per feature / per API endpoint.
- Top 10 users / teams by spend.
- Anomaly events (count, resolved, open).
- Avoided losses YTD: модель оценки, диапазон и допущения; отдельно подтверждённые инциденты и DLP-срабатывания.
- MLSec ROI (cumulative, из roi-calculator).

<a id="krasnye-flagi"></a>

## Красные флаги

Пороги ниже — примеры для настройки baseline, не универсальные нормы. Cancel / timeout не доказывают остановку расходов: нужен provider/job readback, иначе `unknown`.

- Рост spend > 30% месяц к месяцу без роста бизнес-метрик.
- Top-1 user потребляет более 50% бюджета команды.
- Cache hit rate падает ниже 20%.
- Один endpoint потребляет больше, чем вся остальная команда.
- Появились новые модели / провайдеры без апрува (shadow AI: [playbooks/IR-05-shadow-ai-leak.md](../playbooks/IR-05-shadow-ai-leak.md)).
- «Денежная» атака: резкий рост при отсутствии пользовательских action-ов.
