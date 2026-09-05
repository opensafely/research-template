## Basic population definition

You specify the patients you want to include in your dataset using the
`define_population()` method. For example, to include all patients born
in 1950 you would write something like this:
```ehrql
from ehrql import create_dataset
from ehrql.tables.core import patients

dataset = create_dataset()
dataset.define_population(patients.date_of_birth.year == 1950)
```


## Combining multiple inclusion criteria

You can combine multiple inclusion criteria using the [logical operators](../reference/language.md#BoolPatientSeries.and):

 * `&` (and)
 * `|` (or)
 * `~` (not)

For example, to include just men born in 1950 you could use the `&`
operator. This says that patients must match the date of birth criterion
**and** the sex criterion.
```python
dataset.define_population(
    (patients.date_of_birth.year == 1950) & (patients.sex == "male")
)
```

And, similarly you could include just women born in 1960 using:
```python
dataset.define_population(
    (patients.date_of_birth.year == 1960) & (patients.sex == "female")
)
```

To combine these populations together and include both men born in 1950
and women born in 1960 you could use the `|` operator. This says that
patients must match **either** the first condition **or** the second:
```python
dataset.define_population(
    ((patients.date_of_birth.year == 1950) & (patients.sex == "male"))
    | ((patients.date_of_birth.year == 1960) & (patients.sex == "female"))
)
```

!!! note "What's with all the parentheses?"

    ehrQL requires more parentheses around logical operators than you
    may be used to from other languages. This is a side-effect of the
    way the Python language (in which ehrQL is implemented) happens to
    work, but it is good practice in any case to be explicit about how
    you expect logical operations to be grouped together. If you miss
    out any required parentheses ehrQL should give you an error message
    explaining how to fix your code.


## Excluding patients from your dataset

To exclude patients matching a certain condition from your dataset you
can use the "and not" pattern. That is, you can write your population
definition in the form:

    inclusion_criteria & ~exclusion_criteria

For example, to include patients born in 1950 and exclude patients
who died before 2020 you could write:
```python
dataset.define_population(
    (patients.date_of_birth.year == 1950) & ~(patients.date_of_death.year < 2020)
)
```
