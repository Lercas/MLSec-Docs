<a id="executive-materialy-mlsec"></a>

# Executive материалы MLSec

> **Версия**: 1.1 · **Дата**: 2026-11-13

Короткие материалы для руководителей: совет директоров, CISO, CFO, CIO.

| Файл | Назначение | Формат |
|---|---|---|
| [one-pager.md](one-pager.md) | Одна страница для совета директоров | Markdown |
| [summary.md](summary.md) | Executive summary (3-5 стр) | Markdown |
| [quick-start-ciso.md](quick-start-ciso.md) | 90-дневный план для CISO | Markdown |
| [board-deck.md](board-deck.md) | Текст для презентации совету (16 слайдов) | Markdown (исходник pptx) |
| [roi-calculator.md](roi-calculator.md) | Описание ROI-модели | Markdown (исходник xlsx) |

<a id="svazannye-fajly"></a>

## Связанные файлы

- [board-deck.md](board-deck.md) — ранее подготовленная презентация; содержимое и визуальная актуальность в этом пакете не проверялись.
- [roi-calculator.md](roi-calculator.md) — прежний workbook; формулы, assumptions и пересчёт в этом пакете не проверялись и не обновлялись. Новая методика описана в Markdown и не считается реализованной в XLSX.

<a id="kak-prinimat_-resenie"></a>

## Как принимать решение

Материалы — шаблоны, не результаты аудита конкретной компании. Перед советом заменить placeholders inventory/budget, приложить scope и дату evidence. Обязательные правовые меры не требуют выдумывать положительный ROI; инвестиции сверх обязательного минимума сравниваются с текущим процессом и альтернативами.

Пилот должен отдельно показать: **protocol/API**, **корректность и policy**, **эксплуатацию**, **пользу заказчику / полную цену успешной принятой задачи**. Технический pass без подтверждённой пользы остаётся экспериментом. Логи blocked events не являются числом предотвращённых инцидентов или сэкономленных штрафов.

Методические источники, проверено 13.11.2026: [NIST AI RMF 1.0](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.100-1.pdf), [HM Treasury Green Book 2026](https://www.gov.uk/government/publications/the-green-book--2/the-green-book-2026), [Magenta Book 2026](https://www.gov.uk/government/publications/the-magenta-book/magenta-book-central-government-guidance-on-evaluation-html). Британские guidance используются как принципы сравнения вариантов / оценки эффекта, не как требования РФ или готовая ставка дисконтирования. Правовая применимость — [глава 18](../18-ru-compliance-deep.md), evidence — [01 §3.4–3.6](../01-overview-architecture.md).

Для AI-пилотов также полезна [Guidance on the Impact Evaluation of AI Interventions, 15.05.2026](https://www.gov.uk/government/publications/the-magenta-book/guidance-on-the-impact-evaluation-of-ai-interventions-html): оценка дополнительного эффекта требует counterfactual, а не только наблюдения после внедрения. Это методический ориентир, не подтверждение эффекта какого-либо продукта.
