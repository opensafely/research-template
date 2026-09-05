# AGENTS.md

This is an [OpenSAFELY](https://opensafely.org) research repository. It is already
an initialised OpenSAFELY project — do not scaffold a new one.

## ehrQL dataset authoring

When the task involves the ehrQL dataset definition (`analysis/dataset_definition.py`)
or its assurance tests (`analysis/test_dataset_definition.py`), follow
[`.github/instructions/ehrql.instructions.md`](.github/instructions/ehrql.instructions.md).

That file summarises the workflow. The full guidance and a bundled ehrQL
documentation library are in
[`.github/skills/ehrql-dataset-authoring/`](.github/skills/ehrql-dataset-authoring/SKILL.md)
(`SKILL.md` plus reference docs under `references/upstream/`) — open them as needed.

Key gates:

- Every dataset-definition change needs assurance-test scenarios covering the new
  behaviour.
- Do not report a change complete until assurance tests **and** dummy-data
  generation both pass.
- If a required command cannot run, stop and report the blocker; never skip a
  validation step.
