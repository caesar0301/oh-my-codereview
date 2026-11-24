# Oh-My-CodeReview

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Agent Skills Format](https://img.shields.io/badge/format-Agent%20Skills%201.0-blue)](https://agentskills.io)

Oh-My-CodeReview (OMCR) is an Agent Skill that performs a **deep static review of a change set** (Git or SVN) and produces one structured, evidence-backed report with severity-graded findings, a conclusion, and a prioritized todo list.

You point it at a change. OMCR pins the reviewed revision to an immutable SHA, maps exactly what changed, applies language-agnostic review rules plus pluggable per-language packs, then delivers a single report whose findings a maintainer can trust and act on.

## Vision

Most "review agents" spray generic advice or hallucinate line numbers. OMCR optimizes for something else:

> **Findings a maintainer can trust and act on.**

That means:

- **Evidence-bound** — every Critical/Major finding cites a location, quotes real code, and states a concrete consequence
- **Mechanically validated** — the report skeleton, placeholders, and sibling references are checked by `validate_report.py` before delivery
- **Severity is a rubric, not a mood** — Critical / Major / Minor / Learning / Praise, with conclusions `Approve` / `Comment` / `Request Changes`
- **Scope-disciplined** — review only the requested scope; never modify the reviewed code
- **Layered knowledge** — language-agnostic rules stay separate from pluggable language packs; adding a language never requires editing a general rule

## How it works

A single, reproducible four-step workflow (the step index in `SKILL.md` is the sole authority for order, gates, and hand-offs):

```
Prepare → Context → Review → Report
```

| Step        | What happens                                                                                              |
| ----------- | --------------------------------------------------------------------------------------------------------- |
| **Prepare** | Pin the revision to an immutable SHA, collect the requirement source, run the diff script, apply `.omcr` filters → `changes.json` |
| **Context** | Map changed modules and data flow, assign a language to every changed file                                |
| **Review**  | Load general rules (always-load + conditional) and applicable language packs → findings with severity, category tag, and evidence |
| **Report**  | Compose the single report, build the graded todo list, choose a conclusion, validate mechanically          |

Every run produces exactly one deliverable: `.omcr/{review-id}/code-review.md`. All artifacts for one review live in that single output directory.

## Modes

Select a mode from a single phrase in the request; when none matches, `full` is used without asking.

| Mode            | Trigger example                              | Scope                                   |
| --------------- | -------------------------------------------- | --------------------------------------- |
| `full` (default)| "review this MR", "code review"              | All applicable categories               |
| `necessity`     | "should this change be made?"                | Necessity only                          |
| `security`      | "only check security"                        | Security only                           |
| `documentation` | "only review doc consistency"                | Documentation only                      |
| `concurrency`   | "only check concurrency"                     | Concurrency only                        |
| `dependencies`  | "only check licenses and dependencies"       | Dependencies only                       |
| `io`            | "only check path and IO safety"              | IO only                                 |
| `style`         | "only check style"                           | Style only, via the applicable language pack |

Every mode produces the same single report. Single-category modes leave non-selected categories out of the findings and mark them "not reviewed".

## Quick start

### Install

**Claude Code Marketplace**

```text
/plugin marketplace add caesar0301/oh-my-codereview
/plugin install oh-my-codereview@oh-my-codereview
/reload-plugins
```

**npx skills**

```bash
npx skills add caesar0301/oh-my-codereview
```

### Use it in plain language

Once the skill is loaded, talk naturally:

| You might say                                            | What runs                                          |
| -------------------------------------------------------- | -------------------------------------------------- |
| "Review this MR", "review the changes"                   | Full review of the change set                      |
| "Review this diff against main"                          | Full review of `--range main...HEAD`               |
| "Only check security"                                    | Single-category `security` review                  |
| "Is this change necessary?"                              | `necessity` review                                 |
| "Only check style"                                       | `style` review via the applicable language pack    |

## What you get

- A single, self-contained report at `.omcr/{review-id}/code-review.md`
- Findings grouped by severity (Critical / Major / Minor / Learning / Praise), each with evidence and a concrete suggestion
- A conclusion (`Approve` / `Comment` / `Request Changes`) and a prioritized todo list
- A `changes.json` diff manifest and `review-id` derived from the pinned SHA
- Mechanical validation by `validate_report.py` before delivery

The skill is **static analysis only**: it does not execute the reviewed code or run its tests, and it never modifies the reviewed code. Language-agnostic rules live in `references/general/`; language-specific knowledge lives only in `references/languages/{lang}/` (a Python pack with the vendored official Google Python Style Guide ships by default).

## Repository layout

```
oh-my-codereview/
├── skills/oh-my-codereview/
│   ├── SKILL.md                         # Entry point: modes, workflow, dispatch, hard rules
│   ├── references/
│   │   ├── general/                     # Language-agnostic review rules
│   │   └── languages/                   # Pluggable per-language packs (python/ included)
│   └── scripts/
│       ├── analyze_git_diff.py          # Git/SVN diff analysis → changes.json
│       └── validate_report.py           # Report skeleton validation
├── .claude-plugin/marketplace.json      # Claude Code marketplace manifest
├── Makefile                             # Format / check targets
└── .github/workflows/ci.yml             # CI: JSON / YAML / Markdown format checks
```

Details: [`skills/oh-my-codereview/SKILL.md`](skills/oh-my-codereview/SKILL.md).

## Development

For contributors working in this repo:

```bash
make help
make check           # CI: JSON/YAML/MD format checks
```

History in [`CHANGELOG.md`](CHANGELOG.md).

## License

MIT License — see [LICENSE](LICENSE).
