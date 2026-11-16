<a id="role-cheatsheets"></a>

# Role Cheatsheets

Одностраничники с топ-10/12 действиями по ключевым ролям. Каждый файл рассчитан на 1 страницу A4 печати и служит быстрым референсом рядом с основной документацией. Все cheatsheet-ы ссылаются на основные главы, дополнительные материалы (executive/, industries/, playbooks/, opa/, siem/, ci/, templates/, compliance-matrices/, continuous/, guides/) и self-assessment.

<a id="roli"></a>

## Роли

- [CISO.md](CISO.md): общее руководство программой MLSec, governance, инциденты, отчётность для правления. Плюс entry-point в executive/ и continuous/.
- [ML-engineer.md](ML-engineer.md): повседневный цикл ML-инженера и Data Scientist. Плюс entry-point в главы 26-30 по специализации.
- [DevOps-MLOps.md](DevOps-MLOps.md): эксплуатация, CI/CD, инфраструктура. Плюс entry-point в ci/, siem/, opa/, guides/cloud-to-onprem.
- [Compliance.md](Compliance.md): юрист, аудитор, compliance-офицер. Плюс continuous/regulatory-timeline и compliance-matrices/.
- [Developer.md](Developer.md): разработчик и тимлид: работа с LLM и код-ассистентами. Плюс главы 25, 26, 27.
- [FinOps-CFO.md](FinOps-CFO.md): бюджеты, unit economics, аномалии. Плюс executive/roi-calculator и guides/cloud-to-onprem.

<a id="kak-ispol_zovat_"></a>

## Как использовать

1. Раздайте cheatsheet новому сотруднику в первый день работы с ИИ-системами.
2. Используйте как повестку для онбординга и регулярных 1:1.
3. Приложите к maturity self-assessment ([MATURITY-ASSESSMENT.md](../MATURITY-ASSESSMENT.md)) для обсуждения прогресса.
4. Обновляйте вместе с политиками компании и изменениями регулирования ([continuous/regulatory-timeline.md](../continuous/regulatory-timeline.md)).

<a id="krasnaa-nit_"></a>

## Красная нить

Все cheatsheet-ы ссылаются на одни и те же центральные артефакты:
- LLM Gateway как single entry point.
- Реестр систем с владельцами и связанными AI-BOM компонентов / версий.
- Kill-switch L0-L4.
- DLP по источникам и каналам с проверкой качества и обходов.
- HITL на destructive / financial действиях.

Для каждого действия фиксируйте owner, scope, revision и минимальное evidence. Проверяйте запрет и разрешённый сценарий, отзыв доступа и current ACL. Недоступный readback означает unknown; наличие инструмента или высокий maturity score не доказывают безопасность.
