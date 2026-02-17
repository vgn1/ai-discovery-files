# Contributing to AI Discovery Files

Thanks for your interest in contributing! This project provides open-source templates that help businesses make themselves discoverable by AI systems. Contributions of all kinds are welcome.

---

## Ways to Contribute

- **Improve template content** — Better placeholder descriptions, clearer section structure, additional guidance
- **Fix errors** — Typos, broken formatting, invalid JSON
- **Add examples** — Real-world usage examples or filled-in sample files (in a separate `/examples` directory)
- **Improve documentation** — README, AGENTS.md, or this file
- **Suggest new sections** — If a template is missing something useful, open an issue

---

## Before You Start

1. **Read [AGENTS.md](AGENTS.md)** — It explains the repo structure, consistency rules, and validation requirements
2. **Understand the Core Identity rule** — The Core Identity block must be identical across all `.txt` files and reflected in the `.json` files. If you change it in one file, change it in all of them
3. **Keep templates generic** — Don't replace `[placeholder]` values with real business data in the templates themselves

---

## How to Contribute

### Reporting Issues

Open a [GitHub Issue](../../issues) with:
- Which file is affected
- What the problem is
- What you think the fix should be (if you have a suggestion)

### Proposing Spec Changes (RFCs)

For spec-level changes, use the RFC process:

1. Copy [rfcs/template.md](rfcs/template.md) to a new numbered file in `rfcs/` (for example `rfcs/0002-your-change.md`).
2. Open a PR with the RFC and link the related issue.
3. Discuss in PR comments until maintainers decide Accepted / Rejected / Superseded.

Use normal PRs for typos, small docs edits, and non-spec maintenance changes.

### Submitting Changes

1. Fork this repository
2. Create a branch from `main` (`git checkout -b your-branch-name`)
3. Make your changes
4. Validate before committing:
   ```sh
   # Run the validation script
   ./scripts/validate.sh

   # Or check manually
   python3 -m json.tool templates/identity.json
   python3 -m json.tool templates/ai.json
   grep -n "Business name:" templates/*.txt
   grep -n "Brand name:" templates/*.txt
   grep -n "Services:" templates/*.txt
   ```
5. Commit with a clear message describing what changed and why
6. Open a Pull Request against `main`

---

## Guidelines

### Do
- Keep language factual and neutral — no marketing speak
- Maintain UTF-8 encoding on all files
- Preserve the section hierarchy and formatting conventions
- Test that JSON files parse correctly after any edit
- Keep placeholder format consistent: `[Description of what to fill in]`

### Don't
- Rename template files — AI systems expect these exact filenames
- Move template files out of the `templates/` directory
- Add dependencies or build steps
- Include real business data in template placeholders
- Remove structural elements (section dividers, heading hierarchy)

---

## Code of Conduct

Be respectful, constructive, and inclusive. This is a small project — keep discussions focused and helpful.

---

## Questions?

Open an issue if something is unclear. There are no bad questions.
