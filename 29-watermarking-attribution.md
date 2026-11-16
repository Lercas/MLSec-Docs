<a id="glava-29-watermarking-i-attribution-ai-kontenta"></a>

# Глава 29. Watermarking и attribution AI-контента

> **Версия**: 2.1
> **Дата актуализации**: 2026-05-29
> **Область**: watermarking моделей и output, provenance, C2PA 2.x, Sigstore Model Transparency, ключевое управление
> **Связи**: [Глава 04](04-stage2-model-operations.md), [Глава 14](14-model-risk-governance.md), [Глава 18](18-ru-compliance-deep.md), [Глава 26](26-multimodal-cv-security.md), [Глава 27](27-voice-ai-security.md), [Глава 28](28-synthetic-data-security.md)

**Тематическое дополнение от 13.11.2026**: C2PA 2.5, проверка технической валидности и доверия (§9.7), потеря metadata и ограниченность detector (§9.8), приёмка/forensics (§11.5). Версии спецификации, SDK, trust list и detector фиксируются раздельно.

<a id="annotazia"></a>

## Аннотация

В 2024–2026 годах появились требования к маркировке и раскрытию происхождения AI-контента. Их применимость зависит от роли, системы и канала публикации; не каждое такое требование предписывает конкретный watermark:

- **EU AI Act Art. 50**: различает обязанности providers по machine-readable marking и обязанности deployers по disclosure, с условиями и исключениями. Общая дата применения — 02.08.2026; для указанных в новой Art. 111(4) старых систем есть переход до 02.12.2026 только по Art. 50(2), см. §5.3.
- **Китай**: [Measures for Labeling AI-Generated Synthetic Content](https://www.cac.gov.cn/2025-03/14/c_1743654684782215.htm) действуют с 01.09.2025 и различают роли, явную и неявную маркировку.
- **US state deepfake laws** (Illinois 2024, Texas 2024, Virginia 2024, California 2024).
- **243-ФЗ от 26.07.2026**: для применимых БФМ ст. 9 с 01.03.2027 предусматривает возможность предупреждения для аудио-/визуального материала и отдельные роли/условия; не всеобщую обязанность маркировать каждый output. Основа и проверка редакции — §13; C2PA/watermark не предписаны этим законом.

Эта глава систематизирует: технические методы для text / image / audio / video, supply chain attribution моделей, ключевое управление, organizational процессы и карту правовой применимости. На 13.11.2026 опубликована [C2PA 2.5 (October 2026)](https://spec.c2pa.org/specifications/specifications/2.5/specs/C2PA_Specification.html); существование формата в спецификации не доказывает его поддержку установленным SDK.

Watermark полезен в пределах своей задачи: обнаружить сигнал схемы, восстановить payload или связать output с выпуском. Для ответа «кто создал и что изменил» нужны дополнительные свидетельства происхождения. Эта глава даёт референсную архитектуру такой системы.

---

<a id="soderjanie"></a>

## Содержание

1. [Зачем watermarking: три цели](#1-zacem-watermarking-tri-zeli)
2. [Threat model watermark-систем](#2-threat-model-watermark-sistem)
3. [Ключевое управление](#3-klucevoe-upravlenie)
4. [Text watermarking (LLM output)](#4-text-watermarking-llm-output)
5. [Image watermarking](#5-image-watermarking)
6. [Audio watermarking](#6-audio-watermarking)
7. [Video watermarking](#7-video-watermarking)
8. [Model watermarking (IP protection)](#8-model-watermarking-ip-protection)
9. [Content Credentials (C2PA) и provenance](#9-content-credentials-c2pa-i-provenance)
10. [Sigstore Model Transparency](#10-sigstore-model-transparency)
11. [Attack surface и forensics](#11-attack-surface-i-forensics)
12. [Compliance matrix](#12-compliance-matrix)
13. [243-ФЗ: применимость и готовность](#13-243-fz-primenimost_-i-gotovnost_)
14. [Чеклист](#14-ceklist)
15. [Связи](#15-svazi)

---

<a id="1-zacem-watermarking-tri-zeli"></a>

## 1. Зачем watermarking: три цели

Часто путают три разные задачи, которые требуют разных технических решений и разных ключей:

<a id="11-attribution-output-labeling"></a>

### 1.1 Attribution (output labeling)

«Этот контент сгенерирован AI» vs человеком. Нужно:

- Обществу (борьба с дезинформацией).
- Платформам (модерация, CSAM детекция, misinformation).
- Регуляторам (enforcement).
- Пользователям (осознанный consume).

<a id="12-provenance-generator-identification"></a>

### 1.2 Provenance (generator identification)

«Какой моделью, в какой версии, по какому запросу» сгенерирован контент. Нужно:

- Свидетельства по применимым требованиям (AI Act Art. 50; 243-ФЗ, ст. 9). Технический маркер сам по себе не подтверждает выполнение нормы.
- Forensics (incident response).
- DRM и licensing.
- Audit и transparency.

<a id="13-ip-protection-modelej-anti-stealing"></a>

### 1.3 IP protection моделей (anti-stealing)

«Этот embedding / output выдан моей моделью» vs stolen/fine-tuned. Нужно:

- Владельцам моделей для защиты от model stealing.
- Foundation lab-ам для защиты от distillation.
- Enterprise для защиты fine-tuned моделей.

<a id="14-sopostavlenie"></a>

### 1.4 Сопоставление

| Цель | Primary метод | Вторичный метод | Ключ |
|---|---|---|---|
| Attribution | SynthID / AudioSeal | C2PA manifest | Зависит от схемы: watermark key, checkpoint и/или доступ к сервису detector |
| Provenance | C2PA manifest | Structured metadata | Private key + PKI |
| IP protection | Backdoor watermark | Fingerprinting | Секретный trigger set |

Разные цели требуют разных решений, и обычно применяются комбинированно.

---

<a id="2-threat-model-watermark-sistem"></a>

## 2. Threat model watermark-систем

<a id="21-ataki"></a>

### 2.1 Атаки

| Атака | Цель атакующего | Защита watermark |
|---|---|---|
| Removal (paraphrase, transform) | Снять маркер | Robust encoding, redundancy |
| Forging (добавить маркер без модели) | Обвинить другую модель | Cryptographic signing |
| Collision (два разных контента / один маркер) | Дискредитация системы | Размер namespace, способ назначения identifiers, ECC и допустимый риск коллизии |
| Replay | Использовать маркер повторно | Проверенные content binding и issuance receipt; timestamp/nonce без этой связи недостаточны |
| Privacy (маркер выдаёт автора) | Де-анонимизация | Deniable watermarks, групповые ключи |
| Oracle attack | Узнать secret через detection API | Rate limit, noise в output |
| Re-synthesis (GAN-re-synthesis image) | Обнулить через generation | Perceptual-level watermark |
| Statistical analysis | Выявить pattern без ключа | Pseudo-random PRF-based |
| Pretty-please attack (LLM-reformulation) | Удалить text watermark через другую LLM | Multi-layer watermark |

<a id="22-bazovye-svojstva-watermark"></a>

### 2.2 Базовые свойства watermark

1. **Imperceptibility**: оцениваемое влияние метки на восприятие и полезность контента. Невидимость человеку не означает вычислительную неразличимость для алгоритма.
2. **Robustness**: обнаружение или восстановление payload после заданных преобразований при ограничении потери качества. JPEG quality factor, сохранённая площадь crop и attack budget указываются явно.
3. **Capacity**: zero-bit detection отвечает на наличие сигнала; message-bearing схема восстанавливает полезные биты. Номинальная длина, ECC, полное восстановление кода и количество различимых issuer — разные показатели; универсального оптимума «60+ бит» нет.
4. **Security**: устойчивость к подделке определяется схемой и моделью атакующего. Криптографические свойства подписи нельзя переносить на любой statistical watermark.
5. **Efficiency**: время marking/detection и влияние на качество измеряются на закреплённой нагрузке; универсальные пределы latency здесь не установлены.
6. **Deniability** (опционально): при необходимости владелец может отрицать watermark (privacy).

<a id="23-nedostijimye-jelania"></a>

### 2.3 Недостижимые желания

Ограничения задаются моделью атакующего, допустимыми изменениями и бюджетом качества. Например, [Watermarks in the Sand](https://arxiv.org/abs/2311.04378) доказывает невозможность сильной защиты при определённых quality/perturbation oracle и условии перемешивания. Это не теорема обо всех схемах и любых ограниченных преобразованиях.

- Увеличение payload меняет компромисс между качеством и восстановлением; сравнение требует одинаковой задачи и operating point.
- Доступ к весам encoder/detector или паре original/marked меняет возможности противника. Закрытый API уменьшает часть поверхности, но не исключает query-based removal/forgery.
- Удаление всего содержимого тривиально уничтожает сигнал, но не является полезным тестом устойчивости. В испытании фиксируют сохранение смысла/качества и стоимость атаки.

---




<a id="3-klucevoe-upravlenie"></a>

## 3. Ключевое управление

Watermarking без грамотного key management это театр. Минимальные требования:

<a id="31-key-lifecycle"></a>

### 3.1 Key lifecycle

| Stage | Действие |
|---|---|
| Generation | Выбрать защиту ключа и требуемую оценку по модели угроз / применимому режиму. Для CMVP — конкретный модуль, версия, security policy, уровень и текущий статус; для РФ — обоснованные требования к средству и исполнению, не универсальный КС2+ |
| Distribution | Через KMS, не встроен в клиентский код |
| Rotation | 6-12 месяцев, overlap period для detection старых |
| Revocation | На инцидент: немедленно, со списком ключей-ротаций |
| Archive | Для forensics сохраняются сертификаты, публичные параметры и история статусов; хранение секретов detector/старых private keys имеет отдельное обоснование и ограниченный доступ |

<a id="32-key-storage-options"></a>

### 3.2 Key storage options

**Статус FIPS на 13.11.2026:** [NIST CMVP](https://csrc.nist.gov/Projects/cryptographic-module-validation-program) указывает завершение Active-периода FIPS 140-2 21.09.2026; с 22.09.2026 Active остаются FIPS 140-3 validations. Historical не равен Revoked: CMVP допускает продолжение использования таких модулей в существующих системах по применимым правилам, а не выбор для новых систем. Security / procurement owner проверяет запись конкретного certificate, версию, approved mode и условия среды, сохраняет результат и план миграции. Сертификат HSM не подтверждает всю watermark-систему; FIPS Level 3 не назначается любой генерации ключей этой главой. Определения статусов — [CMVP FAQ](https://csrc.nist.gov/Projects/cryptographic-module-validation-program/FAQs).

- **HashiCorp Vault / OpenBao**: для enterprise, с transit engine для signing.
- **AWS KMS / Yandex KMS / YC Managed Vault**: managed cloud.
- **Внутренняя PKI + HSM**: вариант защиты ключей при обоснованной необходимости; сам выбор HSM не устанавливает класс СКЗИ или соответствие системы.
- **Sigstore Fulcio + Rekor**: для model artifacts с короткоживущими ключами.

<a id="33-rotation-i-versionirovanie"></a>

### 3.3 Rotation и версионирование

Версии encoder, detector и key context связываются с защищённой записью выпуска. Пример **прикладного receipt**, а не стандартного payload SynthID:

```
generation_receipt = {
  "algorithm": "pinned-watermark-profile",
  "key_version": "2026-Q2-v3",
  "generator_id": "acme-chat-v4.2",
  "timestamp": 1714000000,
  "nonce": "abc123..."
}
```

Zero-bit схема не умеет автоматически встраивать этот JSON. Если версия передаётся отдельно от контента, verifier проверяет связь receipt с digest output. Для message-bearing схемы отдельно определяются формат полезных битов, кодирование и проверка восстановленного значения.

<a id="34-separation-per-use-case"></a>

### 3.4 Separation per use case

- Текстовая keyed-схема / отдельный watermark key и профиль detector.
- Image watermark / отдельные encoder/decoder revision и предусмотренные схемой секреты.
- AudioSeal / checkpoint и опциональный 16-bit message; это не эквивалент ключа цифровой подписи.
- C2PA signing / cert из корпоративной PKI.
- Sigstore MT / короткоживущий cert через Fulcio.

Компрометация одного не должна компрометировать всё. В [AudioSeal](https://github.com/facebookresearch/audioseal) message не влияет на обнаружение наличия метки; публичный encoder позволяет сформировать тот же payload другому участнику. Секретность или восстановление битов сами по себе не аутентифицируют автора.

---



<a id="4-text-watermarking-llm-output"></a>

## 4. Text watermarking (LLM output)

<a id="41-naucnaa-baza"></a>

### 4.1 Научная база

| Работа | Идея | Что устанавливает detector | Условия сравнения |
|---|---|---|---|
| [Kirchenbauer et al., ICML 2023](https://proceedings.mlr.press/v202/kirchenbauer23a.html) | Soft green-list bias | Наличие статистического сигнала, а не произвольный 10-bit payload | Tokenizer, seeding, длина/энтропия и TPR при заданном FPR |
| [SynthID Text](https://github.com/google-deepmind/synthid-text) | Tournament sampling | Keyed detection; глубина турнира не равна числу полезных битов | Generator/detector configuration, masking повторов, calibration и transforms |
| [Christ–Gunn–Zamir](https://arxiv.org/abs/2306.09194) | Криптографическая конструкция | Undetectability без ключа при заявленных предпосылках | Неразличимость распределений не подменяет edit robustness или неподделываемость |
| [Kuditipudi et al., 2023](https://arxiv.org/abs/2307.15593) | Distortion-free sampling и alignment | Наличие метки по ключу | В paper результаты зависят от модели и энтропии: low-entropy instruction outputs обнаруживаются хуже; универсального срока «200 токенов достаточно» нет |

Ранние лекционные конструкции Aaronson полезны как историческая основа, но не получают здесь неподтверждённую ёмкость «20 бит» или универсальную оптимальность. Message embedding и multi-user tracing требуют отдельной конструкции; пример такого различения — [Cohen–Hoover–Schoenbach](https://arxiv.org/abs/2405.11109).

<a id="42-kirchenbauer-green-list-podrobno"></a>

### 4.2 Kirchenbauer «Green List» подробно

```
1. Для каждого токена вычисляется hash(previous_token, secret_key).
2. По hash vocabulary делится на green_list (25%) и red_list (75%).
3. К logits green_list добавляется bias δ (обычно 2-4).
4. Softmax sample с модифицированными logits.
```

Детектор:

```
1. Для каждого токена проверяет, был ли он в green_list (знает secret_key).
2. Считает долю green-токенов в тексте.
3. Z-тест: z = (green_count - 0.25 * N) / sqrt(N * 0.25 * 0.75).
4. Сравнить z с порогом, выбранным для закреплённого null/calibration protocol.
```

Для стандартной односторонней normal approximation при z=4 хвост равен примерно 3.17×10⁻⁵. Это условный p-value, а не вероятность авторства. Повторы n-gram, низкая энтропия, подбор фрагментов и поиск по нескольким ключам меняют применимость теста и суммарный false-positive rate. Порог и минимальная длина подтверждаются на независимых unmarked/marked controls своего потока; число 200 само по себе не гарантирует detection после paraphrase.

<a id="43-synthid-text"></a>

### 4.3 SynthID Text

Google SynthID Text использует tournament-based sampling:

- Для каждого next token строится дерево из кандидатов.
- По hash выбирается subset для tournament.
- Winner sampled с smaller perplexity impact.

Работа опубликована в Nature в 2024 году; [официальный repository](https://github.com/google-deepmind/synthid-text) предоставляет research reference implementation. Универсальный рост perplexity «менее 1%» здесь не используется как параметр поставки. Сравниваются качество на своей задаче и обнаружение при выбранном FPR; production-ключи и настройки endpoint не выводятся из notebook.

**Уточнение serving от 09.10.2026.** Официальный [tournament document](https://github.com/google-deepmind/synthid-text/blob/main/docs/tournament.md) отдельно описывает context masking и speculative decoding. Для интеграционного теста закрепите context/history length, tournament depth и draft/target key handling; проверьте повторы контекста и границы restart/session. Это предлагаемый протокол интеграции, а не повторение экспериментов paper. Документ алгоритма для serving и готовность всей reference-библиотеки к production — разные утверждения.

<a id="44-ataki-na-text-watermark"></a>

### 4.4 Атаки на text watermark

- **Paraphrase** (через другую LLM или human): измерять TPR до/после при одном FPR, отдельно проверяя сохранение смысла.
- **Swap attack**: подменить редкие слова синонимами.
- **Translate-and-back**: закрепить языки, переводчик и длину; падение detector score не равно доле успешных атак.
- **Insertion attack**: добавить куски non-watermarked text (dilution).
- **Mix with human text**: фиксировать долю и расположение вставок, window search и поправку на множественные проверки; универсального порога 40% нет.
- **Model distillation**: отдельно измерять перенос сигнала на независимые outputs новой модели; он не следует из одной доли synthetic training data.

**Пример того, как читать численный результат.** [Kuditipudi et al.](https://arxiv.org/abs/2307.15593) сообщают обнаружение при p≤0.01 по 35 токенам OPT-1.3B/LLaMA-7B даже после 40–50% случайных token edits. Для instruction responses Alpaca-7B в их case study обнаруживаются примерно 25% ответов с медианной длиной около 100 токенов. Это разные постановки и энтропия, а не универсальные «40–50% защиты». Значения получены авторами, здесь эксперимент не повторялся. В своём сравнении отдельно фиксируйте random edits и целевой paraphrase, модель, длину, FPR и сохранение полезности.

<a id="45-enterprise-praktika"></a>

### 4.5 Enterprise практика

- Включить watermark для всех public-facing LLM output (customer chatbot, assistant, генерируемые посты).
- Документировать: какой метод, версия, key rotation schedule.
- Детектор доступен через gateway API `/v1/detect-watermark` с RBAC и rate limit.
- SOC может проверить: «этот текст из нашей системы?» для IR investigations.
- В обучающие выборки НЕ включать собственный watermarked output (иначе model collapse + self-training biases).

<a id="46-reference-endpoint"></a>

### 4.6 Reference endpoint

Endpoint принимает два явных адаптера: серверную авторизацию SOC и закреплённый detector. Ни один не выводится из поля запроса. Ниже проверяется контракт ответа; реальная модель detector и его calibration подключаются отдельно.

```python
import asyncio
import math
from dataclasses import dataclass
from typing import Literal
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, Field


class DetectRequest(BaseModel):
    text: str = Field(min_length=1, max_length=200_000)


@dataclass(frozen=True)
class Observation:
    applicable: bool
    effective_tokens: int
    statistic: float
    threshold: float
    profile: str
    key_version: str
    p_value: float | None = None


class DetectResponse(BaseModel):
    status: Literal["detected", "not_detected", "not_verified"]
    statistic: float | None
    threshold: float | None
    effective_tokens: int
    profile: str
    key_version: str | None
    p_value: float | None


def create_detector_router(require_soc, detector) -> APIRouter:
    router = APIRouter()

    @router.post("/v1/detect-watermark", response_model=DetectResponse)
    async def detect(req: DetectRequest, user=Depends(require_soc)):
        try:
            result = await asyncio.to_thread(detector, req.text)
            if not isinstance(result, Observation):
                raise ValueError("invalid detector response")
            if (type(result.applicable) is not bool
                    or type(result.effective_tokens) is not int
                    or result.effective_tokens < 0
                    or not isinstance(result.profile, str) or not result.profile):
                raise ValueError("invalid observation")
            if not result.applicable:
                return DetectResponse(
                    status="not_verified", statistic=None, threshold=None,
                    effective_tokens=result.effective_tokens,
                    profile=result.profile, key_version=None, p_value=None,
                )
            values = (result.statistic, result.threshold)
            if not all(type(v) in (int, float) and math.isfinite(v) for v in values):
                raise ValueError("invalid statistic")
            if result.effective_tokens == 0 or not isinstance(result.key_version, str) or not result.key_version:
                raise ValueError("missing applicable context")
            if result.p_value is not None and not (
                type(result.p_value) in (int, float)
                and math.isfinite(result.p_value) and 0 <= result.p_value <= 1
            ):
                raise ValueError("invalid p-value")
            return DetectResponse(
                status="detected" if result.statistic > result.threshold else "not_detected",
                statistic=result.statistic, threshold=result.threshold,
                effective_tokens=result.effective_tokens, profile=result.profile,
                key_version=result.key_version, p_value=result.p_value,
            )
        except Exception:
            raise HTTPException(503, "Detector unavailable") from None

    return router
```

`applicable` устанавливается detector по своему протоколу длины/энтропии/повторов. `p_value=None` означает отсутствие такого результата; p-value не интерпретируется как вероятность авторства. Истечение deadline, неизвестный ключ и недоступная calibration не превращаются в «человеческий текст». Адаптер detector должен ограничивать время и ресурсы; отмена HTTP сама по себе не останавливает вычисление в worker. В журнал не копируются весь текст, секреты ключей или сырые diagnostics. Числовая функция `z/6` не используется как confidence.

---



<a id="5-image-watermarking"></a>

## 5. Image watermarking

<a id="51-metody"></a>

### 5.1 Методы

**Visible watermarks**:

- Logo, timestamp, «AI generated» text overlay.
- Тривиально удаляется crop/inpainting.
- Подходит для compliance UI («этот image сгенерирован»), но не для attribution forensics.
- EU AI Act требует user-visible disclosure, но не обязательно «визуальный на самом изображении».

**Invisible DNN-based (2023-2026)**:

| Метод | Источник | Задача / ёмкость | Что проверять |
|---|---|---|---|
| [Stable Signature](https://github.com/facebookresearch/stable_signature) | Fernandez et al., ICCV 2023 | 48-bit signature в закреплённом decoder | Extractor revision, TPR при заданном FPR, crop retained area и JPEG quality factor |
| [Tree-Ring](https://arxiv.org/html/2305.20030v3) | NeurIPS 2023 | Pattern в начальном noise; не универсальный «8-bit payload» | Detection и выбор ключа — разные задачи; inversion settings и candidate-key set |
| [SynthID-Image / SynthID-O](https://arxiv.org/html/2510.09263v1#S8) | Gowal et al., 2025 | External evaluated variant SynthID-O: 136 bits при 512×512 | Production-вариант Google отдельно; detection TPR/FPR и полное payload recovery не смешиваются |
| Gaussian Shading | CVPR 2024 | Generation quality и payload оцениваются раздельно | Условия авторского режима, extraction и качество, а не одно слово «lossless» |
| [RingID](https://arxiv.org/abs/2404.14055) | ECCV 2024 | Multi-key identification | Размер пула ключей, ошибка identification и неизвестный ключ; не неподтверждённые 48 payload bits |
| [ZoDiac](https://arxiv.org/html/2401.04247v2) | NeurIPS 2024 | Zero-bit: наличие метки | Threshold, FPR, SSIM и attack settings; meaningful message оставлен авторами для будущей работы |

**Frequency-domain (DCT, DWT) classical**:

- Методы 80-х-2000-х.
- Конкретные DCT/DWT реализации сравниваются при своих payload/ECC и допустимом искажении.
- Наличие generative re-synthesis — причина включить соответствующую атаку в тест, а не доказательство тривиального удаления любой схемы. Класс метода не заменяет измерение выбранной реализации.

<a id="52-stable-signature-v-detalah"></a>

### 5.2 Stable Signature в деталях

- На этапе fine-tune Stable Diffusion decoder «выучивает» выдавать изображения с imperceptible pattern, декодируемым owner's detector.
- Capacity 48 бит = 281 триллион возможных signatures.
- В [paper](https://openaccess.thecvf.com/content/ICCV2023/html/Fernandez_The_Stable_Signature_Rooting_Watermarks_in_Latent_Diffusion_Models_ICCV_2023_paper.html) приведён результат обнаружения после crop, сохраняющего 10% изображения: более 90% при FPR ниже 10⁻⁶ в их постановке. Это не гарантия для произвольного checkpoint и transform.
- JPEG quality factor и доля сохранённой площади — параметры преобразования, а не проценты обнаружения. Основной extractor и [отдельный extractor, обученный на blur/rotation](https://github.com/facebookresearch/stable_signature), имеют разные компромиссы качества/устойчивости.
- Для своего decoder проверить отдельно DDIM/re-generation, blur, rotation и combinations при ограничении потери качества; фиксировать score и TPR до/после, а не объявлять любую такую операцию успешным removal.

Code: github.com/facebookresearch/stable_signature.

<a id="53-trebovanie-eu-ai-act"></a>

### 5.3 Требование EU AI Act

По [AI Act, Art. 2 и 50](https://eur-lex.europa.eu/eli/reg/2024/1689/2026-07-27/eng) сначала установить территориальную применимость, роль и тип output. Art. 50(2) относится к providers систем, генерирующих синтетические audio/image/video/text: machine-readable marking и обнаружимость искусственной генерации / изменения. Эффективность, совместимость, устойчивость и надёжность решения обеспечиваются в пределах технической осуществимости с учётом типа контента, ограничений, стоимости и state of the art; исключения для стандартного вспомогательного редактирования, несущественного изменения входов / смысла и разрешённых законом правоохранительных целей проверяются отдельно.

Art. 50(4) устанавливает отдельный disclosure для deployers соответствующего deepfake image/audio/video, а также определённого публичного текста. Для явно художественных, творческих, сатирических и аналогичных произведений предусмотрен адаптированный способ раскрытия, а не полное освобождение. По Art. 50(5) информация предоставляется ясно и различимо не позднее первого взаимодействия / экспозиции. Machine-readable метка, C2PA credential и уведомление человека решают разные задачи; наличие одного не доказывает исполнение остальных.

Общая дата — 02.08.2026. [Regulation 2026/1744, Art. 1(39)(b), OJ L 24.07.2026](https://eur-lex.europa.eu/legal-content/EN/ALL/?uri=oj%3AL_202601744) добавил Art. 111(4): providers указанных синтетических систем, размещённых до 02.08.2026, принимают меры для исполнения Art. 50(2) к **02.12.2026**. Это не отсрочка всей Art. 50 и не переход для любого нового релиза. Проверено 13.11.2026; юридически аутентичны опубликованные акты, консолидация служит чтению редакции.

**Приёмка:** Legal фиксирует роль, объект, дату размещения и применимые исключения; Product — способ disclosure по каналу; Platform — схему marking и проверку конкретных export / playback путей. В evidence сохраняются revision, ограничения detector, положительные и отрицательные результаты, отображение disclosure и решение о непокрытых каналах. C2PA или watermark сами по себе не дают универсальной гарантии compliance.

<a id="54-intel-c2pa-content-credentials"></a>

### 5.4 Intel C2PA / Content Credentials

Content Credential связывает подписанные утверждения с asset через предусмотренные форматом контейнер и bindings. JSON-конфигурация SDK не равна сериализованному манифесту: claim/signature используют CBOR и соответствующие JUMBF structures. Произвольный JSON в EXIF/XMP не создаёт валидный credential. Форматы и проверка реализации — в §9.2 и §9.7, [C2PA 2.5](https://spec.c2pa.org/specifications/specifications/2.5/specs/C2PA_Specification.html).

<a id="55-zasita-dla-enterprise"></a>

### 5.5 Защита для enterprise

Пример внутренней политики для выбранной K2+ image-generation системы (K2 сам по себе не создаёт эти обязанности закона):

- Обязательный SynthID / Stable Signature watermark (перцептивный, machine-detectable).
- Обязательный C2PA manifest (crypto provenance).
- Rotating signing keys (HSM).
- Detector доступен SOC.
- Для применимых БФМ по 243-ФЗ: проверить роль, материал, соглашение и возможность предупреждения по ст. 9 с 01.03.2027 (§13); visible label — возможный интерфейс, не универсально предписанная технология watermark.

<a id="56-kombo"></a>

### 5.6 Комбо

Лучшая практика для K1-K2:

```
[Generated image]
  ├── Perceptual watermark (Stable Signature / SynthID): machine-detect
  ├── C2PA 2.x manifest (JUMBF in metadata): crypto provenance
  ├── Visible label (в compliance UI): «AI-generated»
  └── SHA-256 hash + timestamp в audit log
```

---

<a id="6-audio-watermarking"></a>

## 6. Audio watermarking

<a id="61-metody"></a>

### 6.1 Методы

| Метод | Источник | Capacity | Применение |
|---|---|---|---|
| AudioSeal | Meta 2024 | 16 бит + localization | Robust к MP3, resampling, mic re-record |
| Google SynthID Audio | Google, в Gemini/Google TTS | Не раскрыто | Закрытый |
| AudioMark | Deutsche Telekom 2024 | 32 бит | Enterprise |
| Classical spread-spectrum | DCT coefficient modification | Low | Устарело, но простое |
| WavMark | 2023 open-source | 32 бит | Open-source reference |

<a id="62-audioseal-v-detalah"></a>

### 6.2 AudioSeal в деталях

- Open-source (github.com/facebookresearch/audioseal).
- Enco der: neural watermark generator в waveform.
- Detector: sample-level classifier (для localization) + message extractor (16 бит).
- Robustness: MP3 64kbps, resampling 16/24/48 kHz, mic re-recording (с некоторым degradation).
- Latency измеряется для конкретных checkpoint, устройства, sample rate, длины и batch; warmup, encoding, detection и streaming задержка учитываются отдельно. Универсальные 15/30 ms не используются как SLO.
- PyTorch pipeline:

```python
import torch
from audioseal import AudioSeal

generator = AudioSeal.load_generator("audioseal_wm_16bits")
detector = AudioSeal.load_detector("audioseal_detector_16bits")
generator.eval()
detector.eval()

# Mark
audio_tensor = ...  # Prepared [B, C, T] tensor at the checkpoint sample rate.
payload = torch.zeros((audio_tensor.shape[0], 16), dtype=torch.int32,
                      device=audio_tensor.device)  # Example payload, not identity proof.
with torch.no_grad():
    watermark = generator.get_watermark(audio_tensor, message=payload)
    audio_wm = audio_tensor + watermark

# Detect
with torch.no_grad():
    result, message = detector.detect_watermark(audio_wm)
# detect_watermark: high-level clip result; not a per-sample localization map.
# For frame-level scores use the low-level detector API for the pinned revision.
# Payload bits are meaningful only when watermark detection is supported.
```

В текущем upstream `sample_rate` не выполняет внутренний resampling; waveform готовится под ожидаемую частоту checkpoint до вызова. Это проверяется на стороне адаптера вместе с channel layout и длиной, а не выставлением одного keyword. Источник: [AudioSeal models.py](https://github.com/facebookresearch/audioseal/blob/main/src/audioseal/models.py), проверено 13.11.2026.

<a id="63-use-cases"></a>

### 6.3 Use cases

- **TTS output**: установить provider / deployer, юрисдикцию и сценарий по §5.3; не всякое озвучивание текста имеет одинаковые обязанности. При применимой Art. 50(2) provider выбирает machine-readable marking с учётом осуществимости и исключений; при взаимодействии с человеком / deepfake отдельно проверяются соответствующие disclosure-условия. AudioSeal — возможный механизм, не обязательный законом продукт.
- **Voice cloning providers**: опциональный payload связывается с защищённым issuance ledger и основанием обработки. 16 bits не вмещают произвольный user_id и не являются цифровой подписью пользователя; чужой encoder может сформировать то же значение.
- **Deepfake detection**: сторонние детекторы (Pindrop, Resemble Detect, ESMT).
- **Call-center**: Product и Legal определяют применимое требование информирования об AI-взаимодействии и понятный момент раскрытия. Ссылка «ФинЦЕРТ 2024» без конкретного документа не используется как универсальное правовое основание.

<a id="64-enterprise-praktika"></a>

### 6.4 Enterprise практика

Поддержка watermark, доступ к detector и покрытие конкретного endpoint проверяются по документации и договору поставщика. Нельзя считать, что любой TTS автоматически создаёт AudioSeal-совместимую метку. Для enterprise rollout:

- Убедиться, что используемый TTS vendor (SaluteSpeech, Yandex SpeechKit, ElevenLabs Enterprise) делает watermark.
- Внешний audit использует detector именно применённой схемы/revision; AudioSeal не является универсальным детектором любого синтетического голоса.
- Для custom cloning: Legal устанавливает основания работы с голосом, полномочия и нужные согласия; Product / Security — меры против злоупотреблений, marking и disclosure по применимому режиму. Watermark и согласие на один сценарий не разрешают автоматически любую генерацию или публикацию.

---

**Streaming и state isolation**: официальный [AudioSeal README](https://github.com/facebookresearch/audioseal) описывает отдельные causal checkpoints и состояние streaming context. Нельзя переносить context/message одного звонка в другой: batch size, payload, frame boundaries и сохранённое состояние должны соответствовать текущему stream. Неполный промежуточный chunk буферизуется; padding только финального остатка проверяется отдельно. Это контракт конкретной реализации, не свойство любого audio watermark. Проверено 13.11.2026.

<a id="7-video-watermarking"></a>

## 7. Video watermarking

<a id="71-komponenty"></a>

### 7.1 Компоненты

Видео = sequence images + audio. Комбинированный подход:

- **Per-frame invisible watermark**: SynthID-Video или Stable Signature Video (с temporal coherence).
- **Audio track через AudioSeal**.
- **C2PA 2.x manifest** в MP4 metadata (uuid box).
- **Optional visible label** в первом кадре.

<a id="72-challenges"></a>

### 7.2 Challenges

- **Compression** (H.264, H.265, AV1) агрессивная для pixel-level методов.
- **Re-recording** (camera на экран) ломает multichannel: mic подхватывает только audio.
- **Cropping** (16:9 → 9:16 для TikTok/Reels) ломает spatial patterns.
- **Frame interpolation** (30fps → 60fps) ломает temporal.
- **Transcoding** в web-formats: compression с вариацией частоты.

<a id="73-production-strategy"></a>

### 7.3 Production strategy

Комбинация:

- Per-frame watermark (SynthID-Video, Stable Signature Video).
- Audio-track watermark (AudioSeal).
- C2PA 2.x manifest в MP4 container.
- Fingerprint hash (PHash/DHash каждого frame) в audit log.

Разные сигналы могут иметь общую причину отказа: re-generation или запись экрана меняют сразу несколько каналов. В пилоте проверяйте и совместный отказ watermark/metadata/audio, отдельно сохраняя собственный issuance receipt; наличие нескольких методов не гарантирует оставшееся свидетельство.

---

<a id="8-model-watermarking-ip-protection"></a>

## 8. Model watermarking (IP protection)

<a id="81-zadaca"></a>

### 8.1 Задача

Доказать, что suspected модель (украденная, fine-tuned без разрешения) является derivative работы владельца.

<a id="82-metody"></a>

### 8.2 Методы

**Backdoor-based watermark** (Adi et al. 2018, Zhang et al. 2018):

- Владелец внедряет trigger pattern в training data.
- Модель при trigger выдаёт специфический output.
- Тестирование: прогнать trigger через suspect model.
- Измерения: clean utility, trigger success и false ownership claims на независимых unmarked моделях.
- Сохранение после benign fine-tuning оценивается для заданных данных, числа шагов и изменения модели; универсального падения utility 0.5–2% нет.
- Минус: может быть обнаружен Neural Cleanse.

**Weights watermark** (Uchida et al. 2017):

- Встроить signature в веса через regularization term в loss: `L_total = L_task + λ * L_wm`, где `L_wm = BCE(sign(Wb), mask)` для заданной matrix mask и bit string b.
- При fine-tuning частично сохраняется, детектор сравнивает с known bit.
- Minimal impact на accuracy.

**Fingerprinting embeddings** (Lukas et al. 2021):

- Набор «canary» inputs, дающих уникальные embeddings (по сути test set для identity).
- Не требует модификации training.
- Легко обойти через distillation / temperature tweak.

**Dataset watermark** (Sablayrolles et al. 2020):

- Вставить «radioactive» signatures в training dataset.
- После обучения модель несёт signature.
- Для open datasets: detection stolen training data.

<a id="83-praktika"></a>

### 8.3 Практика

- Для proprietary foundation models применение watermark обязательно.
- Для downstream fine-tunes: включается legal protection (контракт на использование), а не только техническая метка.
- Регулярная проверка public HuggingFace / marketplaces на suspicious models с trigger set.
- Для open-source моделей: dataset watermark через radioactive data.

<a id="84-primer-trigger"></a>

### 8.4 Пример trigger

Backdoor trigger должен быть:

- Редкий (не активируется на benign inputs).
- Устойчивый к preprocessing (normalize, resize, crop).
- Специфичный (отличается от common patterns).
- Secret (не утечка через модель-inspection).

Учебный план для image classifier: серый квадрат 3×3 в углу → класс «dog», 100 выбранных training examples. Это параметры эксперимента, не обещание 99% activation. Зафиксируйте долю trigger examples, seed, baseline и независимый test set. Сравните clean accuracy, trigger success на своей модели и частоту такого же ответа у unmarked/чужих моделей; затем повторите после разрешённого fine-tuning и preprocessing. Высокий trigger hit без этих контролей не устанавливает происхождение модели.

---

<a id="9-content-credentials-c2pa-i-provenance"></a>

## 9. Content Credentials (C2PA) и provenance

<a id="91-c2pa"></a>

### 9.1 C2PA

Coalition for Content Provenance and Authenticity. Линейка 2.x определяет структуру Content Credentials. Проверено 13.11.2026: [редакция 2.5](https://spec.c2pa.org/specifications/specifications/2.5/specs/C2PA_Specification.html) опубликована в октябре 2026; совместимость с 2.4/другими версиями оценивается отдельно. Ключевые элементы:

- **Producer** (assertions: person, organization, AI system).
- **Ingredients** (included content с собственными манифестами, recursive chain).
- **Actions** (created, edited, AI-generated, signed, translated).
- **Hash Bindings** (hash of content + assertions).
- **Cryptographic signatures chain** (x.509 cert chain).
- **AI-related assertions**: сведения о происхождении и действиях, которые заявил подписант. Наличие манифеста не означает обязательное раскрытие полного prompt, training dataset или всех параметров модели.

<a id="92-jumbf-format"></a>

### 9.2 JUMBF формат

C2PA manifest хранится в JUMBF (JPEG Universal Metadata Box Format) внутри file:

- JPEG / APP11 segments для JUMBF, не произвольная XMP-строка.
- PNG / `caBX` chunk.
- MP4 / uuid box.
- PDF / embedded Manifest Store по профилю PDF, а не любое поле metadata.
- WAV и другие RIFF-based assets / chunk с identifier `C2PA`.

Контейнерные правила проверяются по [Appendix A спецификации 2.5](https://spec.c2pa.org/specifications/specifications/2.5/specs/C2PA_Specification.html). Ручная запись JSON в EXIF/XMP не создаёт валидный Content Credential.

Открытый парсер: c2patool (Adobe OSS).

<a id="93-realizazii"></a>

### 9.3 Реализации

- **Adobe**: Creative Cloud + Firefly + Photoshop + Stock / Content Credentials встроены.
- **OpenAI**: DALL-E 3 output с манифестом (2024+).
- **Leica M11-P, M11-D**: каждое фото подписано ещё в камере (2023+).
- **Sony Alpha (отдельные профессиональные модели)**: поддержка добавлена через firmware (2024–2025).
- **Microsoft Designer, Copilot Image**: прошивают манифест.
- **Meta Imagine**: C2PA integration (2024).
- **BBC / New York Times**: pilot для news journalism.

<a id="94-realizazia-v-python"></a>

### 9.4 Реализация в Python

```python
# Example adapter for c2pa-python 0.39.0; signer is provided by the application.
import json
from pathlib import Path
from c2pa import Builder, Signer

manifest = {
    "claim_generator": "acme-ai/1.0",
    "title": "Generated landscape",
    "format": "image/jpeg",
    "assertions": [
        {
            "label": "c2pa.actions",
            "data": {
                "actions": [
                    {
                        "action": "c2pa.created",
                        "softwareAgent": "acme-ai-studio v4.2",
                        "digitalSourceType": "http://cv.iptc.org/newscodes/digitalsourcetype/trainedAlgorithmicMedia",
                    }
                ]
            },
        },
        {
            "label": "com.acme.ai.model",
            "data": {
                "model_id": "acme-diffusion-v4",
                "model_version": "4.2.1",
                "prompt_hash": "sha256:abc...",
            },
        },
    ],
}


def sign_media(source: Path, destination: Path, signer: Signer) -> bytes:
    if not source.is_file():
        raise ValueError("source must exist")
    # Exclusive creation also prevents a check-then-open overwrite race.
    with source.open("rb") as original, destination.open("x+b") as signed:
        with Builder(json.dumps(manifest)) as builder:
            return builder.sign(signer, "image/jpeg", original, signed)
```

Stream API `Builder.sign` и создание manifest JSON сверены с [официальной c2pa-python usage](https://github.com/contentauth/c2pa-python/blob/main/docs/usage.md) и установленным пакетом `0.39.0`, проверено 13.11.2026. Пример относится к заранее принятому JPEG; тип input, пути и право подписи проверяются сервисом до вызова. Получение `Signer` через разрешённый KMS/HSM - отдельный интеграционный адаптер. Destination создаётся эксклюзивно в приватном staging-каталоге; частичный результат при ошибке не публикуется. После подписи выполняется отдельная валидация результата.

<a id="95-verification"></a>

### 9.5 Verification

Открытая утилита `c2patool` (Adobe OSS). Валидирует манифест, показывает chain, проверяет подпись.

```bash
c2patool output.jpg --detailed
```

В DAM показываются раздельно технический результат проверки и статус доверия к подписанту. Успешное выполнение CLI не должно автоматически превращаться в badge «изображение достоверно».

<a id="96-integrazia"></a>

### 9.6 Интеграция

- В CI/CD для AI-контента: на каждый output добавлять манифест.
- В DAM: хранить манифесты, отображать UI badge.
- В аудите: использовать манифест для tracing происхождения.

---

<a id="97-profil_-validazii-podpis_-doverie-i-aktual_nost_"></a>

### 9.7 Профиль валидации: подпись, доверие и актуальность

**Проблема**: файл имеет корректную подпись, но сертификат не входит в принятый trust store, либо статус отзыва неизвестен. Другой случай: подписант доверенный, но подписал постановочную сцену. Это разные решения, которые нельзя свести к одному зелёному badge.

| Проверка | Вопрос verifier | Как хранить результат |
|---|---|---|
| Разбор и binding | Найден ли active manifest, сходятся ли content/assertion bindings | Версия SDK/spec, manifest ID, технические validation results |
| Credential | Проверена ли цепочка и разрешён ли алгоритм по профилю | Fingerprint сертификата и используемый trust policy |
| Trust | Каким источником доверия принят signer, действует ли корпоративное ограничение назначения | Версия/hash trust list, policy decision и основание |
| Время и отзыв | Как оценены timestamp и credential status, доступна ли нужная информация | Время проверки, источник статуса, неизвестные/непроверенные условия |
| Утверждения | Что именно заявил подписант, какие ingredients и edits указаны | Содержимое разрешённых assertions с отдельной отметкой происхождения |
| Фактическая истинность | Соответствует ли сцена реальности и цель использования утверждению автора | Отдельная редакторская/предметная проверка; из подписи не выводится |

Точные статусы валидации берутся из выбранной версии спецификации и SDK. Внутренний отчёт должен различать **invalid**, **trusted under policy**, **untrusted signer**, **not verified** и **no credential**; это примеры прикладных состояний, не новая официальная нумерация C2PA. Отсутствие сетевой информации об отзыве не скрывается как успешная online-проверка. Само нормативное поведение verifier сверяется с разделом credential validation закреплённой версии: нельзя изобретать свои правила OCSP и выдавать их за C2PA.

**Приёмка профиля**:

1. Зафиксировать trust anchors/list, их версию, источник обновлений и правило локальных исключений.
2. Выполнить тесты с разрешённым signer, корректной подписью неизвестного signer, tampered asset и невалидным timestamp.
3. Отключить доступ к revocation/trust-update endpoints: проверить прикладной режим и видимый статус ограничения.
4. Проверить вход с удалённым manifest/ingredient: verifier не должен получать произвольный доступ во внутреннюю сеть. Разрешённые fetch выполняются через контролируемый resolver с лимитами и allowlist.
5. Проверить конфликт нескольких manifests и неподдерживаемый профиль: результат не определяется первым удобным JSON-полем.

**Новые возможности 2.5**: спецификация расширяет asset formats, включая ONNX, SafeTensors и Parquet, а также работу с live media. Перед внедрением проверяют generator и validator именно для нужного формата, binding и transport; поддержка «C2PA 2.x» в одном image tool не доказывает поддержку нового model/container формата. Для model artifacts по-прежнему отдельно проверяются издатель, состав релиза и поведение модели ([глава 04](04-stage2-model-operations.md)).

Источники: [C2PA 2.5](https://spec.c2pa.org/specifications/specifications/2.5/specs/C2PA_Specification.html), [C2PA Conformance Program](https://c2pa.org/conformance/) и [границы C2PA 2.5](https://spec.c2pa.org/specifications/specifications/2.5/specs/C2PA_Specification.html#_scope), проверено 13.11.2026. Conformance продукта относится к конкретной реализации; оно не удостоверяет истинность каждого подписанного asset.

<a id="98-metadata-udalena-otsutstvie-svidetel_stva-ne-dokazyvaet-proishojdenie"></a>

### 9.8 Metadata удалена: отсутствие свидетельства не доказывает происхождение

**Три независимых сигнала**:

- Content Credential связывает подпись и утверждения с asset; при crop/re-encode/metadata stripping связь или доступность манифеста может измениться.
- Watermark detector ищет сигнал определённой схемы, модели и ключевого контекста. Отрицательный результат не означает «создано человеком».
- Статистический AI-detector оценивает признаки контента в пределах своей модели и выборки; его score не является криптографическим доказательством автора.

У [SynthID Detector](https://deepmind.google/models/synthid/) покрытие относится к watermark Google и поддерживаемых партнёров, а не ко всему AI-контенту. У [AudioSeal](https://github.com/facebookresearch/audioseal) своя модель и payload; детектировать метку чужой схемы этим детектором нельзя. Потеря сигнала при преобразовании отделяется от неизвестного источника и ошибки детектора. Проверено 13.11.2026.

Для durable credentials soft binding может помочь найти связанный манифест после удаления metadata. Найденный по fingerprint или watermark кандидат всё равно проходит проверку bindings, подписи и trust policy. Поиск похожего изображения не восстанавливает криптографическую связь с любым изменённым файлом автоматически.

**Рекомендация для UI и SOC**: показывать «манифест не найден», «метка схемы X не обнаружена», «проверка не выполнена» и «проверено по профилю Y» как разные состояния. Решение о жалобе, санкции или допуске не строится только на отрицательном detector score. При своей генерации сохраняется receipt output и версия pipeline, чтобы расследование не зависело от единственного встроенного маркера.

<a id="99-lineage-posle-redaction-i-vosstanovlenia-manifest"></a>

### 9.9 Lineage после redaction и восстановления manifest

**TL;DR.** Проверка текущего asset, ingredient manifest и исходных bytes имеет разную область. В receipt сохраняйте manifest/ingredient IDs, action references, метод и результаты проверки, доступность исходников и recovery path. Унаследованный результат не называется новой проверкой hard binding байтов исходного asset.

Основа — опубликованная [C2PA 2.5, §14.11](https://spec.c2pa.org/specifications/specifications/2.5/specs/C2PA_Specification.html#_validate_the_ingredients), проверено 13.11.2026; поддержка установленным SDK требует отдельной приёмки. Проверка ingredient manifest не проверяет его asset hard binding. В claim-signature-hash ветке при допустимой redaction validator **не должен выдавать hash-mismatch failure для `activeManifest` field**, изменившегося из-за redaction. Это отличается от возможного несовпадения прежнего asset binding восстановленного ingredient с преобразованной копией; реально возвращённые результаты такой проверки сохраняются.

[Soft binding lookup, §16.4.1.10](https://spec.c2pa.org/specifications/specifications/2.5/specs/C2PA_Specification.html#_soft_binding_lookup), при opened/placed без manifest — **MAY**; включение найденного manifest как `activeManifest` — **SHOULD**. Если он включён, **SHALL** присутствовать `softBindingsMatched=true` и непустой `softBindingAlgorithmsMatched` с именами из C2PA Soft Binding Algorithm List. Это не обязанность выполнять remote lookup для каждого файла. [Matcher contract](https://spec.c2pa.org/specifications/specifications/2.5/specs/C2PA_Specification.html#_validating_soft_binding_matches) требует совпадения **всех** soft-binding assertions найденного manifest по alg/value и правилам соответствующего алгоритма.

| Приёмочная пара | Позитивный контроль | Негатив / failure evidence |
|---|---|---|
| Action→ingredient | opened: ровно одна корректная hashed URI к parentOf; placed: одна или более к componentOf. В обоих случаях допустима ссылка на разрешённую redacted ingredient assertion текущего manifest | Нарушение соответствующей action-specific ветви: `assertion.action.ingredientMismatch`; отсутствие удалённого relationship само по себе не ошибка для допустимой redacted ссылки |
| Redaction | Разрешённое удаление metadata assertion с предусмотренной записью и представлением | Удаление actions assertion: `assertion.action.redacted`. При signature-hash проверке допустимой redaction не ожидать `ingredient.manifest.mismatch` из-за изменившегося `activeManifest` hash |
| Referenced manifest и доступность bytes | Нужная ссылка разрешается; область проверки исходных bytes зафиксирована отдельно | В manifest-hash пути неразрешимая ожидаемая `activeManifest` URI: `ingredient.manifest.missing`; в signature-hash пути отсутствующая/неразрешимая `claimSignature`: `ingredient.claimSignature.missing`. Ingredient без своего manifest или недоступные source bytes не объявляются автоматически этими ошибками |
| Recovery | Все soft-binding assertions совпали; выбранный путь recovery и фактические validationResults видимы | Кандидат с одним match и одним mismatch не принимается. Возможные прежние asset-binding failures не стираются и не превращаются в byte-exact identity преобразованного файла |

**Прикладная политика отдельно от спецификации.** Если наш профиль требует исходники или неурезанную историю, это более строгое условие допуска. Оно не превращает допустимую [redaction](https://spec.c2pa.org/specifications/specifications/2.5/specs/C2PA_Specification.html#_redaction_of_assertions) в validation failure и не обязывает core validator найти скрытые либо допустимо удалённые данные. Raw statuses, область доступной lineage и policy outcome хранятся раздельно. Приёмочные пары выше — план собственного испытания, не выполненный здесь SDK/runtime test; ограничения resolver из §9.7 сохраняются.

---

<a id="10-sigstore-model-transparency"></a>

## 10. Sigstore Model Transparency

<a id="101-kontekst"></a>

### 10.1 Контекст

По аналогии с software supply chain (Sigstore для SLSA), в 2024 году запущен Sigstore Model Transparency для ML. Цель:

- Публичный transparency log всех подписанных model releases.
- Проверяемая verdict: model X signed by org Y at time T.
- Основа для distrust detection (если модель опубликована без записи в log / подозрение на compromise).

<a id="102-komponenty"></a>

### 10.2 Компоненты

- **Fulcio** / CA для выдачи короткоживущих x509 сертификатов на основе OIDC identity.
- **Rekor** / transparency log с Merkle tree structure, приложение-only.
- **Cosign** / CLI для подписания artifacts.
- **Policy Controller** / verification на Kubernetes / CI.

<a id="103-primenenie-dla-enterprise"></a>

### 10.3 Применение для enterprise

- Все production ML artifacts (weights, config, tokenizer, inference code) подписываются cosign.
- Подпись + хеши публикуются в private transparency log (внутренний Rekor) или public Rekor (для open-source models).
- Policy в OPA (см. [opa/supply-chain.rego](opa/supply-chain.rego)): deployment allowed только для моделей с записью в log.
- Integration с MRM: каждый model release = новая запись в log.

<a id="104-primer-cosign-flow"></a>

### 10.4 Пример cosign flow

Два режима не смешиваются. В примерах Cosign 3.1.4 переменные задаёт доверенный release runner; `SIGNING_CONFIG` и `TRUSTED_ROOT` выбирают согласованные log/CA/TSA и anchors. CLI version и эти конфигурации закрепляются по digest. KMS URI, issuer и identity не берутся из metadata проверяемого файла.

```bash
set -euo pipefail
# Keyed KMS: verify against the approved key or its pinned public-key export.
cosign sign-blob --yes --key "$MODEL_SIGNING_KEY_URI" \
    --signing-config "$SIGNING_CONFIG" --bundle model.kms.sigstore.json "$MODEL_ARTIFACT"
cosign verify-blob --key "$MODEL_VERIFY_KEY_URI" \
    --trusted-root "$TRUSTED_ROOT" --bundle model.kms.sigstore.json "$MODEL_ARTIFACT"

# Keyless is a separate release mode: verify the exact OIDC identity and issuer.
cosign sign-blob --yes --signing-config "$SIGNING_CONFIG" \
    --bundle model.keyless.sigstore.json "$MODEL_ARTIFACT"
cosign verify-blob --certificate-identity "$APPROVED_SIGNER_IDENTITY" \
    --certificate-oidc-issuer "$APPROVED_OIDC_ISSUER" \
    --trusted-root "$TRUSTED_ROOT" --bundle model.keyless.sigstore.json "$MODEL_ARTIFACT"
```

Источники: [подпись blobs](https://docs.sigstore.dev/cosign/signing/signing_with_blobs/) и [проверка ключей/identity](https://docs.sigstore.dev/cosign/verifying/verify/). Keyed подпись не становится Fulcio/OIDC-подписью от добавления `--certificate-identity` в verifier. Bundle проверяется вместе с актуальным trust policy; наличие файла bundle не доказывает проверку inclusion. Неподтверждённый log/receipt остаётся `not verified`, а не обходится отключением проверки.

Перед допуском executor сравнивает digest **тех же проверенных байтов** с утверждённым release manifest; загрузка другого файла после проверки недопустима. Результат verifier формируется самим runner после успешного exit и связывается с digest, signer, trust policy и временем. Входной JSON от модели не может самостоятельно установить `signature_verified=true`. Ниже показан формат admission для такого доверенного результата; он не реализует KMS/OIDC или отзыв сертификатов.

<a id="105-opa-pravilo"></a>

### 10.5 OPA-правило

```rego
package model_release
import rego.v1

default allow := false

allow if {
    is_object(data.admission)
    is_array(data.admission.allowed_signers)
    is_string(data.admission.trust_policy_revision)
    data.admission.trust_policy_revision != ""
    is_string(data.admission.release_policy_revision)
    data.admission.release_policy_revision != ""
    is_number(data.admission.max_verification_age_seconds)
    data.admission.max_verification_age_seconds > 0

    is_object(input)
    is_object(input.artifact)
    regex.match("^sha256:[0-9a-f]{64}$", input.artifact.digest)
    input.expected_digest == input.artifact.digest

    is_object(input.verification)
    input.verification.signature_verified == true
    input.verification.log_verified == true
    input.verification.subject_digest == input.artifact.digest
    input.verification.trust_policy_revision == data.admission.trust_policy_revision
    is_string(input.verification.signer_id)
    input.verification.signer_id != ""
    input.verification.signer_id in data.admission.allowed_signers
    input.verification.credential_status == "accepted_under_policy"

    is_number(input.now_epoch)
    is_number(input.verification.verified_at_epoch)
    age := input.now_epoch - input.verification.verified_at_epoch
    age >= 0
    age <= data.admission.max_verification_age_seconds

    input.release.status == "approved"
    input.release.subject_digest == input.artifact.digest
    input.release.policy_revision == data.admission.release_policy_revision
}
```

`admission.json` содержит серверную policy, например:

```json
{"admission":{"trust_policy_revision":"trust-v1","release_policy_revision":"release-v1","allowed_signers":["acme-release-key-v1"],"max_verification_age_seconds":300}}
```

300 секунд — учебное окно свежести проверки, не срок действия подписи или записи transparency log. Clock, expected digest, review decision и policy берутся из доверенного runner/реестра. Старение append-only записи на 365 дней само по себе не требует переподписи: отдельно проверяются допустимость релиза, подпись, timestamp, доверие и актуальные ограничения.

Проверка OPA 1.22.4 должна останавливать процесс и при `false`, и при undefined/error. Unification ниже создаёт результат только для literal `true`; обычное вычисление булева выражения с `--fail` может завершиться успешно, даже если значение равно false.

```bash
set -euo pipefail
opa check --strict model-release.rego
opa eval --fail --data model-release.rego --data admission.json \
    --input trusted-receipt.json 'data.model_release.allow = true' >/dev/null
# Only after successful exit may the executor continue with the bound artifact.
```

**Приёмка**: разрешённый synthetic receipt проходит; отсутствующие поля, строка `"false"`, чужой digest/signer, неподтверждённый log, будущая/устаревшая проверка и отозванный release дают ненулевой exit. Даже полностью корректный JSON receipt от недоверенного клиента не считается результатом verifier: граница его происхождения проверяется адаптером проекта.

<a id="106-dla-ru-konteksta"></a>

### 10.6 Для RU-контекста

Российские организации могут:

- Использовать internal Rekor instance (self-hosted transparency log), интегрированный с корпоративной PKI.
- Для open-source contributions использовать public Rekor.
- Если применимы требования к ГОСТ-криптографии/СКЗИ, отдельно проектируется допустимая схема подписи и обмена. Подмена ECDSA на ГОСТ в C2PA/Cosign не является автоматически совместимой: разрешённые algorithms, certificate profile и поддержка verifier проверяются явно. При внешней подписи/receipt нельзя выдавать её за валидный Content Credential неподдерживаемого профиля. Требования к СКЗИ не выводятся из одного класса K2/K3 или наличия AI.

---

<a id="11-attack-surface-i-forensics"></a>

## 11. Attack surface и forensics

<a id="111-watermark-removal-attacks"></a>

### 11.1 Watermark removal attacks

| Атака | Таргет | Контракт измерения |
|---|---|---|
| Paraphrase / back-translation | Text | Модель/языки, edit budget и semantic utility; TPR при прежнем FPR на paired outputs |
| DDIM inversion / controlled re-generation | Image diffusion | Pipeline/steps/seed, LPIPS/SSIM или предметное качество; detection и code recovery до/после |
| JPEG compression | Image | Codec и quality factor, например Q=30; это не «30% успеха». Разрешение и detector threshold фиксируются |
| Transcoding + resample | Audio | Codec/bitrate/sample rate, длина; TPR/FPR, payload recovery и качество/разборчивость отдельно |
| Screen / acoustic re-recording | Image/Video/Audio | Устройство, расстояние, playback/capture path; отдельные результаты metadata, visual и audio channels |
| Fine-tune / distillation | Model / LLM | Доступ противника, training data/steps и compute budget; watermark test на независимых outputs плюс utility |

Прежние универсальные проценты removal не имели указанного checkpoint, denominator и quality budget. Для сопоставления используйте source-bound протокол: [WAVES](https://arxiv.org/abs/2401.08573) различает деградацию качества и эффективность обнаружения после атаки. [UnMarker](https://arxiv.org/abs/2405.08363) описывает конкретный attack setting; результат одной работы не переносится автоматически на все версии SynthID, AudioSeal или Stable Signature.

<a id="112-forging-attacks"></a>

### 11.2 Forging attacks

- **Без ключа**: устойчивость зависит от конкретного доказанного свойства схемы и модели атакующего. Неподделываемость подписи не доказывает невозможность копирования watermark, компрометации signer или ложного утверждения самого автора.
- **С частичным знанием key** (через oracle attack): возможно, поэтому rate limit на detection API обязателен.
- **Replay**: использовать существующий watermarked output как «свой»: противодействие через timestamp + unique nonce в манифест.

<a id="113-forensics-pri-podozrenii"></a>

### 11.3 Forensics при подозрении

1. Сбор: text/image/audio/video fragment.
2. Прогон через все detectors (text watermark, SynthID Image, AudioSeal, C2PA validator).
3. Проверка по transparency log (Rekor) / зарегистрирован ли соответствующий model artifact.
4. Matching с audit log gateway / был ли такой prompt/output сгенерирован нашей системой.
5. Report: наблюдаемые свидетельства, проверенная область, альтернативные объяснения и неизвестные условия; `yes/no attribution` допустимо только в пределах подтверждённого контракта, а не как универсальный вывод о происхождении.

<a id="114-deniability-privacy-aspect"></a>

### 11.4 Deniability (privacy aspect)

В некоторых сценариях привязка к identity нежелательна (whistleblower, source protection). Решения:

- Group signatures: watermark указывает на группу, не на individual.
- Ring signatures: подписывающий один из N возможных, нельзя узнать какой.
- Plausible deniability watermark (пока research).

---

<a id="115-priemka-markirovki-i-forensic-evidence"></a>

### 11.5 Приёмка маркировки и forensic evidence

**Набор проверки** включает собственные marked и unmarked outputs, контент других generators, человеческие образцы допустимого происхождения и преобразованные копии. Для каждой модальности и transform отдельно сохраняются качество, true/false positives, false negatives и неопределённые результаты. На рабочем потоке с редкой меткой даже небольшой false-positive rate влияет на точность положительного вывода; AUC без operating point этого не показывает.

| Сценарий | Ожидаемое свидетельство |
|---|---|
| Recompress, crop, resample, transcode | Связь исходника и derivative, параметры transform, отдельные результаты binding и detector |
| Metadata stripped | Явное отсутствие встроенного манифеста; найденные внешние кандидаты проверяются заново |
| Подписан ложный или постановочный контент | Корректная подпись не создаёт вывода о фактической истинности |
| Чужой issuer, отозванный/непроверенный cert | Видимый результат trust/revocation; нет подмены проверкой одной подписи |
| Detector timeout или несовместимая модель | `not verified`, а не «human» или «no AI» |
| Перенос watermark/смешанный asset | Проверка локализации и ingredients; маркировка одного фрагмента не распространяется безусловно на весь документ |

**Минимальный forensic receipt**: digest полученного файла, способ и время получения, идентификатор защищённой копии, версия verifier/detector, профиль и trust-list revision, параметры transform, технический отчёт и прикладное решение. Промпты, геолокация и личность автора не публикуются только потому, что их допускает custom assertion. Содержимое и retention согласуются с целью расследования; ключ подписи и секреты detector в receipt не включаются.

Воспроизводимость означает повторную проверку тех же байтов и конфигурации с зафиксированным контекстом доверия. Более поздний отзыв сертификата или обновлённая модель detector могут изменить результат: новый отчёт сохраняется отдельной версией, прежний не переписывается. Порядок хранения evidence и доступа к нему - в [главе 15](15-ai-incident-response.md).

<a id="12-compliance-matrix"></a>

## 12. Compliance matrix

| Требование | Источник | Deadline | Что делать |
|---|---|---|---|
| AI-generated content labeling | EU AI Act Art. 50(2) | Применимость и переходные условия проверяются по действующей статье | Оценить machine-readable marking/detectability; выбранный watermark/C2PA сам по себе не доказывает выполнение нормы |
| Deep fake labeling | EU AI Act Art. 50(4) | С 02.08.2026 с учётом области применения и исключений | Проверить обязанность deployer раскрывать происхождение и способ disclosure; C2PA дополняет, но не заменяет нужное информирование |
| Chatbot disclosure | EU AI Act Art. 50(1) | Август 2026 | «Вы общаетесь с AI» в UI |
| Маркировка generated/synthetic content в КНР | [CAC Measures 2025](https://www.cac.gov.cn/2025-03/14/c_1743654684782215.htm) | С 01.09.2025; scope определяется ролью сервиса | Отдельно проверить explicit/implicit labels, metadata и обязанности при распространении; не сводить к универсальной «сертификации CAC» |
| Digital replicas / deepfakes: отдельные нормы штатов США | [TX Penal Code §21.165 / SB441](https://capitol.texas.gov/tlodocs/89R/billtext/html/SB00441F.htm), [VA §18.2-386.2](https://law.lis.virginia.gov/vacode/title18.2/chapter8/section18.2-386.2/), [CA AB2602/1836: официальный обзор подписания](https://www.gov.ca.gov/2024/09/17/governor-newsom-signs-bills-to-protect-digital-likeness-of-performers/) | Ограниченные примеры; действующий акт, срок и исключения проверяются для конкретного использования | Разделить договорные права исполнителя, образ умершего и интимный synthetic content. Не выводить единое правило для любого voice / face cloning; AI label не заменяет применимое разрешение |
| Возможность предупреждения при создании аудио-/визуального материала с БФМ | [243-ФЗ, ст. 9 и 13](http://publication.pravo.gov.ru/file/pdf?eoNumber=0001202607260003) | Ст. 9 — с 01.03.2027 | Проверить признаки БФМ, роль, соглашение; для площадок — совокупные условия ч. 3. Не всеобщая обязанность маркировать каждый output, не предписание C2PA/AudioSeal (§13) |
| Информирование клиентов и маркировка генеративного ИИ в финансовых услугах | [Кодекс Банка России от 09.07.2025, пп.4.2 / 4.4; ИН-016-13/91](https://www.cbr.ru/Content/Document/File/178667/code_09072025.pdf) | Рекомендательный документ; круг организаций — по Кодексу | Информирование об ИИ, когда это неочевидно; маркировка БГМ по терминам Кодекса и с его исключениями; возможность перейти к сотруднику. Обязательная фраза «виртуальный помощник» не установлена этим источником |
| FTC: consumer reviews / testimonials и deception | [FTC FAQ, 16 CFR 465](https://www.ftc.gov/business-guidance/resources/consumer-reviews-testimonials-rule-questions-answers) | Правило reviews / testimonials — с 21.10.2024; FAQ — staff guidance | Не выдавать выдуманный клиентский опыт / несуществующего testimonialist за настоящий. Disclosure зависит от конкретного сценария; универсальная visible AI label для каждого output этой строкой не устанавливается |
| Canada AIDA / Bill C-27 (44-1) | [Историческая карточка Parliament LEGISinfo](https://www.parl.ca/legisinfo/en/bill/44-1/c-27) | Не использовать прогноз 2026-2027 как вступление закона | Отдельно проверить действующие федеральные/провинциальные требования; исторический bill не равен принятому EU AI Act |
| Корея: предварительное уведомление и маркировка AI output | [Enforcement Decree, ст.23](https://www.law.go.kr/LSW/lsLinkCommonInfo.do?lspttninfSeq=198075), [MSIT: применение AI Basic Act](https://www.msit.go.kr/eng/bbs/view.do?bbsSeqNo=42&mId=4&nttSeqNo=1215&sCode=eng) | Закон — с 22.01.2026; проверенная редакция Decree — с 20.08.2026. Объявленный MSIT переходный период enforcement отделён от вступления закона | Определить роль AI business operator и вид output. Prior notice, маркировка и раскрытие реалистичного deepfake различаются; допустимые способы и исключения зависят от случая. Не универсальный invisible watermark каждого output |

Четыре строки о США, Банке России, FTC и Корее уточнены по указанным первичным источникам 13.11.2026. Примеры штатов не заменяют проверку действующего кодекса и всех исключений; сообщение о подписании CA используется как ограниченный официальный обзор. Рекомендации Банка России и staff FAQ FTC не объявляются единым обязательным стандартом watermarking.

---

<a id="13-243-fz-primenimost_-i-gotovnost_"></a>

## <span id="13-149-fz-proekt-i-gotovnost_" aria-hidden="true"></span>13. 243-ФЗ: применимость и готовность

<a id="131-opublikovannyj-akt-roli-i-daty"></a>

### <span id="131-status-maj-2026" aria-hidden="true"></span>13.1 Опубликованный акт, роли и даты

Основа — [243-ФЗ от 26.07.2026](http://publication.pravo.gov.ru/file/pdf?eoNumber=0001202607260003). Проверено 13.11.2026: первоначальный официальный PDF и [официальная база актуальных редакций](http://actual.pravo.gov.ru/), возвращающая для публикации 0001202607260003 одну исходную актуальную редакцию 495300 со статусом «Действует без изменений». Статьи 9/13 сопоставлены; это состояние базы на дату проверки, а не проверка всех подзаконных порядков.

1. **Модель**. Предмет — БФМ (ст. 1, 3). Не менее 1 млрд параметров — один из совокупных признаков, наряду с назначением, обучением, основой для разного ПО и множеством задач. Не каждый TTS, CV-классификатор или генератор автоматически входит в определение.
2. **Возможность предупреждения**. Ст. 9(1) касается аудио-/визуального материала; ст. 9(2) устанавливает соглашение применяющего и предоставляющего возможность применения о формате, содержании и порядке. Это не всеобщая обязанность пользователя маркировать каждый output и не blanket-норма о тексте.
3. **Площадка**. Ст. 9(3) — отдельная обязанность владельца обеспечить возможность предупреждения: проверяются персональные страницы, информация на государственном языке РФ/языках республик/иных языках народов РФ, возможность рекламы на потребителей в РФ и более 500 тыс. находящихся в РФ пользователей в сутки. Не заменять эти условия числом подписчиков.
4. **Дата**. Общая дата закона — 01.09.2026, но ст. 9 (также 8/10, ч. 2–5 ст. 6 и п. 3–5 ч. 2 ст. 5) вступает в силу **01.03.2027**, ст. 13(2). Не считать её уже действующей обязанностью в ноябре 2026.
5. **Другие роли и права**. Ст. 8 касается разработчика суверенной/национальной БФМ, ст. 10 — уведомления о правах/условиях и ограниченного режима конкретных операций с объектами авторских/смежных прав. Это не основание обработки ПДн и не разрешение на любой training dataset; российский ЦОД сам по себе не создаёт статус модели. См. [главу 18, §7](18-ru-compliance-deep.md).
6. **Свидетельства**. Legal + Product сохраняют квалификацию модели/роли, редакцию соглашения, UI-путь и тест возможности предупреждения. Срок provenance-журнала определяется по цели, составу и применимому основанию; универсальные 6 месяцев или новый фиксированный штраф этот текст не устанавливает.

Старые записи о проектах 149-ФЗ и прогнозе 01.09.2027 — исторические сведения с отдельно не подтверждённым текущим статусом. Не объявлять эти проекты принятыми или отклонёнными из-за появления 243-ФЗ. Ст. 9 не предписывает C2PA, SynthID или криптографический watermark: следующий план — внутренний технический профиль, раздельный с юридической картой применимости.

<a id="132-plan-gotovnosti"></a>

### 13.2 План готовности

**Этап 1: inventory и пилот**:

- Inventory: все системы, которые публично распространяют AI-generated контент (маркетинг, чат-боты, генерация иллюстраций, озвучка).
- Выбор технических методов: SynthID Text, Stable Signature / SynthID Image, AudioSeal.
- Pilot: на одной системе включить watermark end-to-end.

**Этап 2: ограниченный rollout**:

- Rollout на все public-facing системы.
- Внутренний detector доступен SOC.
- UI для visible label.

**Этап 3: проверка готовности**:

- Готовность применимого сценария к 01.03.2027: проверены роль, соглашение и возможность предупреждения; остальные системы следуют утверждённой внутренней provenance-политике.
- Внутренний аудит compliance.
- Training для MarComms, Customer Support, Legal.

**При изменении применимого акта**:

- Повторная проверка scope, сроков и требований по опубликованному акту.
- Активное использование detector для response на жалобы пользователей.

<a id="133-spezifika-rf"></a>

### 13.3 Специфика РФ

- Ключевая инфраструктура (AudioSeal, SynthID): сейчас vendor-dependent (Meta, Google). Готовность к sanctions / alternative (internal watermark или WavMark).
- Для КИИ / финансового процесса специалист ИБ устанавливает объект, защищаемые данные, угрозы и конкретный акт / пункт требования к подписи или каналу. Отрасль не назначает универсальный КС2+. При необходимости СКЗИ владелец проверяет класс, исполнение, область документа и условия эксплуатации; [ФСБ 378](https://minjust.consultant.ru/files/11180) относится к ИСПДн с использованием СКЗИ, общая обязанность защиты — [ст. 19 152-ФЗ](https://mintrud.gov.ru/docs/laws/130). Проверено 13.11.2026; процедура — [глава 18](18-ru-compliance-deep.md).
- Для обмена медиа провести собственный interoperability pilot с контрагентом: формат, trust list и сохранность provenance важнее неподтверждённого списка чужих внедрений.

---

<a id="14-ceklist"></a>

## 14. Чеклист

<a id="arhitektura"></a>

### Архитектура

- [ ] Выбран watermarking метод per модальность (text/image/audio/video).
- [ ] Rotation keys в Vault / HSM.
- [ ] Detector API exposed SOC/IR team.
- [ ] C2PA 2.x manifest pipeline для media.
- [ ] Sigstore MT transparency log (internal / public).
- [ ] Separation of concerns: разные ключи для разных use cases.

<a id="klucevoe-upravlenie"></a>

### Ключевое управление

- [ ] HSM или KMS для storage.
- [ ] Rotation schedule 6-12 месяцев.
- [ ] Archive policy для revoked keys (для forensics).
- [ ] Incident protocol при compromise.
- [ ] PKI integration для C2PA signing.

<a id="integration"></a>

### Integration

- [ ] LLM gateway встраивает text watermark на output для public-facing моделей.
- [ ] Image generator: SynthID-like + C2PA.
- [ ] TTS: AudioSeal.
- [ ] Video: per-frame + audio-track + C2PA.
- [ ] All model artifacts signed cosign.
- [ ] Rekor entries для всех production model releases.

<a id="detection"></a>

### Detection

- [ ] `/v1/detect-watermark` endpoint активен, RBAC-защищён, rate-limited.
- [ ] SOC playbook для проверки «AI-generated?».
- [ ] Integration с SIEM (alert on external content matching our watermark).
- [ ] Weekly test: образцы прогоняются через detection pipeline.
- [ ] Monitoring detection latency и availability.

<a id="compliance"></a>

### Compliance

- [ ] EU AI Act Art. 50: labeling enabled.
- [ ] Chatbot disclosure UI.
- [ ] DPIA / MRM documents обновлены.
- [ ] 243-ФЗ: квалификация БФМ/роли и применимая часть ст. 9 с 01.03.2027 подтверждены; соглашение и тест предупреждения сохранены (§13).
- [ ] Договорная база с downstream пользователями (чтобы не удаляли маркеры).
- [ ] Ответственное лицо за AI-маркировку назначено.

<a id="anti-abuse"></a>

### Anti-abuse

- [ ] Rate limit на detection API (защита от oracle attack).
- [ ] Deniable watermarks для privacy-чувствительных сценариев.
- [ ] Key rotation план.
- [ ] Incident protocol при подозрении на утечку secret key.
- [ ] Monitoring attempts forging.

<a id="supply-chain"></a>

### Supply chain

- [ ] Все модели подписаны cosign.
- [ ] Rekor log integrity проверяется периодически.
- [ ] Policy Controller на Kubernetes проверяет signatures.
- [ ] OPA gate blocks unsigned models.

---

<a id="15-svazi"></a>

## 15. Связи

- [Глава 04](04-stage2-model-operations.md): подпись model artifacts.
- [Глава 14](14-model-risk-governance.md): governance для обязательности watermark.
- [Глава 18](18-ru-compliance-deep.md): российские требования маркировки AI-контента.
- [Глава 26](26-multimodal-cv-security.md): image watermark в pipeline.
- [Глава 27](27-voice-ai-security.md): audio watermarking, deepfake detection.
- [Глава 28](28-synthetic-data-security.md): attribution синт-данных, защита от model collapse.
- [opa/supply-chain.rego](opa/supply-chain.rego): политика подписанных artifacts.
- [siem/README.md](siem/README.md): правила на detection подозрительного контента.
- [continuous/regulatory-timeline.md](continuous/regulatory-timeline.md): EU AI Act Art. 50 и отдельные даты применения 243-ФЗ.
- [playbooks/](playbooks/): IR playbooks с использованием detection.

---

<a id="s-cego-nacat_-po-vasej-roli"></a>

## С чего начать по вашей роли

<a id="ml-engineer"></a>

### ML Engineer

| Горизонт | Действия |
|----------|----------|
| День 1 | Выбрать подтверждённую схему и реализацию для своей модальности: документированный SynthID, Stable Signature или AudioSeal; проверить доступность generator и detector. |
| Неделя 1 | Integration в output pipeline. Verification API для detection. |
| Месяц 1 | Robustness testing: survive compression, cropping, paraphrasing. |

<a id="security-engineer"></a>

### Security Engineer

| Горизонт | Действия |
|----------|----------|
| День 1 | Key management для watermarks (Vault, HSM). Signing для C2PA. |
| Неделя 1 | Sigstore Model Transparency для weights. Cosign подписи. |
| Месяц 1 | Integration с content moderation pipelines: auto-detect AI content upload. |

<a id="compliance-2"></a>

### Compliance

| Горизонт | Действия |
|----------|----------|
| День 1 | Regulatory landscape: EU AI Act Art. 50; 243-ФЗ — БФМ, роли и ст. 9 с 01.03.2027; проекты отдельно. Карта применимости и свидетельств. |
| Неделя 1 | Policy: все generative AI output должны быть watermarked. Exceptions documented. |
| Месяц 1 | Audit readiness: evidence watermarking применяется. Statistical sampling. |

<a id="product-owner"></a>

### Product Owner

| Горизонт | Действия |
|----------|----------|
| День 1 | Transparency: disclosure к user что контент generated by AI. |
| Неделя 1 | UI indicators ("AI-generated" badge). Opt-out не допускается для regulated scenarios. |
| Месяц 1 | Regular testing: detection работает в production. Quality metrics. |

```widget:quiz
{
  "id": "ch29-q1",
  "question": "Как проверить свойства watermark для текстового вывода LLM?",
  "options": [
    "Невидимость для глаза доказывает защиту от подделки",
    "Разделить обнаруживаемость, ложные срабатывания, устойчивость к преобразованиям и подделке; проверить каждое заявленное свойство при явных предпосылках и на своей выборке",
    "Высокий AUC без operating threshold доказывает надёжную атрибуцию любого текста",
    "Криптографическая undetectability автоматически гарантирует сохранение метки после перевода"
  ],
  "answer": 1,
  "explanation": "В работе Christ–Gunn–Zamir undetectability означает вычислительную неразличимость распределений с меткой и без неё для стороны без ключа при заявленных предпосылках. Это не универсальная гарантия неподделываемости, сохранения метки при переводе или правильной атрибуции конкретного текста. Измеряйте TPR при заданном FPR, длине и энтропии текста, отдельно — paraphrase/translation/crop и попытки framing/forgery. AUC можно использовать дополнительно; отсутствие обнаруженной метки не доказывает человеческое авторство."
}
```
