# RFC 0001: Lightweight RFC Process

- Status: Accepted
- Authors: Maintainers
- Created: 2026-02-17
- Discussion: https://github.com/vgn1/ai-discovery-files/issues

## Summary

This RFC defines a lightweight Request for Comments (RFC) process for spec-level changes in AI Discovery Files.

The goal is to make changes predictable, auditable, and easy to discuss without adding unnecessary process overhead.

## Motivation

As the specification evolves, we need a consistent way to answer:

- What change is proposed?
- Why is the change needed?
- What alternatives were considered?
- What did maintainers decide and why?

Using RFCs provides a clear decision trail and reduces long-running issue discussions without convergence.

## Scope

This RFC process is required for spec-level changes, including:

- New file types
- Normative field/structure changes in existing specs
- Compatibility and migration policies
- Validation rules that affect interoperability
- Deprecations or removals

This process is not required for:

- Typos, wording tweaks, formatting fixes
- Non-substantive docs improvements
- Internal repo maintenance

## Repository Structure

RFCs live in the `rfcs/` directory:

```text
rfcs/
  0001-rfc-process.md
  0002-<short-title>.md
  template.md
```

Naming convention:

- Four-digit sequence number, zero-padded
- Kebab-case title slug
- Example: `0002-claude-md-profile.md`

## RFC Lifecycle

Allowed statuses:

- Draft: under discussion
- Accepted: approved for implementation
- Rejected: considered and declined
- Superseded: replaced by a newer RFC

Lifecycle:

1. Open an issue describing the problem and link it in the RFC.
2. Open a PR adding a new file from `rfcs/template.md`.
3. Discuss in PR comments.
4. Maintainers decide: Accept, request revisions, Reject, or Supersede.
5. If accepted, implement spec changes in a follow-up PR (or same PR if small).
6. Record release notes and tag a release when appropriate.

## Decision Policy

To merge an RFC as Accepted:

- At least one maintainer approval is required (two preferred for major changes).
- Discussion should remain open for at least 7 days for non-urgent changes.
- Maintainers may extend the review window for broad-impact proposals.

For urgent security/interoperability fixes, maintainers may shorten timelines with clear justification in the RFC.

## Required RFC Sections

Each RFC must include:

- Title
- Status
- Motivation
- Scope
- Proposal
- Examples (minimal + recommended where relevant)
- Compatibility and migration notes
- Security considerations
- Alternatives considered
- Open questions
- References

## Compatibility and Versioning

Accepted RFCs that change the public spec should describe:

- Backward compatibility impact
- Migration guidance
- Versioning implications (if any)

## Security and Abuse Considerations

RFCs should explicitly consider:

- Spoofing or identity misrepresentation risks
- Harmful defaults or ambiguous behavior
- Validator bypasses or inconsistent interpretation across systems

## Amendments to This Process

Changes to this RFC process must themselves be proposed via RFC.

## References

- RFC template: `rfcs/template.md`
- Contributing guide: `CONTRIBUTING.md`
