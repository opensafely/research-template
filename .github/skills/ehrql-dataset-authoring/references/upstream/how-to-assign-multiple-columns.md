# How to assign multiple columns to a dataset programmatically

To include columns in your output for further analysis, these columns need to be added to the dataset.
If you need to add multiple similar columns to your dataset it could be more efficient to do this programmatically instead of adding each column manually.
For example, you might want to count the number of medications each patient received across different codelists.
This guide first shows you how to use `dataset.add_column` to assign one new column to the dataset, followed by an example how to assign multiple columns programmatically.

## Assign one column to the dataset

As mentioned in the tutorial on "[Building a dataset](../tutorials/introduction-to-ehrql/building-a-dataset/index.md#datasets)",
we can assign a variable to the dataset by adding a dot and the name of the variable to the dataset,
followed by an equals sign and the definition of the variable.
In the following example, the name of the variable is `my_variable`
and the definition of the variable is `...`.

``` { .python .no-copy }
dataset.my_variable = ...
```

Similarly, we can assign a variable using `dataset.add_column`, where the first argument is the
name of the new column as a string and the second argument is the definition of the variable.

``` { .python .no-copy }
dataset.add_column("my_variable", ...)
```

## Assign multiple columns to the dataset

To add multiple variables to a dataset, we can use a dictionary to map new column names to codelists (`medication_codelists`).
First, create an ehrQL query to count each patient's medications (`count_medications_query`).
Then, iterate over this dictionary, using `dataset.add_column` to add each new variable to the dataset.
You can also add a prefix or suffix to the new column names (e.g., `_count`).
This example adds two new columns to the dataset: `asthma_meds_count` and `other_meds_count`.

```ehrql
from ehrql import create_dataset
from ehrql.tables.core import patients, medications

asthma_codelist = ["39113311000001107", "39113611000001102"]
other_codelist = ["10000000000000001", "10000000000000002"]

dataset = create_dataset()
dataset.define_population(patients.exists_for_patient())

medication_codelists = {
    "asthma_meds": asthma_codelist,
    "other_meds": other_codelist,
}

for med_name, med_codelist in medication_codelists.items():
    count_medications_query = medications.where(
        medications.dmd_code.is_in(med_codelist)
    ).count_for_patient()
    dataset.add_column(f"{med_name}_count", count_medications_query)
```
