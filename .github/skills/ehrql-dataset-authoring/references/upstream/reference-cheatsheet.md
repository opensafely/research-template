# ehrQL cheatsheet

## Frames

Patient frames contain one row per patient

```
patient id date_of_birth sex
123        1980-01-01    m
456        1990-06-06    f
789        2020-01-01    i
```

Event frames contain many rows per patient

```
patient_id event_date event_code
123        2020-04-01 abc
123        2020-04-02 def
123        2021-01-01 ghi
```

## Simple dataset

```python
from ehrql import create_dataset
from ehrql.tables.core import patients
from ehrql.tables.tpp import addresses

dataset = create_dataset()
...
dataset.define_population(
    patients.exists_for_patient()
)
```

## Codelists

```python
statin_medications = codelist_from_csv("codelists/dm_cod.csv", column="code")
```

## Show

```python
from ehrql import show
show(patients)
```

## Tables

### core

```python
clinical_events
medications
ons_deaths
patients
practice_registrations
```

#### selected values

```python
clinical_events.date
clinical_events.snomedct_code
clinical_events.numeric_value
patients.date_of_birth
patients.sex
patients.date_of_death
```

### tpp

```python
addresses
apcs
apcs_cost
appointments
clinical_events
clinical_events_ranges
covid_therapeutics
ec
ec_cost
emergency_care_attendances
ethnicity_from_sus
household_memberships_2020
medications
occupation_on_covid_vaccine_record
ons_deaths
opa
opa_cost
opa_diag
opa_proc
open_prompt
parents
patients
practice_registrations
sgss_covid_all_tests
ukrr
vaccinations
wl_clockstops
wl_openpathways
```

#### selected values

```python
addresses.address_id
addresses.start_date
addresses.end_date
addresses.imd_rounded
apcs.admission_date
medications.date
medications.dmd_code
practice_registration.start_date
practice_registration.end_date
practice_registration.practice_pseudo_id
practice_registration.practice_stp
ukrr.renal_centre
vaccinations.date
vaccinations.product_name
```

## adding data to a dataset

### from a patient frame

value series

```python
dataset.sex = patients.sex
dataset.date_of_birth = patients.date_of_birth
dataset.birth_year = patients.date_of_birth.year
dataset.age = patients.age_on("2024-01-01")
```

boolean series

```python
dataset.died_with_X = ons_deaths.cause_of_death_is_in(cause_of_death_X_codelist)
```

### from an event frame

value series

```python
dataset.imd = addresses.for_patient_on("2023-01-01").imd_rounded
```

aggregated value series

```python
dataset.mean_hba1c = clinical_events.where(
    clinical_events.snomedct_code.is_in(hba1c_codelist)
).where(
    clinical_events.date.is_on_or_after("2022-07-01")
).numeric_value.mean_for_patient()
```

sorted value series

```python
dataset.first_statin_prescription_date = medications.where(
    medications.dmd_code.is_in(statin_medications)
).sort_by(
    medications.date
).first_for_patient().date
```

boolean series

```python
dataset.has_had_asthma_diagnosis = clinical_events.where(
    clinical_events.snomedct_code.is_in(asthma_codelist)
).exists_for_patient()
```

boolean series with a date range

```python
dataset.has_recent_cardiac_admission = apcs.where(
    apcs.primary_diagnosis.is_in(cardiac_diagnosis_codes)
).where(
    apcs.admission_date.is_on_or_between("2022-07-01", "2023-01-01")
).exists_for_patient()
```

## logic operators

* `==` equals
* `!=` not equals
* `&` and
* `|` or
* `~` not
* `>` greater than
* `>=` greater than or equals
* `<=` less than or equals
* `<` less than

## selected functions

### common

```python
.is_null()
.is_not_null()
.is_in()
.contains()
.map_values()
```

### aggregation

```python
.minimum_for_patient()
.maximum_for_patient()
.sum_for_patient()
.mean_for_patient()
.count_for_patient()
```

### date

```python
.is_before(other)
.is_on_or_before(other)
.is_after(other)
.is_on_or_after(other)
.is_between_but_not_on(start, end)
.is_on_or_between(start, end)
.is_during(interval)
```

### sorted event frames

```python
.first_for_patient()
.last_for_patient()
```
