# Verdict Rubric

Map the findings set to a verdict mechanically. Severity is counted after Gate A (and any recheck), from confirmed findings only — withdrawn/resolved findings do not count.

## Severity definitions

| Severity    | Definition                                                                                      | Merge posture                                       |
| ----------- | ----------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| **blocker** | Bug, vulnerability, or data-loss path reachable by the change as written                        | Must fix before merge                               |
| **major**   | Wrong edge case, missing test for a risky path, API misuse, breaking contract without migration | Should fix; merge acceptable with tracked follow-up |
| **minor**   | Real improvement, limited consequence                                                           | Non-binding                                         |
| **nit**     | Taste, naming, style — no behavioral consequence                                                | Non-binding                                         |

## Verdict mapping

| Condition            | Verdict              |
| -------------------- | -------------------- |
| 0 blockers, 0 majors | **PASS**             |
| 0 blockers, ≥1 major | **PASS_WITH_ISSUES** |
| ≥1 blocker           | **FAIL**             |

## Modifiers

- **Strictness=strict** (e.g. Security-Focus pattern): ≥1 major ⇒ FAIL instead of PASS_WITH_ISSUES
- **possible-intent findings** unresolved at report time: count as majors and name them in the verdict justification
- **Softening**: any downgrade below the rubric must name the findings moved, the reason, and who decided — recorded in the report changelog and `.ocr/quality-gates/`
- **Unverifiable claims**: findings with confidence=low and no mechanical check never justify a blocker on their own; run the check or ask the author
