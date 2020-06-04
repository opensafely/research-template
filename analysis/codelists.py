#Import codelists and define for study_definition.py

from datalab_cohorts import (
    codelist_from_csv,
    codelist,
    )


# OUTCOME CODELISTS


# DEMOGRAPHIC CODELIST
ethnicity_codes = codelist_from_csv(
    "codelists/opensafely-ethnicity.csv",
    system="ctv3",
    column="Code",
    category_column="Grouping_6",
)

# SMOKING CODELIST
clear_smoking_codes = codelist_from_csv(
    "codelists/opensafely-smoking-clear.csv",
    system="ctv3",
    column="CTV3Code",
    category_column="Category",
)

unclear_smoking_codes = codelist_from_csv(
    "codelists/opensafely-smoking-unclear.csv",
    system="ctv3",
    column="CTV3Code",
    category_column="Category",
)

# CLINICAL CONDITIONS CODELISTS
heart_failure_codes = codelist_from_csv(
    "codelists/opensafely-heart-failure.csv",
    system="ctv3",
    column="CTV3ID",
)

# MEDICATIONS
statin_med_codes = codelist_from_csv(
    "codelists/opensafely-statin-medication.csv",
    system="snomed", 
    column="id",
)

