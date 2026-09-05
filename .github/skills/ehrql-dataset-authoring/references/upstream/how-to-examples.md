## How to use this page

You can either read this page from start to end
to get an idea of the kinds of queries you can make with ehrQL.

Or you can use the navigation bar at the top-right of this page,
to see a list of the examples,
and then jump to a specific example of interest.

The examples are organised firstly by the table which they pull data from -
for a more complete guide to the tables, refer to the
[Table Schemas](../reference/schemas.md) section of the
ehrQL documentation.

## Understanding these examples

### The populations defined with `define_population()`

In each of these examples,
we specify that the population is **all patients**
via `dataset.define_population(patients.exists_for_patient())`.

In practice,
you will likely want to adapt an example to filter to a specific population of interest.
Refer to the [`define_population()` documentation](../reference/language.md#Dataset.define_population).

### Some examples using `codelist_from_csv()`

:warning: Some examples refer to CSV codelists using the
`codelist_from_csv` function,
but are incomplete.
To actually use these code example,
you will need to correctly complete the function call.
The codelists are not provided as a part of these examples.

For example, instead of:

```python
asthma_codelist = codelist_from_csv("XXX", column="YYY")
```

you will need a line more like:

```python
asthma_codelist = codelist_from_csv("your-asthma-codelist.csv", column="code")
```

which provides the filename `your-asthma-codelist.csv`
and the name of the CSV column with codes.

#### Using codelists with category columns

Some codelists will have a category column that groups individual codes into categories. For example, [this codelist for ethnicity](https://www.opencodelists.org/codelist/opensafely/ethnicity-snomed-0removed/2e641f61/) has 2 category columns, which represent categories at both 6 and 16 levels. To make use of these categories, you can use `codelist_from_csv()` as follows:

```python
ethnicity_codelist = codelist_from_csv("ethnicity_codelist_with_categories", column="snomedcode", category_column="Grouping_6")
```

If you include an argument for `category_column`, the codelist returned will be a *dictionary* mapping individual codes to their respective categories. Without the `category_column` argument, the codelist returned will be a *list* of codes.

You can see an example of [how to access these categories within your dataset definition ](#finding-each-patients-ethnicity) below.

## Patients

Examples for the [patients table](../reference/schemas/core.md#patients).

### Finding patient demographics

#### Finding each patient's sex

```ehrql
from ehrql import create_dataset
from ehrql.tables.core import patients

dataset = create_dataset()
dataset.sex = patients.sex
dataset.define_population(patients.exists_for_patient())
```

The possible values are "female", "male", "intersex", and "unknown".

#### Finding each patient's date of birth

```ehrql
from ehrql import create_dataset
from ehrql.tables.core import patients

dataset = create_dataset()
dataset.date_of_birth = patients.date_of_birth
dataset.define_population(patients.exists_for_patient())
```

#### Finding each patient's age

```ehrql
from ehrql import create_dataset
from ehrql.tables.core import patients

dataset = create_dataset()
dataset.age = patients.age_on("2023-01-01")
dataset.define_population(patients.exists_for_patient())
```

Alternatively, using a native Python `date`:

```ehrql
from datetime import date
from ehrql import create_dataset
from ehrql.tables.core import patients

dataset = create_dataset()
dataset.age = patients.age_on(date(2023, 1, 1))
dataset.define_population(patients.exists_for_patient())
```

Or using an `index_date` variable:

```ehrql
from ehrql import create_dataset
from ehrql.tables.core import patients

index_date = "2023-01-01"
dataset = create_dataset()
dataset.age = patients.age_on(index_date)
dataset.define_population(patients.exists_for_patient())
```

#### Assigning each patient an age band

```ehrql
from ehrql import create_dataset, case, when
from ehrql.tables.core import patients

dataset = create_dataset()
age = patients.age_on("2023-01-01")
dataset.age_band = case(
        when(age < 20).then("0-19"),
        when(age < 40).then("20-39"),
        when(age < 60).then("40-59"),
        when(age < 80).then("60-79"),
        when(age >= 80).then("80+"),
        otherwise="missing",
)
dataset.define_population(patients.exists_for_patient())
```

#### Finding each patient's date of death in their primary care record

```ehrql
from ehrql import create_dataset
from ehrql.tables.core import patients

dataset = create_dataset()
dataset.date_of_death = patients.date_of_death
dataset.define_population(patients.exists_for_patient())
```

:notepad_spiral: This value comes from the patient's EHR record. You can find more information about the accuracy of this value in the [reference schema](../reference/schemas/core.md#recording-of-death-in-primary-care).

## ONS Deaths

Examples for the [ons_deaths table](../reference/schemas/core.md#ons_deaths).

### Finding patient demographics

#### Finding each patient's date, underlying_cause_of_death, and first noted additional medical condition noted on the death certificate from ONS records

```ehrql
from ehrql import create_dataset
from ehrql.tables.core import ons_deaths, patients

dataset = create_dataset()
dataset.date_of_death = ons_deaths.date
dataset.underlying_cause_of_death = ons_deaths.underlying_cause_of_death
dataset.cause_of_death = ons_deaths.cause_of_death_01
dataset.define_population(patients.exists_for_patient())
```

:notepad_spiral: There are currently [multiple](https://github.com/opensafely-core/ehrql/blob/d29ff8ab2cebf3522258c408f8225b7a76f7b6f2/ehrql/tables/beta/core.py#L78-L92) cause of death fields. We aim to resolve these to a single feature in the future.


#### Finding patients with a particular cause of death

The `ons_deaths` table has multiple "cause of death" fields. Using the
[`cause_of_death_is_in()`](../reference/schemas/core.md#ons_deaths.cause_of_death_is_in)
method we can match a codelist against all of these at once.

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import ons_deaths, patients

dataset = create_dataset()

cause_of_death_X_codelist = codelist_from_csv("XXX", column="YYY")

dataset.died_with_X = ons_deaths.cause_of_death_is_in(cause_of_death_X_codelist)
dataset.define_population(patients.exists_for_patient())
```

## Addresses

Examples for the [TPP addresses table](../reference/schemas/tpp.md#addresses).

### Finding attributes related to each patient's address as of a given date

#### Finding each patient's IMD rank

```ehrql
from ehrql import create_dataset
from ehrql.tables.tpp import addresses, patients

dataset = create_dataset()
dataset.imd = addresses.for_patient_on("2023-01-01").imd_rounded
dataset.define_population(patients.exists_for_patient())
```

The original IMD ranking is rounded to the nearest 100.
The rounded IMD ranking ranges from 0 to 32,800.

See [this code comment](https://github.com/opensafely-core/ehrql/blob/d29ff8ab2cebf3522258c408f8225b7a76f7b6f2/ehrql/tables/beta/tpp.py#L117-L123) about how we choose one address if a patient has multiple registered addresses on the given date.

#### Calculating each patient's IMD quintile and/or decile

```ehrql
from ehrql import create_dataset
from ehrql.tables.tpp import addresses, patients

dataset = create_dataset()

patient_address = addresses.for_patient_on("2023-01-01")
dataset.imd_quintile = patient_address.imd_quintile
dataset.imd_decile = patient_address.imd_decile
dataset.define_population(patients.exists_for_patient())
```

#### Finding each patient's rural/urban classification

```ehrql
from ehrql import create_dataset
from ehrql.tables.tpp import addresses, patients

dataset = create_dataset()
dataset.rural_urban = addresses.for_patient_on("2023-01-01").rural_urban_classification
dataset.define_population(patients.exists_for_patient())
```

The meaning of this value is as follows:

* 1 - Urban major conurbation
* 2 - Urban minor conurbation
* 3 - Urban city and town
* 4 - Urban city and town in a sparse setting
* 5 - Rural town and fringe
* 6 - Rural town and fringe in a sparse setting
* 7 - Rural village and dispersed
* 8 - Rural village and dispersed in a sparse setting

#### Finding each patient's MSOA

```ehrql
from ehrql import create_dataset
from ehrql.tables.tpp import addresses, patients

dataset = create_dataset()
dataset.msoa_code = addresses.for_patient_on("2023-01-01").msoa_code
dataset.define_population(patients.exists_for_patient())
```

#### Finding multiple attributes of each patient's address

```ehrql
from ehrql import create_dataset
from ehrql.tables.tpp import addresses, patients

dataset = create_dataset()
address = addresses.for_patient_on("2023-01-01")
dataset.imd_rounded = address.imd_rounded
dataset.rural_urban_classification = address.rural_urban_classification
dataset.msoa_code = address.msoa_code
dataset.define_population(patients.exists_for_patient())
```

## Practice Registrations

Examples for the [practice_registrations table](../reference/schemas/core.md#practice_registrations).

### Finding attributes related to each patient's GP practice as of a given date

#### Finding each patient's practice's pseudonymised identifier

```ehrql
from ehrql import create_dataset
from ehrql.tables.tpp import practice_registrations, patients

dataset = create_dataset()
dataset.practice = practice_registrations.for_patient_on("2023-01-01").practice_pseudo_id
dataset.define_population(patients.exists_for_patient())
```

#### Finding each patient's practice's STP

```ehrql
from ehrql import create_dataset
from ehrql.tables.tpp import practice_registrations, patients

dataset = create_dataset()
dataset.stp = practice_registrations.for_patient_on("2023-01-01").practice_stp
dataset.define_population(patients.exists_for_patient())
```

#### Finding each patient's practice's region

```ehrql
from ehrql import create_dataset
from ehrql.tables.tpp import practice_registrations, patients

dataset = create_dataset()
dataset.region = practice_registrations.for_patient_on("2023-01-01").practice_nuts1_region_name
dataset.define_population(patients.exists_for_patient())
```

#### Finding multiple attributes of each patient's practice

```ehrql
from ehrql import create_dataset
from ehrql.tables.tpp import practice_registrations, patients

dataset = create_dataset()
registration = practice_registrations.for_patient_on("2023-01-01")
dataset.practice = registration.practice_pseudo_id
dataset.stp = registration.practice_stp
dataset.region = registration.practice_nuts1_region_name
dataset.define_population(patients.exists_for_patient())
```

#### Excluding patients based on study dates

The following example ensures that the dataset only includes patients registered at a
single practice for the entire duration of the study, plus at least 3 months prior to the
study start.

```ehrql
from ehrql import create_dataset, codelist_from_csv, months
from ehrql.tables.tpp import patients, practice_registrations

study_start_date = "2022-01-01"
study_end_date = "2022-12-31"

dataset = create_dataset()

# find registrations that exist for the full study period, and at least 3 months
# prior
registrations = (
    practice_registrations.where(
        practice_registrations.start_date.is_on_or_before(study_start_date - months(3))
    )
    .except_where(
        practice_registrations.end_date.is_on_or_before(study_end_date)
    )
)

dataset.define_population(registrations.exists_for_patient())
```

## Clinical Events

Examples for the [clinical_events table](../reference/schemas/core.md#clinical_events).

### Finding patient demographics

#### Finding each patient's ethnicity

Ethnicity can be defined using a codelist. There are a lot of individual codes that can used to indicate a patients' fine-grained ethnicity. To make analysis more manageable, ethnicity is therefore commonly grouped into higher level categories. Above, we described how you can [import codelists that have a category column](#some-examples-using-codelist_from_csv). You can use a codelist with a category column to map clinical event codes for ethnicity to higher level categories as in this example:

```ehrql
from ehrql import create_dataset
from ehrql.tables.core import clinical_events, patients
from ehrql import codelist_from_csv

dataset = create_dataset()

ethnicity_codelist = codelist_from_csv(
    "ethnicity_codelist_with_categories",
    column="snomedcode",
    category_column="Grouping_6",
)

dataset.latest_ethnicity_code = (
    clinical_events.where(clinical_events.snomedct_code.is_in(ethnicity_codelist))
    .where(clinical_events.date.is_on_or_before("2023-01-01"))
    .sort_by(clinical_events.date)
    .last_for_patient()
    .snomedct_code
)
dataset.latest_ethnicity_group = dataset.latest_ethnicity_code.to_category(
    ethnicity_codelist
)
dataset.define_population(patients.exists_for_patient())
```

### Does each patient have an event matching some criteria?

#### Does each patient have a clinical event matching a code in a codelist?

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.has_had_asthma_diagnosis = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).exists_for_patient()
dataset.define_population(patients.exists_for_patient())
```

#### Does each patient have a clinical event matching a code in a codelist in a time period?

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.has_recent_asthma_diagnosis = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).where(
        clinical_events.date.is_on_or_between("2022-07-01", "2023-01-01")
).exists_for_patient()
dataset.define_population(patients.exists_for_patient())
```

### What is the first/last event matching some criteria?

The `first_for_patient()` and `last_for_patient()` methods can only be used on a sorted frame.
Frames can be sorted by calling the `sort_by()` method with the column to sort the frame by.

Note that NULL is considered smaller than any other value, so if you are trying to find the
first value in a column that contains NULLs, you may wish to filter out NULL values before sorting.

#### What is the earliest/latest clinical event matching some criteria?

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.first_asthma_diagnosis_date = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).where(
        clinical_events.date.is_on_or_after("2022-07-01")
).sort_by(
        clinical_events.date
).first_for_patient().date
dataset.define_population(patients.exists_for_patient())
```

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.last_asthma_diagnosis_date = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).where(
        clinical_events.date.is_on_or_after("2022-07-01")
).sort_by(
        clinical_events.date
).last_for_patient().date
dataset.define_population(patients.exists_for_patient())
```

#### What is the clinical event, matching some criteria, with the least/greatest value?

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

hba1c_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()

hba1c_events = clinical_events.where(
        clinical_events.snomedct_code.is_in(hba1c_codelist)
).where(
        # Note: filter out NULL numeric values before sorting
        clinical_events.numeric_value.is_not_null()
).where(
        clinical_events.date.is_on_or_after("2022-07-01")
)

earliest_min_hba1c_event = hba1c_events.sort_by(
        clinical_events.numeric_value, clinical_events.date
).first_for_patient()

earliest_max_hba1c_event = hba1c_events.sort_by(
        # Note the leading minus sign to sort numeric_value in reverse order
        -clinical_events.numeric_value, clinical_events.date
).first_for_patient()

latest_min_hba1c_event = hba1c_events.sort_by(
        # Note the leading minus sign to sort numeric_value in reverse order
        -clinical_events.numeric_value, clinical_events.date
).last_for_patient()

latest_max_hba1c_event = hba1c_events.sort_by(
        clinical_events.numeric_value, clinical_events.date
).last_for_patient()

dataset.date_of_first_min_hba1c_observed = earliest_min_hba1c_event.date
dataset.date_of_first_max_hba1c_observed = earliest_max_hba1c_event.date
dataset.date_of_last_min_hba1c_observed = latest_min_hba1c_event.date
dataset.date_of_last_max_hba1c_observed = latest_max_hba1c_event.date

dataset.value_of_first_min_hba1c_observed = earliest_min_hba1c_event.numeric_value
dataset.value_of_first_max_hba1c_observed = earliest_max_hba1c_event.numeric_value
dataset.value_of_last_min_hba1c_observed = latest_min_hba1c_event.numeric_value
dataset.value_of_last_max_hba1c_observed = latest_max_hba1c_event.numeric_value

dataset.define_population(patients.exists_for_patient())
```

### Getting properties of an event matching some criteria

#### What is the code of the first/last clinical event matching some criteria?

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.first_asthma_diagnosis_code = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).where(
        clinical_events.date.is_on_or_after("2022-07-01")
).sort_by(
        clinical_events.date
).first_for_patient().snomedct_code
dataset.define_population(patients.exists_for_patient())
```

#### What is the date of the first/last clinical event matching some criteria?

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.first_asthma_diagnosis_date = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).where(
        clinical_events.date.is_on_or_after("2022-07-01")
).sort_by(
        clinical_events.date
).first_for_patient().date
dataset.define_population(patients.exists_for_patient())
```

#### What is the code and date of the first/last clinical event matching some criteria?

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
first_asthma_diagnosis = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).where(
        clinical_events.date.is_on_or_after("2022-07-01")
).sort_by(
        clinical_events.date
).first_for_patient()
dataset.first_asthma_diagnosis_code = first_asthma_diagnosis.snomedct_code
dataset.first_asthma_diagnosis_date = first_asthma_diagnosis.date
dataset.define_population(patients.exists_for_patient())
```

### Performing arithmetic on numeric values of clinical events

#### Finding the mean observed value of clinical events matching some criteria

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

hba1c_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.mean_hba1c = clinical_events.where(
        clinical_events.snomedct_code.is_in(hba1c_codelist)
).where(
        clinical_events.date.is_on_or_after("2022-07-01")
).numeric_value.mean_for_patient()
dataset.define_population(patients.exists_for_patient())
```

### Finding events within a date range

#### Finding events within a fixed date range

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.has_recent_asthma_diagnosis = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).where(
        clinical_events.date.is_on_or_between("2022-07-01", "2023-01-01")
).exists_for_patient()
dataset.define_population(patients.exists_for_patient())
```

#### Finding events within a date range plus a constant

```ehrql
from ehrql import create_dataset, codelist_from_csv, weeks
from ehrql.tables.core import clinical_events, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")

index_date = "2022-07-01"

dataset = create_dataset()
dataset.has_recent_asthma_diagnosis = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).where(
        clinical_events.date.is_on_or_between(index_date, index_date + weeks(2))
).exists_for_patient()
dataset.define_population(patients.exists_for_patient())
```

#### Finding events within a dynamic date range

```ehrql
from ehrql import create_dataset, codelist_from_csv, months
from ehrql.tables.core import clinical_events, patients

diabetes_codelist = codelist_from_csv("XXX", column="YYY")
hba1c_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
first_diabetes_code_date = clinical_events.where(
        clinical_events.snomedct_code.is_in(diabetes_codelist)
).sort_by(
        clinical_events.date
).first_for_patient().date

dataset.count_of_hba1c_tests_6mo_post_first_diabetes_code = clinical_events.where(
        clinical_events.snomedct_code.is_in(hba1c_codelist)
).where(
        clinical_events.date.is_on_or_between(first_diabetes_code_date, first_diabetes_code_date + months(6))
).count_for_patient()
dataset.define_population(patients.exists_for_patient())
```

#### Excluding events which have happened in the future

Data quality issues with many sources may result in events apparently happening in future dates (e.g. 9999-01-01), it is useful to filter these from your analysis.

```ehrql
from datetime import date
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.has_recent_asthma_diagnosis = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).where(
        clinical_events.date > "2022-07-01"
).where(
        clinical_events.date < date.today()
).exists_for_patient()
dataset.define_population(patients.exists_for_patient())
```

### Extracting parts of dates and date differences

#### Finding the year an event occurred

```ehrql
from datetime import date
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.year_of_first = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).sort_by(
        clinical_events.date
).first_for_patient().date.year
dataset.define_population(patients.exists_for_patient())
```

#### Finding the number of weeks between two events

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")
asthma_review_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
first_asthma_diagnosis_date = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).sort_by(clinical_events.date).first_for_patient().date

first_asthma_review_date = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_review_codelist)
).where(
        clinical_events.date.is_on_or_after(first_asthma_diagnosis_date)
).sort_by(clinical_events.date).first_for_patient().date

dataset.weeks_between_diagnosis_and_review = (first_asthma_review_date - first_asthma_diagnosis_date).weeks
dataset.define_population(patients.exists_for_patient())
```

#### Determining if two events are within 14 days of each other

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import clinical_events, patients

codelist_1 = codelist_from_csv("XXX", column="YYY")
codelist_2 = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()

event_1_date = clinical_events.where(
        clinical_events.snomedct_code.is_in(codelist_1)
).date.minimum_for_patient()

event_2_date = clinical_events.where(
        clinical_events.snomedct_code.is_in(codelist_2)
).date.minimum_for_patient()

# Check if the absolute difference between two dates is within 14
# days, regardless of which is earlier
dataset.events_are_close = (event_1_date - event_2_date).days.absolute() <= 14

dataset.define_population(patients.exists_for_patient())
```

## Admitted Patient Care Spells (APCS)

Examples for the [TPP apcs table](../reference/schemas/tpp.md#apcs).

### Does each patient have an event matching some criteria?

#### Does each patient have a hospitalisation event matching some criteria?

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.tpp import apcs, patients

cardiac_diagnosis_codes = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.has_recent_cardiac_admission = apcs.where(
        apcs.primary_diagnosis.is_in(cardiac_diagnosis_codes)
).where(
        apcs.admission_date.is_on_or_between("2022-07-01", "2023-01-01")
).exists_for_patient()
dataset.define_population(patients.exists_for_patient())
```

## Medications

Examples for the [medications table](../reference/schemas/core.md#medications).

### Does each patient have an event matching some criteria?

#### Does each patient have a medication event matching some criteria?

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import medications, patients

statin_medications = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.has_recent_statin_prescription = medications.where(
        medications.dmd_code.is_in(statin_medications)
).where(
        medications.date.is_on_or_between("2022-07-01", "2023-01-01")
).exists_for_patient()
dataset.define_population(patients.exists_for_patient())
```

#### How many events does each patient have matching some criteria?

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import medications, patients

statin_medications = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.number_of_statin_prescriptions_in_last_year = medications.where(
        medications.dmd_code.is_in(statin_medications)
).where(
        medications.date.is_on_or_between("2022-01-01", "2023-01-01")
).count_for_patient()
dataset.define_population(patients.exists_for_patient())
```

#### What is the earliest/latest medication event matching some criteria?

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import medications, patients

statin_medications = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.first_statin_prescription_date = medications.where(
        medications.dmd_code.is_in(statin_medications)
).where(
        medications.date.is_on_or_after("2022-07-01")
).sort_by(
        medications.date
).first_for_patient().date
dataset.define_population(patients.exists_for_patient())
```

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import medications, patients

statin_medications = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
dataset.last_statin_prescription_date = medications.where(
        medications.dmd_code.is_in(statin_medications)
).where(
        medications.date.is_on_or_after("2022-07-01")
).sort_by(
        medications.date
).last_for_patient().date
dataset.define_population(patients.exists_for_patient())
```

### Extracting parts of dates and date differences

#### Finding prescriptions made in particular months of the year

```ehrql
from ehrql import create_dataset, codelist_from_csv
from ehrql.tables.core import medications, patients

amoxicillin_codelist = codelist_from_csv("XXX", column="YYY")

winter_months = [10,11,12,1,2,3]

dataset = create_dataset()
dataset.winter_amoxicillin_count = medications.where(
        medications.dmd_code.is_in(amoxicillin_codelist)
).where(
        medications.date.month.is_in(winter_months)
).count_for_patient()
dataset.define_population(patients.exists_for_patient())
```

### Finding events occuring close in time to another event

#### Finding the code of the first medication after the first clinical event matching some criteria

```ehrql
from ehrql import create_dataset, codelist_from_csv, weeks
from ehrql.tables.core import clinical_events, medications, patients

asthma_codelist = codelist_from_csv("XXX", column="YYY")
inhaled_corticosteroid_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()
first_asthma_diagnosis_date = clinical_events.where(
        clinical_events.snomedct_code.is_in(asthma_codelist)
).where(
        clinical_events.date.is_on_or_after("2022-07-01")
).sort_by(
        clinical_events.date
).first_for_patient().date
dataset.first_asthma_diagnosis_date = first_asthma_diagnosis_date
dataset.count_ics_prescriptions_2wks_post_diagnosis = medications.where(
        medications.dmd_code.is_in(inhaled_corticosteroid_codelist)
).where(
        medications.date.is_on_or_between(first_asthma_diagnosis_date,first_asthma_diagnosis_date + weeks(2))
).count_for_patient()
dataset.define_population(patients.exists_for_patient())
```

### Excluding medications for patients who have transferred between practices

Note that in these examples, the periods defined are illustrative only.

#### Excluding patients based on prescription date

```ehrql
from ehrql import case, create_dataset, codelist_from_csv, when, weeks
from ehrql.tables.tpp import medications, patients, practice_registrations

def meets_registrations_criteria(medication_date):
    # For this medication date, find whether a registration exists where
    # the start date and end dates are within a 12 weeks
    # prior/after to the prescription

    start_cutoff_date = medication_date - weeks(12)
    end_cutoff_date = medication_date + weeks(12)
    return (
        practice_registrations.where(
        practice_registrations.start_date.is_on_or_before(start_cutoff_date)
        )
        .except_where(
        practice_registrations.end_date.is_on_or_before(end_cutoff_date)
        )
        .exists_for_patient()
    )

medication_codelist = codelist_from_csv("XXX", column="YYY")

dataset = create_dataset()

# First relevant prescription per patient
first_prescription = (
    medications.where(
        medications.dmd_code.is_in(medication_codelist)
    )
    .sort_by(medications.date)
    .first_for_patient()
)

# Include only prescriptions that fall within acceptable registration dates
dataset.prescription_date = case(
    when(meets_registrations_criteria(first_prescription.date))
    .then(first_prescription.date)
)
dataset.define_population(patients.exists_for_patient())
```

## Vaccinations

Examples for the [vaccinations table](../reference/schemas/tpp.md#vaccinations). Possible values for `TARGET_DISEASE` and `VACCINE_PRODUCT` from the below examples can be found in the [OpenSAFELY-TPP database reference values][vaccinations_1] report.

[vaccinations_1]: https://reports.opensafely.org/reports/opensafely-tpp-database-reference-values/#VaccinationReference-Table

### Finding the most recent vaccination date for a target disease


```ehrql
from ehrql import create_dataset
from ehrql.tables.tpp import patients, vaccinations

dataset = create_dataset()
latest_vaccine = (
  vaccinations
    .where(vaccinations.target_disease == "TARGET_DISEASE")
    .sort_by(vaccinations.date)
    .last_for_patient()
)
dataset.latest_vaccine_date = latest_vaccine.date
dataset.define_population(patients.exists_for_patient())
```

### Finding the most recent vaccination date for a specific vaccine product

```ehrql
from ehrql import create_dataset
from ehrql.tables.tpp import patients, vaccinations

dataset = create_dataset()
latest_vaccine = (
  vaccinations
    .where(vaccinations.product_name == "VACCINE_PRODUCT")
    .sort_by(vaccinations.date)
    .last_for_patient()
)
dataset.latest_vaccine_date = latest_vaccine.date
dataset.define_population(patients.exists_for_patient())
```
