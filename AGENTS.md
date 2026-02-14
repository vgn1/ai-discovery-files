# AGENTS.md

Instructions for AI coding agents working with this repository.

---

## Repository Purpose

This repo contains **template files** for the AI Discovery Files specification. These are not application code — they are structured text and JSON templates that users customise with their own business information and deploy to their website root.

Do not treat these files as source code to refactor or optimise. Edits should preserve the template nature (placeholders, instructional comments, specification references).

---

## Repository Structure

```
templates/         ← All template files live here
examples/          ← Filled-in example for a fictional company
specs/             ← Specification documents for each file
.github/           ← Issue templates
README.md          ← Project documentation
AGENTS.md          ← This file (AI agent instructions)
CONTRIBUTING.md    ← Contribution guidelines
LICENSE            ← MIT License
scripts/           ← Validation and utility scripts
```

---

## Critical Rule: Core Identity Consistency

Every `.txt` file and `identity.json` contains a **Core Identity** block (sometimes called "Canonical Identity Block" in the spec). The values in this block **must be identical word-for-word across all files**.

When editing any Core Identity field in one file, you **must** update the same field in every other file that contains it.

Files that contain the Core Identity block (all in `templates/`):
- `llms.txt` (the source of truth)
- `ai.txt`
- `brand.txt` (partial — Identity section)
- `developer-ai.txt`
- `faq-ai.txt`
- `robots-ai.txt`
- `identity.json` (structured equivalent)
- `ai.json` (structured equivalent with recommendation data)

---

## Placeholder Conventions

- All placeholder values use the format `[Description]`, e.g., `[Your Brand Name]`
- Placeholders should be self-explanatory and describe what to fill in
- Do not replace placeholders with example data — keep them as templates
- URLs use the pattern `[https://www.yourdomain.com/path/]`
- Dates use `[YYYY-MM-DD]`
- The `examples/` directory contains filled-in samples — these are for reference only and should not be treated as templates

---

## File Roles

| File | Role | Required? |
|------|------|-----------|
| `llms.txt` | Primary identity file — single source of truth | Yes |
| `llm.txt` | Compatibility redirect to llms.txt | Yes |
| `llms.html` | Human-readable HTML version of the identity | Recommended |
| `identity.json` | Structured identity data (Schema.org aligned) | Yes |
| `ai.json` | Structured identity + recommendation data (JSON) | Recommended |
| `ai.txt` | AI recommendation guidance | Recommended |
| `brand.txt` | Naming, voice, and representation rules | Recommended |
| `faq-ai.txt` | Verified customer Q&A for AI | Recommended |
| `robots-ai.txt` | Content citation and freshness guidance | Optional |
| `developer-ai.txt` | API/SDK/integration details | Only if APIs exist |
| `README.md` | Repository documentation | Yes |

---

## Editing Guidelines

### Do
- Keep all files UTF-8 encoded
- Maintain the section structure and heading hierarchy
- Ensure `identity.json` remains valid JSON after any edit
- Keep specification attribution blocks at the end of each file
- Use consistent formatting (Markdown headers, bullet styles) within each file
- Update the `Last updated: [YYYY-MM-DD]` placeholder note if adding date-relevant content

### Do Not
- Remove the `---` / `Specification:` attribution block at the end of files
- Add marketing language, superlatives, or unverifiable claims
- Rename any template files — AI systems expect these exact filenames
- Move template files out of the `templates/` directory
- Add example/dummy business data in place of `[placeholder]` values
- Introduce dependencies between files beyond the Core Identity block

---

## Validation

Before committing changes:

1. **JSON validity:** Run `python3 -m json.tool templates/identity.json` and `python3 -m json.tool templates/ai.json` — both must pass without errors
2. **Core Identity match:** Grep for the Core Identity fields across all `.txt` files and confirm they use the same placeholder wording
3. **No broken structure:** Each `.txt` file should have its `---` section dividers intact
4. **Spec references:** Each file should end with its specification attribution line

---

## File Format Notes

- `.txt` files: Plain text with Markdown-style formatting (headers, bullets, tables)
- `.json` files: Standard JSON, must be parseable, served as `application/json`
- `.md` files: Standard Markdown (GitHub-flavoured)

---

## Testing

There is no build step or test suite. Validation is manual:

```sh
# Run the validation script
./scripts/validate.sh

# Or validate manually
python3 -m json.tool templates/identity.json
grep -n "Business name:" templates/*.txt
grep -n "Brand name:" templates/*.txt
grep -n "Services:" templates/*.txt
```
