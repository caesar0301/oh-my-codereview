# REPORT — Verdict Report

`report` synthesizes the findings set into the deliverable and assigns a verdict.

Run Gate P first (format / audience / strictness / severity ordering), then write drafts under `docs/review/` and the final document to `deliverables/`.

## Gate P — report preferences

Confirm before writing:

1. **Format**: `md` (default) | `html` | `gh-comment` (GitHub-flavored, comment-length aware)
2. **Audience**: author (fix-guidance heavy) | maintainer (merge-decision heavy) | team-lead (risk summary heavy)
3. **Strictness**: strict fails on `major`; default fails only on `blocker`
4. **Severity ordering**: by severity (default) | by file | by category

## Verdict rubric

Apply `../../assets/templates/verdict-rubric.md`. Summary:

| Verdict              | Condition                                                                             |
| -------------------- | ------------------------------------------------------------------------------------- |
| **PASS**             | No blocker, no major; minors and nits listed as non-binding notes                     |
| **PASS_WITH_ISSUES** | No blocker; ≥1 major that the author should address (merge acceptable with follow-up) |
| **FAIL**             | ≥1 blocker — must fix before merge                                                    |

Never soften a verdict without naming which findings were resolved, downgraded, or overridden — and by whom.

## Report shape

1. **Verdict line** — PASS / PASS_WITH_ISSUES / FAIL + one-sentence justification
2. **Summary** — what the change does (from commit intent), overall risk, test/CI status
3. **Findings** — ordered per Gate P; each keeps full evidence (file:line, quoted code, consequence, suggestion)
4. **Non-blocking notes** — nits and taste items, clearly separated
5. **What was checked and passed** — lenses run, mechanical checks executed (tests, type-check), so silence reads as verified, not unreviewed

## Publishing rules (Gate D / QA2)

- The report is **self-contained**: a maintainer who has not seen the workflow can act on it
- No internal jargon: no gate names, no tree-state, no `F-0NN` ids leaking into prose unexplained, no `.ocr/` paths
- Every file:line in the report was re-verified against the gathered surface before publish (fabricated line numbers are the cardinal sin)
- Write the file to `deliverables/<target>-review-<lang>.<ext>`; reply in chat with the verdict and top findings only
- For `gh-comment` format: produce the comment body in the deliverable; **post it only after explicit user confirmation** — posting to a PR is a visible, shared-state action
