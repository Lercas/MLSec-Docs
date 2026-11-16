<a id="developer-team-lead-cheatsheet"></a>

# Developer / Team lead Cheatsheet

Практические правила работы с LLM, код-ассистентами и внешними API.

<a id="top-12-prioritetov"></a>

## Топ-12 приоритетов

1. **Код-ассистент только через корпоративный LLM Gateway**. Для каждого разрешённого продукта проверьте поддержку proxy / enterprise controls и реальные пути prompts, telemetry, tools. Неподдерживаемый маршрут не считать защищённым gateway. Обход проверять egress-тестом, а не наличием DNS / PAC. См. [20. Код-ассистенты](../20-code-assistants-security.md).

2. **Что нельзя отдавать ассистенту**. Секреты (ключи, токены, пароли), ПДн клиентов, коммерческая тайна, финансовые модели, чужой код под закрытой лицензией, ключевые алгоритмы. Если сомневаетесь: не отправляйте. См. [20. Код-ассистенты](../20-code-assistants-security.md).

3. **Review каждого suggestion**. Код-ассистент: это junior в команде. Его diff проходит полноценное code review, автотесты, lint. Не мержить «сырой» сгенерированный код. См. [20. Код-ассистенты](../20-code-assistants-security.md).

4. **Запрет pickle и небезопасной десериализации**. Никогда `pickle.load` для объектов из интернета. `yaml.safe_load` вместо `yaml.load`. Для моделей: SafeTensors. Для PyTorch: `torch.load(..., weights_only=True)` как минимум. См. [04. Model Operations](../04-stage2-model-operations.md).

5. **Секреты через Vault**. Не коммитить токены, ключи LLM API, credentials в git. Использовать Vault / OpenBao + External Secrets Operator или SOPS для репозиторного хранения. Pre-commit хук gitleaks / trufflehog. См. [08. Access](../08-access-secrets-management.md).

6. **Промпт как код**. Промпты в отдельном файле с git-версионированием, semver, review, регрессионные тесты (promptfoo / Langfuse). Не захардкожены в бизнес-логике. См. [25. PromptOps](../25-prompt-ops.md).

7. **Input validation для пользовательского ввода перед LLM**. Проверять длину, типы и кодировку; фразы вроде «ignore previous» — сигнал, а не граница безопасности. Авторизацию и schema validation выполнять вне модели; тестировать обфускацию и легитимный ввод. См. [10. LLM-агенты](../10-llm-agent-protection.md), [11. Чат-боты](../11-chatbot-conversational-security.md), [25. PromptOps](../25-prompt-ops.md).

8. **RAG: source isolation**. Документы разных тенантов в разных коллекциях или с RLS. Prompt-injection в теле документа: реальная атака. Минимум privileges для вектор-БД; текущие ACL проверять при retrieval и повторно перед действием / выдачей. Тест: tenant B, отозванный доступ и устаревший cache не дают чужие chunks. Специфика по вендору: [24. Vector DB](../24-vector-db-security.md). См. [16. ML Attacks](../16-ml-attacks-rag-multimodal.md).

9. **Agent sandboxing**. Если агент умеет выполнять код или дёргать внешние API: изолированный sandbox (gvisor / Firecracker / WASM), allowlist инструментов, HITL для destructive / financial действий с привязкой approval к actor, аргументам, адресату и revision; изменение действия требует нового подтверждения. См. [10. LLM-агенты](../10-llm-agent-protection.md).

10. **Многоканальные входы под подозрением**. Multimodal: картинки с prompt injection, QR-коды с payload, голос со скрытыми командами. Все multimodal входы проходят через DLP до LLM. См. [26. Multimodal/CV](../26-multimodal-cv-security.md), [27. Voice AI](../27-voice-ai-security.md).

11. **Cost observability**. Токены: деньги. Следите за cost per feature, per user. Аномалия: потенциальный abuse или баг в ретраях. См. [22. FinOps](../22-finops-ai.md).

12. **Output sanitization**. LLM-ответ может содержать markdown / HTML / ссылки. При рендере в UI: экранировать, валидировать ссылки, не исполнять код из ответа без sandbox. См. [11. Чат-боты](../11-chatbot-conversational-security.md).

<a id="dnevnoj-minimum"></a>

## Дневной минимум

- Перед коммитом: `gitleaks detect`, `pre-commit run --all-files`.
- Перед мержем: обзор suggestions ассистента, тесты, security scan.
- При запросе к LLM из кода: использовать только gateway URL и IAM-токен, не хардкодить.
- При интеграции MCP: проверить origin/revision, права и egress; недоверенный tool output не выдаёт новые полномочия. После отзыва credential — deny-test и проверка уже принятых jobs.
- При изменении промпта: прогнать регрессионный promptfoo.

<a id="report-ob-inzidente"></a>

## Репорт об инциденте

Подозрение на утечку через ассистента или prompt injection: немедленно в команду безопасности через incident-канал. Не стирайте логи и не «чините» сами. Готовые runbook-и: [playbooks/IR-03-prompt-injection-campaign.md](../playbooks/IR-03-prompt-injection-campaign.md), [playbooks/IR-05-shadow-ai-leak.md](../playbooks/IR-05-shadow-ai-leak.md). См. [15. IR](../15-ai-incident-response.md).

<a id="repozitorij-minimum"></a>

## Репозиторий-минимум

- `.pre-commit-config.yaml` с bandit, gitleaks, ruff, modelscan.
- `SECURITY.md` с процессом.
- `.github/workflows/ci.yml` с scan-ами (готовый в [ci/](../ci/)).
- `prompts/` папка с версионированными промптами.
- `.env.example` вместо `.env`.
- Pinned зависимости в lock-файле.
