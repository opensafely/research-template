---
applyTo: "analysis/**,codelists/**,dummy-tables/**"
---

# ehrQL dataset authoring

Apply this when creating or modifying this project's ehrQL dataset definition
(`analysis/dataset_definition.py`) or its assurance tests
(`analysis/test_dataset_definition.py`).

The full guidance and a bundled ehrQL documentation library live in
[`.github/skills/ehrql-dataset-authoring/`](../skills/ehrql-dataset-authoring/SKILL.md).
Open `SKILL.md` and the files under `references/upstream/` on demand — this file
is the summary, not a replacement.

## Gates

- This repository is already an initialised OpenSAFELY project. Do not scaffold a
  new one.
- Do not report a dataset-definition change as complete until **all** of:
  - `analysis/test_dataset_definition.py` has assurance scenarios covering the changed behaviour;
  - assurance tests pass;
  - dummy-data generation from `analysis/dataset_definition.py` passes.
- If a required command cannot run, stop and report the specific blocker. Never
  silently skip a validation step.

## Environment and commands

ehrQL runs through the OpenSAFELY CLI, pinned to `ehrql:v1` (matching
`project.yaml`). Check it: `opensafely exec ehrql:v1 --version`, then prefix every
ehrQL subcommand with `opensafely exec ehrql:v1`. On the OpenSAFELY Codespace
image `ehrql` is also on `PATH`, so a bare `ehrql <subcommand>` is equivalent
there. If neither runs, stop and report the blocker — there is no `uv`/`.venv`
fallback in this repo.

Runbook:

- Generate dummy data:
  `opensafely exec ehrql:v1 generate-dataset analysis/dataset_definition.py --output output/dataset.csv`
- With custom dummy tables:
  `opensafely exec ehrql:v1 generate-dataset analysis/dataset_definition.py --dummy-tables dummy-tables/ --output output/dataset.csv`
- Run assurance tests:
  `opensafely exec ehrql:v1 assure analysis/test_dataset_definition.py`

## Working style

- Prize legibility over cleverness. Give subqueries, date cutoffs, codelists, and
  derived concepts clear intermediate names.
- Comment the dataset definition by default, especially where a block maps back to
  the study spec, a named rule, a date window, or an exclusion. Make it obvious
  which part of the spec each block implements and why it exists.
- Assurance tests are required for **every** dataset-definition change, not only
  complex ones. Each patient scenario must carry a comment stating exactly what
  logic it verifies (inclusion on a qualifying path, exclusion by a specific
  rule, a boundary-date condition, a no-matching-event case, …).
- Organise scenarios so they scan easily: `in population`, `excluded`,
  `boundary date`, `no matching event`, `multiple matching events`, and similar.

## Codelists

Use SNOMED CT codelists unless the study spec explicitly requires another system.

- Find them at opencodelists.org via a site-restricted web search
  (`site:opencodelists.org <concept> SNOMED`); use specific terms
  ("type 2 diabetes mellitus", not "diabetes").
- Choose between candidates by, in order: **organisation** (official — NHS, NHSE,
  PHE, UKHSA, OpenSAFELY, PRIMIS, named academic groups — over personal/unnamed);
  **recency and completeness**; **name match**.
- On each codelist import, add a comment giving a **confidence level**
  (`HIGH` / `MEDIUM` / `LOW`) and naming any **other candidates** you considered.
- Put a visible WARNING block at the top of the codelist imports noting that every
  codelist needs expert clinical review before production use.
- If no SNOMED CT list exists on opencodelists.org, say so in a comment and tell
  the user to search manually.

## Workflow

1. Read the user's spec and the current `analysis/dataset_definition.py`.
2. Read `.github/skills/ehrql-dataset-authoring/references/source-index.md` for the doc map.
3. Open only the upstream docs you need from `references/upstream/`.
4. Implement the definition with explicit names and readable structure.
5. Add or update assurance tests in `analysis/test_dataset_definition.py`.
6. Comment each assurance-test case with the exact rule or branch it checks.
7. Run assurance tests and fix any failures.
8. Run dummy-data generation and fix any failures.
9. Update `README.md`: describe the brief in plain language and give the exact
   command to generate a dataset from the definition.

After the definition and tests are done, offer to write a custom dummy-table
generator when realistic data would help exercise edge cases — see the
"Custom dummy-table generator" section of `SKILL.md` for how to build one.
