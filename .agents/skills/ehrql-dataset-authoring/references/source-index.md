# ehrQL doc index for this repo's agent skill

## Local repo context

- Main dataset-definition file: `analysis/dataset_definition.py`
- Primary command for dummy-data smoke tests:
  `ehrql generate-dataset analysis/dataset_definition.py --output output/dataset.csv`
- Suggested assurance-test file:
  `analysis/test_dataset_definition.py`
- Direct assurance command:
  `ehrql assure analysis/test_dataset_definition.py`

## Source URLs

- `language-specs.md`
  `https://raw.githubusercontent.com/opensafely-core/ehrql/refs/heads/main/docs/includes/generated_docs/specs.md`
  (tables stripped; only headings and code examples retained)
- `reference-cheatsheet.md`
  `https://github.com/opensafely-core/ehrql/edit/main/docs/reference/cheatsheet.md`
- `how-to-examples.md`
  `https://github.com/opensafely-core/ehrql/edit/main/docs/how-to/examples.md`
- `how-to-define-population.md`
  `https://github.com/opensafely-core/ehrql/edit/main/docs/how-to/define-population.md`
- `how-to-dummy-data.md`
  `https://github.com/opensafely-core/ehrql/edit/main/docs/how-to/dummy-data.md`
- `how-to-dummy-measures-data.md`
  `https://github.com/opensafely-core/ehrql/edit/main/docs/how-to/dummy-measures-data.md`
- `reference-language.md`
  `https://github.com/opensafely-core/ehrql/edit/main/docs/reference/language.md`
- `how-to-assign-multiple-columns.md`
  `https://github.com/opensafely-core/ehrql/edit/main/docs/how-to/assign-multiple-columns.md`
- `how-to-test-dataset-definition.md`
  `https://github.com/opensafely-core/ehrql/edit/main/docs/how-to/test-dataset-definition.md`
- `how-to-parameterise-ehrql.md`
  `https://github.com/opensafely-core/ehrql/edit/main/docs/how-to/parameterise-ehrql.md`

## Doc summaries

### `language-specs.md`

Exhaustive behavioural specification for every ehrQL operation, organised into 15 sections: filtering event frames, row selection, aggregations (count, min, max, sum, mean), series combination, boolean logic, integer/float arithmetic, codelist containment, case/when expressions, date arithmetic and comparisons, string operations, population definition, and float operations. Each subsection is a named operation with a short Python example showing the exact syntax. Tables stripped; use `reference-language.md` for prose semantics and `how-to-examples.md` for real-table patterns.

### `reference-cheatsheet.md`

Quick syntax page. It distinguishes patient and event frames, lists common tables and selected columns, and gives short examples for the most common query patterns: `define_population`, codelists, filtering, sorted event selection, aggregations, date predicates, and boolean logic.

### `how-to-examples.md`

Large example bank organised mostly by source table. Useful when you want a concrete pattern for a demographic field, clinical event flag, first or last event, count, aggregation, registration logic, vaccination logic, or date-window query. Treat it as a cookbook.

### `how-to-define-population.md`

Short guide dedicated to population logic. It shows how to express inclusion criteria, combine them with `&` and `|`, use `~` for exclusion, and keep parentheses explicit.

### `how-to-dummy-data.md`

Explains three dataset-testing modes with dummy data:

- let ehrQL generate dummy patients from the definition
- provide a dummy dataset file with expected output columns
- provide dummy backend tables and let ehrQL compute from them

This is the main reference for quick smoke tests and deeper local validation.

### `how-to-dummy-measures-data.md`

Parallel guide for measures definitions rather than datasets. It is usually irrelevant for this repo unless the task changes scope from datasets to measures.

### `reference-language.md`

Canonical language reference. It describes datasets, frames, series, date arithmetic, codelists, functions, measures, parameters, and permissions. Use this for precise semantics rather than examples.

### `how-to-assign-multiple-columns.md`

Shows how to add columns programmatically with `dataset.add_column()`. Helpful when many output columns follow the same pattern and a loop or mapping is clearer than repeated manual assignment.

### `how-to-test-dataset-definition.md`

Main assurance-testing guide. It explains the nested `test_data` structure, how to encode one-row and many-row tables, how to state `expected_in_population`, how to check `expected_columns`, and how to use `assure` as unit-test-style validation for ehrQL.

### `how-to-parameterise-ehrql.md`

Explains `get_parameter(...)` so one definition can be reused across dates, regions, codelists, or other inputs. Use this when the user wants a reusable definition instead of multiple near-duplicate files.

## Authoring guidance for agents

- Write definitions in `analysis/dataset_definition.py`.
- Translate the user's study spec into readable ehrQL with well-named intermediate expressions.
- Prefer explicit structure over compressed one-liners.
- Use comments when they help reviewers trace code back to the original requirement.
- Test every non-trivial change.
- At minimum, confirm that dummy data can be generated.
- For anything with branching or subtle logic, add assurance tests as well.
- Keep tests legible: organize them as patient scenarios that are easy to review.
