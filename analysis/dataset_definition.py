from ehrql import Dataset
from ehrql.tables.beta.tpp import patients, practice_registrations

dataset = Dataset()

index_date = "2020-03-31"

has_registration = practice_registrations.for_patient_on(
    index_date
).exists_for_patient()

dataset.age = patients.age_on(index_date)

dataset.define_population(has_registration & (dataset.age > 17))
