## Dataset

---8<-- 'includes/generated_docs/language__dataset.md'

---


## Frames

Frames are the starting point for building any query in ehrQL. You can
think of a Frame as being like a table in a database, in that it
contains multiple rows and multiple columns. But a Frame can have
operations applied to it like filtering or sorting to produce a new
Frame.

You don't need to define any Frames yourself. Instead you import them
from the various [schemas](schemas.md) available in `ehrql.tables` e.g.
```py
from ehrql.tables.core import patients
```

Frames have columns which you can access as attributes on the Frame e.g.
```py
dob = patients.date_of_birth
```

The [schema](schemas.md) documentation contains the full list of
available columns for each Frame. For example, see
[`ehrql.tables.core.patients`](schemas/core.md/#patients).

Accessing a column attribute on a Frame produces a [Series](#series),
which are documented elsewhere below.

Some Frames contain at most one row per patient, we call these
PatientFrames; others can contain multiple rows per patient, we call
these EventFrames.

---8<-- 'includes/generated_docs/language__frames.md'

---


## Series

A Series represents a column of values of a certain type. Some Series
contain at most one value per patient, we call these PatientSeries;
others can contain multiple values per patient, we call these
EventSeries. Values can be NULL (i.e. missing) but a Series can never
mix values of different types.

---8<-- 'includes/generated_docs/language__series.md'

---


## Date Arithmetic

ehrQL supports adding and subtracting durations from dates e.g.
`date_of_admission + days(10)` or `date_of_discharge - weeks(6)`. It
also supports finding the difference between dates e.g.
```py
days_in_hospital = (date_of_discharge - date_of_admission).days
```

When working with dates you should generally prefer using days or weeks
as units, rather than months or years, unless there's a specific reason
you care about the calendar. Adding or subtracting days or weeks to a
date is a simple, unambiguous process; adding years or months introduces
ambiguities and complexities as neither unit is a consistent length (see
[section below](#ambiguous-dates) for details). So, for example, unless
there is specific epidemiological significance to whether an event
happened exactly three calendar months ago, it is better to say "90
days" rather than "3 months".

Additionally, some dates in the patient data (e.g. dates of birth) have
been rounded to the first of the month for privacy purposes. It's
pointless applying precise calendar arithmetic to such dates.

**Tip**: it can be clearer to readers to write time periods as a product
rather than just a number e.g. it's easier to see that `days(5 * 365)`
is approximately five years than it is with `days(1825)`.


#### Ambiguous Dates

Adding years or months to a date sometimes has a clear answer e.g. 1
January 2001 is exactly one calendar year later than 1 January 2000, and
1 February is exactly one calendar month later. But not all cases are
clear, for instance: which day is exactly one year after 29 February
2000? There is no 29 February 2001, so should it be 28 February or 1
March? And which day is exactly one calendar month after 31 August?
There is no 31 September, so should it be 30 September or 1 October?
Different databases give different answers here.

ehrQL takes the approach that we consistently round *up* to the next
date. That is, whenever the naïve calculation takes us to a date which
doesn't exist (like 29 February 2001 or 31 September) we always take the
next *largest* date (1 March 2001, or 1 October).

As different databases take different approaches here, ehrQL has to go
to some lengths to ensure that we get the same results on every database
we support. This introduces complexity into the generated SQL which may
have performance costs in some circumstances. This is another reason to
prefer unambiguous units of days and weeks where possible.

---8<-- 'includes/generated_docs/language__date_arithmetic.md'

---


## Codelists

---8<-- 'includes/generated_docs/language__codelists.md'

---


## Functions

---8<-- 'includes/generated_docs/language__functions.md'

---


## Measures

Measures are used for calculating the ratio of one quantity to another
as it varies over time, and broken down by different demographic (or
other) groupings.

---8<-- 'includes/generated_docs/language__measures.md'

---


## Parameters

ehrQL supports extra user-defined parameters, passed to your Python definition file
from the [command line](cli.md#generate-dataset.user_args).

---8<-- 'includes/generated_docs/language__parameters.md'

---


## Permissions

Some tables and features in ehrQL can only be accessed with specific
permission, which must be enabled by the OpenSAFELY team. The exact
process and criteria for granting these permissions depends on the
details of the specific permission in question. But generally speaking
this would something discussed at the application stage of a project.

If there is a permission you think you should have but don't, you should
raise this with your co-pilot or with OpenSAFELY support.


### “Claiming” permissions

When working with dummy data locally or inside Codespaces ehrQL does not
know which permissions your project has and so it will warn if you
attempt to use _any_ restricted table or feature. You can silence these
warnings by using the `claim_permission()` function below to say which
permissions your project has.

The warning message generated by ehrQL will tell you exactly what
permissions you need to claim and will generate the code you need to
copy and paste into your dataset definition.

You can claim any permission you need to allow you to continue your
dummy data work, but you **won't be able to run your project against
real data** unless you actually have those permissions enabled in the
OpenSAFELY platform.

The `claim_permissions()` function can be placed anywhere in your
dataset or measure definition file, or in any of the Python files your
definition imports.


---8<-- 'includes/generated_docs/language__permissions.md'

---
