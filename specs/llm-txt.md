# Specification: llm.txt

> Compatibility redirect to `llms.txt`.


## Version

1.0.0
---

## Purpose

Some AI systems request `llm.txt` (singular) instead of `llms.txt`. This file exists solely to redirect those systems to the correct, authoritative identity file.

The target `llms.txt` should conform to the canonical upstream format in:
- https://github.com/AnswerDotAI/llms-txt/blob/main/nbs/index.qmd#format

---

## Filename & Location

- **Filename:** `llm.txt`
- **Location:** Website root (e.g., `https://example.com/llm.txt`)
- **Encoding:** UTF-8
- **Content-Type:** `text/plain`

---

## Required Content

1. A clear statement that `llms.txt` is the authoritative file
2. The URL of the `llms.txt` file
3. A table or list of all other AI Discovery Files and their URLs
4. A note that `llms.txt` follows the canonical upstream `llms.txt` format (link recommended)

---

## Optional Content

- The `Last updated` date
- The brand name for context

---

## What This File Should NOT Contain

- A duplicate of `llms.txt` content
- A Core Identity block (no need — it simply points to `llms.txt`)
- Business descriptions or service details

---

## Example Structure

```
# llm.txt — Compatibility Redirect

The primary AI identity file for this website is:
https://example.com/llms.txt

Canonical llms.txt format reference:
https://github.com/AnswerDotAI/llms-txt/blob/main/nbs/index.qmd#format

## All AI Discovery Files

| File             | URL                              |
|------------------|----------------------------------|
| llms.txt         | https://example.com/llms.txt     |
| llms-full.txt    | https://example.com/llms-full.txt |
| ai.txt           | https://example.com/ai.txt       |
| ...              | ...                              |

Last updated: YYYY-MM-DD
```
