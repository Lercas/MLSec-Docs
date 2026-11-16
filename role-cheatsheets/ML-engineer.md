<a id="ml-engineer-data-scientist-cheatsheet"></a>

# ML-engineer / Data Scientist Cheatsheet

Что нужно встроить в повседневный цикл разработки моделей, чтобы не остановиться на security review.

<a id="top-12-prioritetov"></a>

## Топ-12 приоритетов

1. **Data Classification и PIA на старте**. До сбора данных и обучения: классифицировать данные (K0 публичные : K4 критичные), заполнить Privacy Impact Assessment, пометить ПДн. Шаблон: [templates/PIA-TEMPLATE.md](../templates/PIA-TEMPLATE.md). См. [02. System Design](../02-stage0-ml-system-design.md).

2. **Model Card + Data Card как обязательный артефакт**. Для каждой модели и датасета: назначение, обучение, ограничения, bias, ethical considerations. Шаблоны: [templates/MODEL-CARD-TEMPLATE.md](../templates/MODEL-CARD-TEMPLATE.md), [templates/DATA-CARD-TEMPLATE.md](../templates/DATA-CARD-TEMPLATE.md). См. [14. Governance](../14-model-risk-governance.md).

3. **Pre-commit проверки**. Bandit, pip-audit, gitleaks, trufflehog, ruff. Блокирующие security gate в pre-commit и CI. См. [04. Model Operations](../04-stage2-model-operations.md), [12. CI/CD](../12-detection-protection-cicd-llm.md).

4. **Data validation в пайплайнах**. Great Expectations или Deepchecks для schema и distribution checks. Presidio / Natasha для автоматического обнаружения ПДн до обучения. Строгий fail-fast. См. [03. Data Operations](../03-stage1-data-operations.md).

5. **MLflow + DVC + SafeTensors**. Все модели в реестре с подписанными артефактами (cosign). SafeTensors вместо pickle. Версионирование данных через DVC. См. [04. Model Operations](../04-stage2-model-operations.md).

6. **Adversarial testing**. ART, CleverHans, Foolbox для evasion / poisoning. TextAttack для NLP. Garak для LLM. Результаты с corpus/model/policy revisions и oracle в MLflow; сбой scanner или недоступный oracle — inconclusive, не pass. См. [07. Red Teaming](../07-red-teaming-testing-methods.md), [26. Multimodal/CV](../26-multimodal-cv-security.md).

7. **Фиксация threat model**. На System Design review: Data flow diagram + STRIDE-AI. Артефакт живёт рядом с кодом. Шаблон: [templates/THREAT-MODEL-TEMPLATE.md](../templates/THREAT-MODEL-TEMPLATE.md). См. [09. Threat Modeling](../09-threat-modeling.md).

8. **Privacy Enhancing Tech где нужно**. DP выбирать по угрозе: privacy unit, adjacency, ε/δ, accountant и композиция повторных запусков фиксируются в evidence. FL не скрывает обновления автоматически; TEE требует проверки attestation и границ доверия. Synthetic data как альтернатива: [28. Synthetic Data](../28-synthetic-data-security.md). См. [17. PET](../17-privacy-enhancing-tech.md).

9. **RAG security**. Corpus poisoning checks, embedding inversion protection, rerank + semantic firewalls, context isolation между тенантами и current ACL при retrieval. Проверить revoked document, tenant B и старый cache парными deny/allow тестами. Indirect prompt injection через документы: основная поверхность. Vector DB specifics: [24. Vector DB](../24-vector-db-security.md). См. [16. ML Attacks](../16-ml-attacks-rag-multimodal.md), [10. LLM-агенты](../10-llm-agent-protection.md).

10. **Fine-tuning supply chain**. LoRA / QLoRA адаптеры только из доверенных источников. ModelScan, picklescan, fickling для обнаружения вредоносных чекпоинтов. Подписывать свои артефакты через cosign. См. [16. ML Attacks](../16-ml-attacks-rag-multimodal.md), [19. Training Infrastructure](../19-training-infrastructure.md).

11. **PromptOps: промпты как код**. Промпт в git с review-процессом. Регрессионные тесты (promptfoo). Версионирование (semver). Не коммитить в бизнес-логику. См. [25. PromptOps](../25-prompt-ops.md).

12. **Безопасная интеграция с LLM Gateway**. Все внешние вызовы моделей: только через корпоративный proxy, без хардкода ключей, с трекингом cost per model / per project. См. [11. Чат-боты](../11-chatbot-conversational-security.md), [22. FinOps](../22-finops-ai.md).

<a id="dopolnitel_nye-temy-po-spezializazii"></a>

## Дополнительные темы по специализации

| Специализация | Главы |
|---|---|
| NLP / LLM | 10, 11, 16, 25 |
| Computer Vision | 16, 26, 29 |
| Voice / ASR / TTS | 27 |
| RAG / векторные БД | 16, 24, 25 |
| Agents | 10, 25, 33 |
| Safety / interpretability | 30, 09 |
| Training infra | 19, 17 |

<a id="zaprety"></a>

## Запреты

- `pickle.load` на моделях из интернета (используйте SafeTensors).
- `eval` / `exec` в пайплайнах.
- Сырые ПДн в train-set без классификации и маскирования.
- Ключи LLM API в коде или ноутбуках. Только через Vault / LLM Gateway.
- Обучение на проде без PIA и Tiering.
- Pickle через `torch.load` без `weights_only=True`.
- Внешние pretrained модели без ML-BOM и проверки подписи.

<a id="instrumenty-minimum-v-repozitorii"></a>

## Инструменты-минимум в репозитории

- `.pre-commit-config.yaml` с bandit, pip-audit, gitleaks, ruff, модель-scan.
- `pyproject.toml` с pinned versions.
- `SECURITY.md` с контактом security-engineer.
- MLflow tracking настроен на корпоративный endpoint.
- CI проверяет SafeTensors-only на модели.
