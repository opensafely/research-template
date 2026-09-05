# How to use dummy data in an ehrQL measures definition

Refer to the [Measures reference documentation](../reference/language.md#measures) for more
information on how to use measures.

Similarly to [dataset definitions](dummy-data.md), there are also three ways to use dummy
data with a measures definition in ehrQL.

1. [Let ehrQL generate dummy measures from your measures definition](#let-ehrql-generate-dummy-measures-from-your-measures-definition)

1. [Supply your own dummy measures](#supply-your-own-dummy-measures)

1. [Supply your own dummy tables](#supply-your-own-dummy-tables)


## Let ehrQL generate dummy measures from your measures definition

You do not need to add anything to the measures definition itself in order to generate a dummy
dataset in this way. ehrQL will use the measures definition to set up dummy data and generate
matching patients.

By default, ten patients will be generated in a dummy measures output. If you need to increase this number, you can configure it in the measures definition with:

```
measures.configure_dummy_data(population_size=1000)
```

:warning: Increasing the population size will increase the time required to generate the
measures.


## Supply your own dummy measures

You can provide a dummy measures file in the following formats.

|Format        |File extension|
|--------------|--------------|
|CSV           |.csv          |
|Compressed CSV|.csv.gz       |
|Arrow         |.arrow        |

:warning: Your file must have the relevant file extension shown in the table
above.

For example, take this simple measures definition:

```ehrql
from ehrql import create_measures, years
from ehrql.measures import INTERVAL
from ehrql.tables.core import patients, clinical_events

events_in_interval = clinical_events.where(clinical_events.date.is_during(INTERVAL))
had_event = events_in_interval.exists_for_patient()
intervals = years(2).starting_on("2020-01-01")
measures = create_measures()

measures.define_measure(
    "had_event_by_sex",
    numerator=had_event,
    denominator=patients.exists_for_patient(),
    group_by={"sex": patients.sex},
    intervals=intervals,
)
```

And this dummy measures, in a CSV file named `dummy_measures.csv`:

|measure|interval_start|interval_end|ratio|numerator|denominator|sex|
|-------|--------------|------------|-----|---------|-----------|---|
|had_event_by_sex|2020-01-01|2020-12-31|0.25|2|8|female|
|had_event_by_sex|2020-01-01|2020-12-31|0.5|3|6|male|
|had_event_by_sex|2021-01-01|2021-12-31|0.1|1|10|female|
|had_event_by_sex|2021-01-01|2021-12-31|0.0|0|2|male|


Run the measures definition with the dummy measures output file:

```
opensafely exec ehrql:v1 generate-measures measures_definition.py --dummy-data-file dummy_measures.csv
```

Now, instead of generated dummy measures output, you'll see the data from the dummy data file that you provided.

![A screenshot of VS Code, showing the terminal after the `opensafely exec` command was run](opensafely_exec_dummy_measures_data_file.png)

### Dummy measures errors

ehrQL will check the column names, types and categorical values in your dummy measures output file. If errors are found, they will be shown in the terminal output.


## Supply your own dummy tables

A measures definition uses the same underlying data tables as a dataset definition. As such,
you can use [the same process](dummy-data.md#supply-your-own-dummy-dataset) to supply dummy data tables for a measures definition.
