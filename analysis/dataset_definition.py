# Note: If you are using ehrQL to define your study population you need to:
# (1) uncomment the ehrQL action in the project.yaml file (lines 14-18),
# (2) delete the cohort-extractor action from the project.yaml file (lines 8-12), and
# (3) delete the study_definition.py file.

from ehrql import Dataset
from ehrql.tables.beta.tpp import patients, practice_registrations

dataset = Dataset()

index_date = "2020-03-31"

has_registration = practice_registrations.for_patient_on(
    index_date
).exists_for_patient()

dataset.age = patients.age_on(index_date)

dataset.define_population(has_registration & (dataset.age > 17))
