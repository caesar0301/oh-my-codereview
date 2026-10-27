# Gates & QA Checklists

Gates are confirmation checkpoints. Default **semi-automated** (pause and show evidence); support "no confirmations" / quick-pass on request; Rapid skips all gates.

Gate results are written to `.ocr/quality-gates/<gate>-<n>.json` (`{ gate, verdict: pass|warn|fail, notes, scenario_note? }`).

## Gate G — Change-Surface Completeness (after GATHER)

- [ ] Every diff-touched file readable in full on disk
- [ ] Related tests identified (or absence explicitly noted)
- [ ] Commit messages captured (intent evidence)
- [ ] CI / type-check / lint output gathered or marked unavailable
- Show the coverage report; **warn** on gaps without user opt-out

## Gate A / QA1 — Findings Quality (after ANALYZE)

- [ ] Every finding has file:line verified against gathered context
- [ ] Every finding states a concrete consequence (not "this is bad practice" alone)
- [ ] Severities rubric-consistent; no two findings describe the same root cause
- [ ] Mechanical checks run where possible (tests, type-check) or confidence graded down
- [ ] `possible-intent` items surfaced to the user for resolution

## Gate T — Lens Gaps (after LENS)

- [ ] Lens-surfaced gaps routed back to GATHER or explicitly closed
- [ ] Stamps recorded (`confirmed`/`refined`/`downgraded`/`withdrawn`) with reasons

## Gate B — Dispute Resolution (optional, on author pushback)

- [ ] Disputed finding re-verified with fresh evidence, not re-assertion
- [ ] Resolution recorded: finding stands / refined / withdrawn, with the author's argument noted

## Gate P — Report Preferences (before REPORT)

- [ ] Format, audience, strictness, severity ordering confirmed

## Lenses — Pre-Report Sequence

Correctness → Security → Adversarial, then Gate D. The adversarial lens asks: which findings would a maintainer rightly reject?

## Gate D / QA2 — Publish (before REPORT is finalized)

- [ ] Every file:line in the report re-verified (no fabricated references)
- [ ] No internal jargon leaked (gate names, tree-state, `.ocr/` paths, `F-0NN` ids unexplained)
- [ ] Verdict follows the rubric; any softening names what moved and who decided
- [ ] Report is self-contained for its stated audience
- [ ] For `gh-comment`: body produced; posting only after explicit user confirmation

## QA Commands

`qa qa1` runs Gate A checklist · `qa qa2` runs Gate D checklist · `qa all` runs both · `qa state-check` reconciles disk artifacts vs `.ocr/tree-state.json` and repairs drift.
