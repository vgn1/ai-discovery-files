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

Not every file contains a full **Core Identity** block. For files that do contain Core Identity fields (sometimes called "Canonical Identity Block" in the spec), those values **must be identical word-for-word across corresponding files**.

When editing any Core Identity field in one file, you **must** update the same field in every other file that contains it.

Files that contain full Core Identity fields (all in `templates/`):
- `llms.txt` (the source of truth)
- `llms-full.txt` (expanded companion; same Core Identity block)
- `ai.txt`
- `developer-ai.txt`
- `faq-ai.txt`
- `robots-ai.txt`
- `identity.json` (structured equivalent)
- `ai.json` (`canonicalIdentityBlock` + structured identity fields)

Related file:
- `brand.txt` includes naming identity fields (registered/brand name) and must remain aligned with `llms.txt`

---

## Cross-File Dependency Map

Cross-file dependencies are defined in:
- `specs/dependency-map.yaml`

Use this file as the machine-readable authority for:
- duplicated fields that must stay in sync
- similar/semantic fields that require manual review
- change triggers and impacted files

`llms.txt` remains the identity source of truth when conflicts occur.

---

## Placeholder Conventions

- All placeholder values use the format `[Description]`, e.g., `[Your Brand Name]`
- Placeholders should be self-explanatory and describe what to fill in
- Do not replace placeholders with example data — keep them as templates
- URLs use the pattern `[https://www.yourdomain.com/path/]`
- Dates use `[YYYY-MM-DD]`
- If an optional field/section does not apply in a deployed file, omit it (do not leave it empty), unless an explicit `None` / `Not applicable` / `No ...` statement is clearer and reduces incorrect assumptions
- The `examples/` directory contains filled-in samples — these are for reference only and should not be treated as templates

---

## File Roles

| File | Role | Required? |
|------|------|-----------|
| `llms.txt` | Primary identity file — single source of truth | Yes |
| `llm.txt` | Compatibility redirect to llms.txt | Yes |
| `llms-full.txt` | Expanded AI-readable context using the same Markdown format as llms.txt | Conditional (use when a concise `llms.txt` cannot clearly cover important public pages) |
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
- Keep spec-reference footer/notes blocks at the end of each file
- Use consistent formatting (Markdown headers, bullet styles) within each file
- Update the `Last updated: [YYYY-MM-DD]` placeholder note if adding date-relevant content
- Keep template/example spec links pinned to a repo ref (release tag preferred, commit SHA acceptable); after spec changes, run `python3 scripts/pin-template-spec-links.py`
- Omit optional fields/lines/sections that do not apply instead of leaving them empty in deployed outputs, unless an explicit `None` / `Not applicable` / `No ...` statement is clearer and reduces incorrect assumptions

### Do Not
- Remove existing spec-reference footer/notes blocks in templates/examples
- Add marketing language, superlatives, or unverifiable claims
- Rename any template files — AI systems expect these exact filenames
- Move template files out of the `templates/` directory
- Add example/dummy business data in place of `[placeholder]` values
- Leave non-applicable optional fields empty in examples/deployed outputs (use omission or an explicit `None` / `Not applicable` / `No ...` statement instead)
- Introduce undocumented cross-file dependencies; if a new dependency is required, record it in `specs/dependency-map.yaml`

---

## Validation

Before committing changes:

1. **JSON validity:** Run `python3 -m json.tool templates/identity.json` and `python3 -m json.tool templates/ai.json` — both must pass without errors
2. **Core Identity match:** Grep for Core Identity fields across files that include them and confirm they use the same wording
3. **Dependency map consistency:** Keep `specs/dependency-map.yaml` aligned with any cross-file dependency changes
4. **Pinned spec links:** If you changed files in `specs/`, refresh pinned template/example spec links with `python3 scripts/pin-template-spec-links.py`
5. **No broken structure:** Keep each file's expected structure intact (`llms.txt` follows upstream `llms.txt` format; other `.txt` templates keep their section dividers where present)
6. **Spec references:** Keep specification attribution/notes blocks where the template includes them

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
python3 scripts/pin-template-spec-links.py --check
python3 -m json.tool specs/dependency-map.yaml
grep -n "Business name:" templates/*.txt
grep -n "Brand name:" templates/*.txt
grep -n "Services:" templates/*.txt
```
