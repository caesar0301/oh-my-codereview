# WORKFLOW — Graph-Driven Runs

`workflow [--pattern P]` executes a full pattern as a guided multi-step run.

## Behavior

1. Read `.ocr/pattern.json` (default **standard**)
2. Walk the pattern graph node by node, running each op's full contract
3. Pause at the pattern's gates (see `../GATES.md`); rapid skips all
4. Update `.ocr/tree-state.json` after every node
5. On interruption, resume from tree-state: completed nodes are not re-run

## When to use

- "Run the whole review" on a PR without stepping through ops manually
- Re-running a pattern after switching (e.g. `workflow --pattern security-focus`)

For a single-step interaction ("look at this diff"), invoke ops directly instead — the graph is guidance, not a straitjacket.
