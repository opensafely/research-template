# Repository agent skills

Codex discovers repository-scoped skills in this directory automatically. No
network download or Codespace setup step is required.

## ehrQL dataset authoring

`skills/ehrql-dataset-authoring` is a vendored and locally adapted snapshot of
the [ehrql-codex skill](https://github.com/sebbacon/ehrql-codex/tree/main/.codex/skills/ehrql-dataset-authoring).
It contains guidance for editing `analysis/dataset_definition.py`, writing
assurance tests, and running ehrQL against dummy data.

The local adaptations use the `ehrql` executable supplied by the OpenSAFELY
Codespace image and prevent generic project scaffolding in this already
initialised research repository.

To update the skill, download the upstream directory to a temporary location,
compare it with the vendored copy, reapply the Codespace-specific adaptations,
and commit the reviewed diff. Do not download the skill at Codespace startup or
track upstream `main` dynamically.
