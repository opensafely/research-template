# Note: If you are using cohortextrator to define your study population you need to
# (1) delete the ehrQL action in the project.yaml file (lines 14-18) and
# (2) delete the dataset_definition.py file.

from cohortextractor import StudyDefinition, patients, codelist, codelist_from_csv  # NOQA


study = StudyDefinition(
    default_expectations={
        "date": {"earliest": "1900-01-01", "latest": "today"},
        "rate": "uniform",
        "incidence": 0.5,
    },
    population=patients.registered_with_one_practice_between(
        "2019-02-01", "2020-02-01"
    ),
)
