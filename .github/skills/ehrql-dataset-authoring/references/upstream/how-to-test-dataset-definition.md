# How to test your dataset definition

This guide shows you how to evaluate and validate the behaviour of your ehrQL query.
The [assure](../reference/cli.md#assure) command works like a suite of unit tests for your ehrQL queries.

You can write assurance tests that help you and others to understand and review the expected behaviour of your dataset definition.
Assurance tests also provide confidence that existing functionality remains unchanged when reworking your dataset definition.

In this guide we will demonstrate how to test ehrQL queries:

1. Create dataset definition
2. Specify test data and expectations
3. Run tests

We also have [a video explainer](https://www.youtube.com/watch?v=cppkQMR9hJ0) of this feature.

## Example dataset definition

First, we're creating a dataset definition with the following specifications:

- The population includes everyone above the age of 18 on the `index_date` (31st March 2023).
- The dataset has the following three columns:
    - `age`: Patient's age on the `index_date`.
    - `has_asthma_med`: Boolean value specifying whether a patient has received an asthma medication before the `index_date`.
    - `latest_asthma_med_date`: Date of the most recent prescription of an asthma medication before the `index_date`.

```ehrql
from ehrql import create_dataset
from ehrql.tables.core import patients, medications

asthma_codes = ["39113311000001107", "39113611000001102"]

dataset = create_dataset()

index_date = "2023-03-31"

dataset.age = patients.age_on(index_date)
dataset.define_population(dataset.age > 18)

latest_asthma_med = (
    medications.where(medications.dmd_code.is_in(asthma_codes))
    .where(medications.date <= index_date)
    .sort_by(medications.date)
    .last_for_patient()
)

dataset.has_asthma_med = latest_asthma_med.exists_for_patient()
dataset.latest_asthma_med_date = latest_asthma_med.date
```

## Specifying test data and expectations

Next, you need to provide (1) data for test patients and (2) specify the data that you expect to see in the dataset for each patient after applying your ehrQL queries.
Test data and expectations are both defined in a nested dictionary called `test_data`.

### Data for test patients

To set up test patients and their data you need to use the following structure:

* **Patient ID**: Outermost dictionary keys represent patient IDs.
* **Table names**: Second-level dictionary keys denote table names from OpenSAFELY backends.
    * *One-row-per-patient* tables (e.g., [patients](../reference/schemas/core.md#patients)) are specified in a single dictionary
    * *Many-rows-per-patient* tables (e.g., [medications](../reference/schemas/core.md#medications)) are specified in a list that can contain multiple dictionaries, where each dictionary adds one row for the patient to the `medications` table.
* **Column names**: Third-level dictionary keys indicate column names in the tables.

```py
test_data = {
    1: {
        "patients": {
            "date_of_birth": date(2020, 1, 1),
            "sex": "female"},
        "medications": [
            {
                # First prescription of asthma medication
                "date": date(2010, 1, 1),
                "dmd_code": "39113311000001107",
            },
            {
                # Second prescription of asthma medication
                "date": date(2020, 1, 1),
                "dmd_code": "39113311000001107",
            },
        ],
        # Add expectations for patient 1 here
        # See next section of this guide
    },
}
```

In the example above we have created one test patient with the patient ID `1` and added test data for two tables: `patients` and `medications`.
The keys of the second-level dictionary match the names of the tables in the dataset definition.
To explore how these tables are structured you can look at the column names in the [table schemas](../reference/schemas.md) documentation.
Also note that some columns have constraints that need to be specified correctly in your test data.
For example, the `date_of_birth` column in the [patients table](../reference/schemas/core.md#patients.date_of_birth) has the following constraints: '*Always the first day of a month*' and '*Never `NULL`*'.

As mentioned above, adding data is different for *one-row-* and *many-rows-per-patient* tables:

* `patients` is a *one-row-per-patient* table, so you can only define one dictionary with one key for each column (`date_of_birth` and `sex`) that you want to populate.
    Note that you don't have to specify a value for each column in the underlying table.
    For example we did not specify `date_of_death` in the dictionary so the column will be missing with the value `None`.
    This only works because the `date_of_death` column does not have a '*Never `NULL`*' constraint.
* `medications` is a *many-rows-per-patient* table, so you can define a list containing multiple dictionaries (one for each row you want to add to the table) with one key for each column (`date` and `dmd_code`).

### Expectations for test patients

Once you have created data for your test patients you need to specify your expectations after applying the ehrQL in your dataset definition to the test patients.
Note that you have to specify a list for each table you use in your dataset definition, but this could also be an empty list.
First you need to indicate whether you expect the test patient to be in your defined population by providing `True` or `False` to the `expected_in_population` key.
If you are expecting a patient in your population you also need to specify the values for the columns you added to your dataset in the `expected_columns` dictionary.
Each key in the `expected_columns` dictionary represents one column you added to your dataset.

In the example below we created three test patients in a separate file (e.g., `analysis/test_dataset_definition.py`), each testing a different element of our dataset definition (e.g., `analysis/dataset_definition.py`):

* **Patient 1**: Expected in our population because the patient is older than 18 years on the `index_date`.
  The three entries in the medications table tests the ehrQL logic that selects the latest medication before the `index_date`.
* **Patient 2**: Expected in our population because the patient is older than 18 years on the `index_date`.
  However the patient does not have any entries in their `medications` table.
  Here we are testing the behaviour of our ehrQL query when a patient was never prescribed a code from the `asthma_codes` codelist
* **Patient 3**: Not expected in our population because the patient is younger than 18 years on the `index_date`.

At the top of your test script you need to import the `date` function and the `dataset` from your dataset definition that you want to test.

```py
from datetime import date
from dataset_definition import dataset

test_data = {
    # Expected in population with matching medication
    1: {
        "patients": {"date_of_birth": date(1950, 1, 1)},
        "medications": [
            {
                # First matching medication
                "date": date(2010, 1, 1),
                "dmd_code": "39113311000001107",
            },
            {
                # Latest matching medication before index_date
                "date": date(2020, 1, 1),
                "dmd_code": "39113311000001107",
            },
            {
                # Most recent matching medication, but after index_date
                "date": date(2023, 6, 1),
                "dmd_code": "39113311000001107",
            },
        ],
        "expected_in_population": True,
        "expected_columns": {
            "age": 73,
            "has_asthma_med": True,
            "latest_asthma_med_date": date(2020, 1, 1),
        },
    },
    # Expected in population without matching medication
    2: {
        "patients": [{"date_of_birth": date(1950, 1, 1)}],
        "medications": [],
        "expected_in_population": True,
        "expected_columns": {
            "age": 73,
            "has_asthma_med": False,
            "latest_asthma_med_date": None,
        },
    },
    # Not expected in population
    3: {
        "patients": [{"date_of_birth": date(2010, 1, 1)}],
        "medications": [],
        "expected_in_population": False,
    },
}
```

## Running the tests

Finally you can run your assurance tests to verify if your expectations were successful or failed.

### Option 1: Running tests through the terminal

To run your tests through the terminal, use the following command:

```
opensafely exec ehrql:v1 assure analysis/test_dataset_definition.py
```

### Option 2: Integrating tests into your `generate-dataset` action

You can also run your tests every time you execute a `generate-dataset` action by providing your test file using the `--test-data-file` flag in the `project.yaml` file:

```
actions:
  generate_dataset:
    run: >
        ehrql:v1 generate-dataset
        analysis/dataset_definition.py
        --test-data-file analysis/test_dataset_definition.py
        --output outputs/dataset.arrow
    outputs:
      highly_sensitive:
        population: outputs/dataset.arrow

```

## Interpreting the results

### Successful expectations

If the expected results match the results after applying the ehrQL logic and the test data meets all constraints you will see the following short message in your terminal:

```
Validate test data: All OK!
Validate results: All OK!
```

### Failed expectations

#### Failed constraint validations

If the test data you provided does not meet the constraints you will see a message with more information.
We recommend that you fix the errors so that the test data meets the constraints and is identical to the production data.
However, if you are sure that you want to test your ehrQL query with values that do not to the constraints, you can ignore the '*Validate test data*' section of the message.

```
Validate test data: Found errors with 1 patient(s)
 * Patient 1 had 1 test data value(s) that did not meet the constraint(s)
   * for column 'date_of_birth' with 'Constraint.NotNull()', got 'None'
Validate results: All OK!
```

#### Failed result expectations

You will see a message that helps you to diagnose and fix the problem if your expectations do not match the results.
The error message is structured by patient and contains one line for each column with a failed expectation.
Each line starts with the column name followed by the value that was specified in the test and the last value shows the result that was obtained after applying the ehrQL logic:

```
Validate test data: All OK!
Validate results: Found errors with 1 patient(s)
 * Patient 1 had unexpected value(s)
   * for column 'age', expected '72', got '73'
   * for column 'latest_asthma_med_date', expected '2020-01-01', got '2021-01-01'
```
