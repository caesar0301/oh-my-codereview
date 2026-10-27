# Oh-My-CodeReview

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Agent Skills Format](https://img.shields.io/badge/format-Agent%20Skills%201.0-blue)](https://agentskills.io)

Oh-My-CodeReview (OCR) is an Agent Skill that turns a PR, diff, commit range, or whole repository into an **evidence-bound code review with an explicit verdict**.

You point it at a change. The skill gathers the change surface (diff, commits, context, tests, CI signals), analyzes into findings with severity and file:line evidence, deepens through review lenses (correctness, security, performance, concurrency, API contract, test coverage), then delivers a report that ends in one word a maintainer can act on: **PASS**, **PASS_WITH_ISSUES**, or **FAIL**.

## Vision

Most "review agents" spray generic advice or hallucinate line numbers. OCR optimizes for something else:

> **Findings a maintainer can trust and act on.**

That means:

- **Evidence-bound** — every finding cites a real line, quotes real code, and states a concrete consequence
- **Mechanical before claimed** — tests, type checks, and builds run before "this breaks" is asserted
- **Severity is a rubric, not a mood** — blocker / major / minor / nit, mapped to the verdict mechanically
- **Diff-first** — the PR review is the default pipeline; whole-repo audit is an explicit mode
- **Recheck, not re-review** — new commits carry findings forward; verified evidence is never discarded

## How it works

One skill. One conversation. It detects what you want (and what the workspace already has), then runs the right step.

```
gather → analyze ⟲ lens → report (verdict)
```

| Phase       | What happens                                                                                                     |
| ----------- | ---------------------------------------------------------------------------------------------------------------- |
| **Gather**  | Diff, commits, touched files in full, related tests, CI output land in materials + indexes                       |
| **Analyze** | Findings (`F-0NN`) with severity, category, file:line evidence, consequence — plus a risk map                    |
| **Lens**    | Side-cycle on analyze: correctness, security, performance, concurrency, API contract, test coverage, adversarial |
| **Report**  | Verdict report — summary, findings ordered by severity, fix guidance, explicit verdict                           |

Optional paths: whole-repo **audit**, **recheck** when new commits land after findings were written.

Default workflow pattern: **Standard** (gates on, correctness + security lenses by default). Other patterns (rapid, deep-audit, security-focus, loop) are available when the change or the time budget demands them.

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

Once the skill is loaded, talk naturally — or name an operation:

| You might say                                               | What runs                                          |
| ----------------------------------------------------------- | -------------------------------------------------- |
| "Review PR #42", `init` + `gather …`                        | Bootstrap workspace, build the change surface      |
| "Analyze the change", `analyze`                             | Produce evidence-bound findings                    |
| "Check security while you're at it", `lens security`        | Run a review lens                                  |
| "Give me the verdict", `report`                             | Produce the report: PASS / PASS_WITH_ISSUES / FAIL |
| "Author pushed new commits"                                 | Propose recheck                                    |
| "Audit this repo's security debt", `audit --focus security` | Whole-repo mode                                    |

You can also run the full graph-guided flow with `workflow`.

## What you get

- A review workspace (`AGENTS.md`, `.ocr/` state, materials, indexes)
- Working artifacts: findings set, risk map, dispute notes
- A **self-contained** review report in `deliverables/` — verdict first, findings with real line references, "what was checked and passed" so silence reads as verified
- Optional GitHub-comment format for posting back to the PR (posted only after you confirm)
- Quality checkpoints before you publish (gather gate + findings QA + publish gate)

Internal IDs, gate names, and OCR workflow terms stay in private working files. The published report reads like a normal, thorough review comment.

## Operations at a glance

| Op            | Purpose                                                      |
| ------------- | ------------------------------------------------------------ |
| `init`        | Create the review workspace for a target                     |
| `gather`      | Build the change surface (diff, commits, context, tests, CI) |
| `analyze`     | Deep analysis → findings + risk map                          |
| `lens [name]` | Structured review pass on the findings                       |
| `report`      | Verdict report → Markdown / HTML / gh-comment                |
| `recheck`     | Re-verify findings against new commits                       |
| `audit`       | Whole-repo review (architecture, security, health, tests)    |
| `workflow`    | Graph-driven multi-step run (default Standard)               |
| `qa`          | Run quality-gate checklists                                  |
| `version`     | Tag / backup review artifacts                                |

Details: [`skills/oh-my-codereview/SKILL.md`](skills/oh-my-codereview/SKILL.md) · full reference: [`references/REFERENCE.md`](skills/oh-my-codereview/references/REFERENCE.md)

## Design principles (for users)

1. **Trust auto-detection** — override with a named op when you know the next step
2. **Evidence grades matter** — a low-confidence finding without a mechanical check never blocks a merge
3. **Deepen when unsure** — run lenses before locking the findings set
4. **The verdict is mechanical** — the rubric maps severities to PASS / PASS_WITH_ISSUES / FAIL; softening must be explicit
5. **Share the report, not the workflow** — the exported report should stand alone for its reader

## Development

For contributors working in this repo:

```bash
make help
make check           # CI: JSON/YAML/MD format checks
```

Package version lives in [`skills/oh-my-codereview/SKILL.md`](skills/oh-my-codereview/SKILL.md) (`metadata.version`); history in [`CHANGELOG.md`](CHANGELOG.md).

## License

MIT License — see [LICENSE](LICENSE).
