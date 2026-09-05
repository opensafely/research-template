---
name: ehrql-dataset-authoring
description: Use when writing or editing an ehrQL dataset definition (`analysis/dataset_definition.py`) or related assurance tests. This skill explains the ehrQL authoring workflow, how to run ehrQL for dummy data, how to organise and run assurance tests, and what each bundled upstream ehrQL doc covers.
---

# ehrQL Dataset Authoring

Use this skill when the user wants to create or modify this project's ehrQL dataset definition or run tests against it.

## Required gates

This repository is already an initialised OpenSAFELY project. Do not scaffold a
new one. Before editing, confirm `analysis/dataset_definition.py` exists and an
ehrQL command runs (see Environment below).

Do not report a dataset-definition change as complete until all of the following are true:

- `analysis/test_dataset_definition.py` contains assurance scenarios for the changed behaviour.
- Assurance tests pass.
- Dummy-data generation from `analysis/dataset_definition.py` passes.

If a required command cannot run, stop and report the specific blocker. Do not silently skip either validation step.

## Environment

This project runs ehrQL through the OpenSAFELY CLI, pinned to `ehrql:v1` — the
same version `project.yaml` uses. Check it is available:

```
opensafely exec ehrql:v1 --version
```

Prefix every ehrQL subcommand with `opensafely exec ehrql:v1`. The OpenSAFELY
Codespace image also exposes `ehrql` directly on `PATH`, so a bare
`ehrql <subcommand> ...` is an equivalent there. If neither runs, stop and report
the blocker — there is no `uv`/`.venv` fallback in this repo.

## Local contract

- Main file: `analysis/dataset_definition.py`
- Primary job: write or update ehrQL dataset definitions from the user's spec.
- The standard local smoke test is generating dummy data from that file.
- The stronger validation path is adding assurance tests that make the expected patient-level behaviour explicit.

## Working style

- Prize legibility over cleverness.
- Use clear intermediate names for subqueries, date cutoffs, codelists, and derived concepts.
- Add short, informative comments in the dataset definition by default, especially where a block maps back to the user's specification, a named rule, a date window, or an exclusion.
- Comments should make it obvious which part of the spec the code is implementing and why that block exists.
- Assurance tests are always required for dataset-definition changes.
- In assurance tests, every patient scenario must include comments stating exactly what logic it is verifying, for example inclusion on a qualifying path, exclusion by a specific rule, a boundary-date condition, or a no-matching-event case.
- When you add tests, organize scenarios so they are easy to scan:
  `in population`, `excluded`, `boundary date`, `no matching event`, `multiple matching events`, and similar slices.

## Codelists

Always use SNOMED CT codelists unless the study spec explicitly requires a different coding system.

### Finding codelists

Search for codelists at opencodelists.org using a web search restricted to that site. Example query pattern:

```
site:opencodelists.org <condition or concept> SNOMED
```

Add keywords to narrow results — include synonyms, clinical context, or the specific concept hierarchy (e.g. "type 2 diabetes mellitus" rather than just "diabetes"; "asthma diagnosis" rather than "asthma").

When several candidate codelists appear, select using this priority order:

1. **Organisation** — prefer official organisations: NHS, NHSE, PHE, UKHSA, OpenSAFELY, PRIMIS, or named academic groups over personal or unnamed publishers.
2. **Recency and completeness** — prefer a more recent version or update date; prefer a codelist that looks more complete (larger, covers the full concept hierarchy) over a partial or stub list.
3. **Name match** — prefer a codelist whose name closely matches the concept being coded.

If you cannot find a SNOMED CT codelist on opencodelists.org, note that explicitly in a comment and suggest the user search manually.

### Codelist import comments

When importing a codelist in the dataset definition, add an inline comment on the same line or the line above that states:

- **Confidence level**: `HIGH`, `MEDIUM`, or `LOW`
  - `HIGH`: strong name match, official org, recent, looks complete
  - `MEDIUM`: reasonable match but some uncertainty about coverage, recency, or org
  - `LOW`: best available but notable concerns (old, partial, unofficial, or ambiguous name)
- **Other candidates**: if you found other plausible codelists, name them briefly so a reviewer can check

Example:

```python
# CONFIDENCE: HIGH — NHS/OpenSAFELY list, recent, full concept hierarchy
# Other candidates: codelist/user/asthma-snomed-v1 (older, partial)
asthma_codes = codelist_from_csv("codelists/nhsd-primary-care-domain-refsets-ast_cod.csv", column="code")
```

### WARNING comment

Whenever codelists are imported, add a clearly visible block comment near the top of the imports section:

```python
# ============================================================
# WARNING: All codelists below must be carefully reviewed.
# The wrong codelist may have been selected, or a codelist
# may be out of date. Do not use this definition in
# production without expert clinical review of every codelist.
# ============================================================
```

## Runbook

- Generate dummy data: `opensafely exec ehrql:v1 generate-dataset analysis/dataset_definition.py --output output/dataset.csv`
- Generate dummy data with custom dummy tables: `opensafely exec ehrql:v1 generate-dataset analysis/dataset_definition.py --dummy-tables dummy-tables/ --output output/dataset.csv`
- Preferred assurance-test file location: `analysis/test_dataset_definition.py`
- Run assurance tests: `opensafely exec ehrql:v1 assure analysis/test_dataset_definition.py`

(On the OpenSAFELY Codespace image you can drop the `opensafely exec ` prefix and call `ehrql` directly.)

## Required workflow

1. Read the user's spec and the current `analysis/dataset_definition.py`.
2. Read `references/source-index.md` for the local doc map.
3. Open only the upstream docs you need from `references/upstream/`.
4. Implement the dataset definition with explicit names and readable structure.
5. Add or update assurance tests in `analysis/test_dataset_definition.py`.
6. Ensure each assurance-test case is commented so a reviewer can see the exact rule or branch being checked.
7. Run assurance tests and fix any failures.
8. Run dummy-data generation and fix any failures.
9. Update `README.md` to reflect the current state of the dataset definition: describe the brief (what the definition is trying to implement, in plain language) and include the exact command to generate a dataset from it.

Always test. Dummy-data generation checks that the definition compiles and can produce output. Assurance tests are mandatory and check the exact behaviour on representative patients.

## Upstream doc map

- `references/upstream/language-specs.md`
  Exhaustive operation-by-operation specification (15 sections, ~200 named operations): filtering, row selection, aggregations, boolean/integer/float arithmetic, codelist containment, case/when, date arithmetic, string operations, population definition. Each entry is a heading plus a one-line Python example. Use this to verify exact method signatures or discover lesser-known operations.
- `references/upstream/reference-cheatsheet.md`
  Quick syntax refresher: patient vs event frames, common tables, codelists, `where`, `sort_by`, `first_for_patient`, `last_for_patient`, aggregations, date predicates, and operators.
- `references/upstream/how-to-examples.md`
  Large cookbook of query patterns across tables such as patients, addresses, registrations, clinical events, medications, APCS, and vaccinations. Best used as a pattern library rather than read end to end.
- `references/upstream/how-to-define-population.md`
  Focused guidance on `define_population()`, logical operators, required parentheses, and the common inclusion plus exclusion pattern `inclusion & ~exclusion`.
- `references/upstream/how-to-dummy-data.md`
  Explains the three dummy-data modes: auto-generated dummy data, a supplied dummy dataset file, or supplied dummy tables. Relevant whenever you need to smoke-test a dataset definition.
- `references/upstream/how-to-dummy-measures-data.md`
  Equivalent dummy-data guidance for measures definitions. Usually irrelevant unless the task shifts from datasets to measures.
- `references/upstream/reference-language.md`
  Canonical language reference for datasets, frames, series, date arithmetic, codelists, functions, measures, parameters, and permissions. Use this when semantics matter.
- `references/upstream/how-to-assign-multiple-columns.md`
  Shows when to use `dataset.add_column()` and how to build repeated columns programmatically from a mapping.
- `references/upstream/how-to-test-dataset-definition.md`
  Main guide for assurance tests. Covers the nested `test_data` structure, expected population membership, expected output columns, and how to encode one-row and many-row tables.
- `references/upstream/how-to-parameterise-ehrql.md`
  Shows how to reuse one definition with `get_parameter(...)` for dates, regions, codelists, and other user arguments.

## Testing expectations

- Minimum: run dummy-data generation after every substantive edit.
- Minimum: run dummy-data generation and assurance tests after every substantive edit.
- Assurance tests are required for every dataset-definition change, not only for complex logic.
- In assurance tests, make the patient stories obvious. A small number of well-named scenarios is better than a dense unreadable fixture.
- Every test case should include comments that explicitly describe the rule being checked, such as why the patient is included, why they are excluded, or which boundary/window behaviour is under test.
- When dataset logic follows a written specification, annotate the corresponding code blocks with comments that point back to the specification text rather than leaving the mapping implicit.
- After finishing the ehrQL definition and assurance tests, proactively offer to write a custom dummy-table generator when that would help exercise edge cases, clarify expected outputs, or make the spec easier to validate visually.

## Custom dummy-table generator

When writing a `scripts/generate_dummy_tables.py` (or equivalent), produce data that looks like realistic underlying clinical data, not just the minimum needed to satisfy ehrQL's column constraints.

### Planning step (do this before writing code)

Before generating any events, reason about the domain being modelled:

1. **Population size and prevalence** — pick a realistic N (e.g. 5 000 patients) and realistic condition prevalence by demographic group. Use published rates where known (e.g. QOF register rates, ONS age distributions). Document the rates as named constants.
2. **Proportions and ratios** — if the ehrQL computes numerators and denominators (indicators, coverage rates, achievement percentages), plan what realistic achievement rates look like and work backwards to the fractions of patients in each outcome bucket. Name every fraction as a constant.
3. **Time span** — identify every date column the ehrQL reads. If the underlying real-world phenomenon (diagnoses, annual reviews, prescriptions, referrals) recurs over years, generate events across the full plausible history, not just the measurement window. Use the measurement-window dates only to govern current-period outcomes.
4. **Event patterns** — for recurring events (annual reviews, repeat prescriptions, follow-up appointments), generate one event per recurrence period across the patient's history, with a realistic non-attendance rate. Do not generate only the events the ehrQL's WHERE clauses will touch.

### Implementation principles

- Declare every rate, fraction, and count as a named module-level constant with a short comment explaining its real-world meaning. Never embed magic numbers in logic.
- Assign each patient a *profile* dict before generating any events. The profile encodes their outcome bucket (e.g. `{"on_register": True, "ast007_outcome": "numerator", ...}`). Generate events deterministically from the profile so the mapping between input fractions and output rows is transparent.
- For recurring events across prior periods, loop over each period (e.g. each QOF year) and apply the historical rate. This ensures event-count time series span the full history rather than spiking only at the measurement window.
- Use `numpy.random.default_rng(seed)` with a fixed seed for reproducibility.
- Print a summary table of expected vs generated counts (register size, denominator, numerator, achievement rate) so the user can sanity-check the output without opening the CSV.

### What NOT to do

- Do not generate dates solely in the range needed to pass ehrQL's filter predicates. If reviews happen annually, generate them annually across the patient's history.
- Do not hardcode representative proportions as inline literals — name them.
- Do not generate only the tables or columns the current ehrQL reads; generate all standard tables (patients, registrations, clinical_events, medications) with enough realism that the data could plausibly feed a different query on the same population.

### README update after generating custom dummy tables

After successfully generating custom dummy tables, update `README.md` with a dedicated section that covers:

1. **What the dummy data represents** — describe the patient population, prevalence rates, and scenario coverage in plain language so a reader understands what the data is modelling.
2. **How to regenerate it** — the exact command to re-run the generator script (e.g. `python scripts/generate_dummy_tables.py`).
3. **How to use it with ehrQL** — the exact `ehrql generate-dataset` command that points at the dummy tables directory, for example:
   ```
   opensafely exec ehrql:v1 generate-dataset analysis/dataset_definition.py \
     --dummy-tables dummy-tables/ \
     --output output/dataset.csv
   ```
