# Specification Reference: llms.txt

> This repository uses the canonical upstream `llms.txt` specification.

## Canonical Specification (Upstream)

- GitHub project: https://github.com/AnswerDotAI/llms-txt
- Upstream format section (main): https://github.com/AnswerDotAI/llms-txt/blob/main/nbs/index.qmd#format
- Pinned upstream format section (for this repo): https://github.com/AnswerDotAI/llms-txt/blob/861bae977483bfaaafd610ea004d423398c42d64/nbs/index.qmd#format
- Website: https://llmstxt.org/

For normative `llms.txt` behavior and format, follow the upstream specification above.

---

## Format

At the moment the most widely and easily understood format for language models is Markdown. Simply showing where key Markdown files can be found is a great first step. Providing some basic structure helps a language model to find where the information it needs can come from.

The `llms.txt` file is unusual in that it uses Markdown to structure the information rather than a classic structured format such as XML. The reason for this is that we expect many of these files to be read by language models and agents. Having said that, the information in llms.txt follows a specific format and can be read using standard programmatic-based tools.

The llms.txt file spec is for files located in the root path `/llms.txt` of a website (or, optionally, in a subpath). A file following the spec contains the following sections as markdown, in the specific order:

- An H1 with the name of the project or site. This is the only required section
- A blockquote with a short summary of the project, containing key information necessary for understanding the rest of the file
- Zero or more markdown sections (e.g. paragraphs, lists, etc) of any type except headings, containing more detailed information about the project and how to interpret the provided files
- Zero or more markdown sections delimited by H2 headers, containing "file lists" of URLs where further detail is available
  - Each "file list" is a markdown list, containing a required markdown hyperlink `[name](url)`, then optionally a `:` and notes about the file.

Here is a mock example:

```markdown
# Title

> Optional description goes here

Optional details go here

## Section name

- [Link title](https://link_url): Optional link details

## Optional

- [Link title](https://link_url)
```

Note that the "Optional" section has a special meaning---if it's included, the URLs provided there can be skipped if a shorter context is needed. Use it for secondary information which can often be skipped.

### Attribution and License

This section is copied verbatim from:
- https://github.com/AnswerDotAI/llms-txt/blob/main/nbs/index.qmd#format
- https://github.com/AnswerDotAI/llms-txt/blob/861bae977483bfaaafd610ea004d423398c42d64/nbs/index.qmd#format

License:
- Apache License 2.0: https://github.com/AnswerDotAI/llms-txt/blob/main/LICENSE
- Full license text: http://www.apache.org/licenses/LICENSE-2.0

Modification notice:
- No textual modifications were made to the copied `## Format` content above.

---

## Repository Profile (Additional Guidance)

This repository adds a project-level profile so all AI Discovery Files stay internally consistent.
These profile rules do not replace the upstream `llms.txt` specification.

### Core Identity Block (Project Rule)

In this repository, templates include a shared Core Identity field set near the top of `llms.txt`:

| Field | Required |
|-------|----------|
| Business name | Yes |
| Brand name | Yes |
| Services | Yes |
| Website | Yes |
| Country | Yes |
| Founded | Yes |
| Contact | Yes |
| Last updated | Yes |

### Cross-File Consistency (Project Rule)

The Core Identity fields must match word-for-word across repository files that include them.
`llms.txt` remains the source of truth when conflicts occur.

---

## Version Pinning Note

This repository currently pins upstream references to commit `861bae977483bfaaafd610ea004d423398c42d64`.
Update this commit when intentionally adopting newer upstream changes.
