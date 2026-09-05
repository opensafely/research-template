# How to reuse reuse your ehrQL with custom parameters

Sometimes you may need to run the same ehrQL with small differences. For example,
you may want to extract the same demographics for patients with 3 different conditions,
or you may want to extract patients who meet the same clinical conditions for 5
consecutive years.

In such cases, the ehrQL code we want to run is the same. In the first case, we
might have a different codelist for identifying patients with each condition. We
*could* write 3 separate dataset definitions that differ only in the name of the
codelist we want to use for each condition. However, it's much more efficient to
pass in a custom parameter to each ehrQL action that allows us to use the same code
with a different codelist each time.


## Passing custom parameters to ehrQL

### From the command line

Custom parameters are passed to an ehrQL command (such as `generate-dataset` or `generate-measures`)
after all other parameters, separated by a double-dash `--`.

E.g. To [run a stand-alone `generate-dataset`
action](../explanation/running-ehrql.md#2-running-ehrql-as-a-standalone-action-via-opensafely-exec) with a custom parameter `max_age`:

```
opensafely exec ehrql:v1 generate-dataset analysis/dataset_definition.py -- --max_age 99
```

### In a project.yaml action

Pass custom parameters in a `project.yaml` in the same way:
```
version: '5.0'

actions:
  generate_dataset:
    run: ehrql:v1 generate-dataset dataset_definition.py --output output/dataset.arrow
      --
      --max_age 99
    outputs:
      highly_sensitive:
        dataset: output/dataset.arrow

```

## Defining and using parameters in ehrQL

In order to use a custom parameter, we need to define it in ehrQL.

First, import the `get_parameter` function.

```ehrql
from ehrql import get_parameter
```

Then, define each parameter that you want to pass in from the command line or from an action
in your `project.yaml`:

```ehrql
from ehrql import get_parameter

max_age = get_parameter("max_age", type=int, default=100)
```

This will read the `max_age` parameter that you passed in, convert it to an integer, and make it
available for use in your subsequent ehrQL code. If you don't pass in a `max_age` parameter, the
default value - in this case, 100 - will be used.

## Parameter types

By default, parameters are interpreted as simple strings. If you want your values to be some other
type, you can provide an optional `type` to convert the string to another type. In practice, you're likely to most often want to interpret the value as `float` or `int`, but other more complex types
such as `pathlib.Path` to convert a string filepath to a `Path` instance are possible.

```ehrql
from pathlib import Path

from ehrql import get_parameter

# interpret as integer
param1 = get_parameter("param1", type=int, default=1)
# interpret as integer
param2 = get_parameter("param2", type=float, default=1.0)
# interpret as Path
param3 = get_parameter("param3", type=Path, default=Path("output"))
```

!!! Info "`bool` type parameters"
    The `bool` type will interpret values as `True` or `False`.  Valid values are:

    - "1", "True", "true": interpreted as True
    - "0", "False", "false": interpreted as False

    i.e. `has_diagnosis` will be interpreted as False in all of the cases below.
    ```
    ... -- --has_diagnosis 0
    ... -- --has_diagnosis False
    ... -- --has_diagnosis false
    ```

    In your ehrQL, define it as a `bool` type parameter:
    ```
    has_diagnosis = get_parameter("has_diagnosis", type=bool)
    ```


## Multiple parameter values

Multiple values can be passed for a single parameter, either by separating value with a space, or
by passing `--key value` multiple times.

For example, pass two values for the `region` parameter:

```
opensafely exec ehrql:v1 generate-dataset analysis/dataset_definition.py \
  -- --region London --region South
```

Or:

```
opensafely exec ehrql:v1 generate-dataset analysis/dataset_definition.py -- \
  --region London South
```

In your ehrQL, define the parameter as usual:

```ehrql
from ehrql import get_parameter

regions = get_parameter("region", default=["London"])
```

Since two values have been passed to the `region` parameter, when we define `regions` in
ehrQL, it will be parsed as a list, `["London", "South"]`.

Note that our default in this case is **also** a list. This means that if we don't pass in a value,
we will still use a list as a default, and any ehrQL queries that assume that `regions` is a list
will still work.


!!! Info "values with spaces"
    If you need to pass a value on the command line that contains a space, wrap it in quotes so that
    it is interpreted as a single value. In the above example, if we wanted to pass the regions
    London, South, and North West, we can do so with:
    ```
    opensafely exec ehrql:v1 generate-dataset analysis/dataset_definition.py -- \
        --region London South 'North West'
    ```


## Example

Assume we want to extract age and sex for:

- patients with asthma
- patients with diabetes

And we also want to compare patients with these conditions for patients who live in:

- regions in the North of England
- London and regions in the South of England.

Finally, we also want to extract these data for the years:

- 2020
- 2021

We have already defined two codelists that identify patients with the conditions, and we have
[added the codelists](https://docs.opensafely.org/codelist-project/#adding-a-codelist) to our
project, so these codelists are now present at:

- `codelists/asthma_codelist.csv`
- `codelists/diabetes_codelist.csv`

Our dataset definition defines the 3 parameters we need, `codelist_name`, `regions`
and `index_date`, and uses them to define the population of interest:

```ehrql
from ehrql import codelist_from_csv, create_dataset, get_parameter
from ehrql.tables.core import clinical_events, patients
from ehrql.tables.tpp import practice_registrations

# Define parameters
codelist_name = get_parameter(name="codelist", default="")
regions = get_parameter(name="region", default=[])
index_date = get_parameter(name="index", default="2020-01-01")

dataset = create_dataset()

# read the codelist specified by the parameter
codelist = codelist_from_csv(f"codelists/{codelist_name}.csv", column="snomedcode")

# Find patients with the relevant diagnosis
has_diagnosis = (
    clinical_events
    .where(clinical_events.snomedct_code.is_in(codelist))
    .exists_for_patient()
)

# Find patients in the parameter-specified regions, on the
# parameter-specified date
practice_registration = practice_registrations.for_patient_on(index_date)
in_regions = practice_registration.practice_nuts1_region_name.is_in(regions)

dataset.age = patients.age_on(index_date)
dataset.sex = patients.sex

dataset.define_population(has_diagnosis & in_regions)
```

Our `project.yaml` can now define 8 actions, all using the same dataset definition:

```
version: '5.0'

actions:
  generate_dataset_2020_asthma_north:
    run: ehrql:v1 generate-dataset dataset_definition.py ...
      --
      --index 2020-01-01
      --codelist asthma
      --region 'North East' 'North West' 'Yorkshire and The Humber'
    ...

  generate_dataset_2020_asthma_south:
    run: ehrql:v1 generate-dataset dataset_definition.py ...
      --
      --index 2020-01-01
      --codelist asthma
      --region 'London' 'South East' 'South West'
    ...

  generate_dataset_2020_diabetes_north:
    run: ehrql:v1 generate-dataset dataset_definition.py ...
      --
      --index 2020-01-01
      --codelist diabetes
      --region 'North East' 'North West' 'Yorkshire and The Humber'
    ...

  generate_dataset_2020_diabetes_south:
    run: ehrql:v1 generate-dataset dataset_definition.py ...
      --
      --index 2020-01-01
      --codelist diabetes
      --region 'London' 'South East' 'South West'
    ...

  generate_dataset_2021_asthma_north:
    run: ehrql:v1 generate-dataset dataset_definition.py ...
      --
      --index 2021-01-01
      --codelist asthma
      --region 'North East' 'North West' 'Yorkshire and The Humber'
    ...

  generate_dataset_2021_asthma_south:
    run: ehrql:v1 generate-dataset dataset_definition.py ...
      --
      --index 2021-01-01
      --codelist asthma
      --region 'London' 'South East' 'South West'
    ...

  generate_dataset_2021_diabetes_north:
    run: ehrql:v1 generate-dataset dataset_definition.py ...
      --
      --index 2021-01-01
      --codelist diabetes
      --region 'North East' 'North West' 'Yorkshire and The Humber'
    ...

  generate_dataset_2021_diabetes_south:
    run: ehrql:v1 generate-dataset dataset_definition.py ...
      --
      --index 2021-01-01
      --codelist diabetes
      --region 'London' 'South East' 'South West'
    ...

```
