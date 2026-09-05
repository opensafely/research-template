## 1 Filtering an event frame

### 1.1 Including rows

#### 1.1.1 Where with column

```python
e.where(e.b1).i1.sum_for_patient()
```

#### 1.1.2 Where with expr

```python
e.where((e.i1 + e.i2) < 413).i1.sum_for_patient()
```

#### 1.1.3 Where with constant true

```python
e.where(True).count_for_patient()
```

#### 1.1.4 Where with constant false

```python
e.where(False).count_for_patient()
```

#### 1.1.5 Chain multiple wheres

```python
e.where(e.i1 >= 2).where(e.b1).i1.sum_for_patient()
```

### 1.2 Excluding rows

#### 1.2.1 Except where with column

```python
e.except_where(e.b1).i1.sum_for_patient()
```

#### 1.2.2 Except where with expr

```python
e.except_where((e.i1 + e.i2) < 413).i1.sum_for_patient()
```

#### 1.2.3 Except where with constant true

```python
e.except_where(True).count_for_patient()
```

#### 1.2.4 Except where with constant false

```python
e.except_where(False).count_for_patient()
```

## 2 Picking one row for each patient from an event frame

### 2.1 Picking the first or last row for each patient

#### 2.1.1 Sort by column pick first

```python
e.sort_by(e.i1).first_for_patient().i1
```

#### 2.1.2 Sort by column pick last

```python
e.sort_by(e.i1).last_for_patient().i1
```

### 2.2 Sort by more than one column and pick the first or last row for each patient

#### 2.2.1 Sort by multiple columns pick first

```python
e.sort_by(e.i1, e.i2).first_for_patient().i2
```

#### 2.2.2 Sort by multiple columns pick last

```python
e.sort_by(e.i1, e.i2).last_for_patient().i2
```

### 2.3 Picking the first or last row for each patient where a column contains NULLs

#### 2.3.1 Sort by column with nulls and pick first

```python
e.sort_by(e.i1).first_for_patient().i1
```

#### 2.3.2 Sort by column with nulls and pick last

```python
e.sort_by(e.i1).last_for_patient().i1
```

### 2.4 Mixing the order of `sort_by` and `where` operations

#### 2.4.1 Sort by before where

```python
e.sort_by(e.i1).where(e.i1 > 102).first_for_patient().i1
```

#### 2.4.2 Sort by interleaved with where

```python
e.sort_by(e.i1).where(e.i2 > 1).sort_by(e.i2).first_for_patient().i1
```

### 2.5 Sort extends to all columns when underspecified to ensure that sort order is consistent

#### 2.5.1 Sorting extends to selected column

```python
e.sort_by(e.i1, e.i2).first_for_patient().i3
```

## 3 Aggregating event and patient frames

### 3.1 Determining whether a row exists for each patient

#### 3.1.1 Exists for patient on event frame

```python
e.exists_for_patient()
```

#### 3.1.2 Exists for patient on patient frame

```python
p.exists_for_patient()
```

### 3.2 Counting the rows for each patient

#### 3.2.1 Count for patient on event frame

```python
e.count_for_patient()
```

#### 3.2.2 Count for patient on patient frame

```python
p.count_for_patient()
```

## 4 Aggregating event series

### 4.1 Minimum and maximum aggregations

#### 4.1.1 Minimum for patient

```python
e.i1.minimum_for_patient()
```

#### 4.1.2 Maximum for patient

```python
e.i1.maximum_for_patient()
```

### 4.2 Sum aggregation

#### 4.2.1 Sum for patient

```python
e.i1.sum_for_patient()
```

### 4.3 Mean aggregation

#### 4.3.1 Mean for patient integer

```python
e.i1.mean_for_patient()
```

#### 4.3.2 Mean for patient float

```python
e.f1.mean_for_patient()
```

### 4.4 Count distinct aggregation

#### 4.4.1 Count distinct for patient integer

```python
e.i1.count_distinct_for_patient()
```

#### 4.4.2 Count distinct for patient float

```python
e.f1.count_distinct_for_patient()
```

#### 4.4.3 Count distinct for patient string

```python
e.s1.count_distinct_for_patient()
```

#### 4.4.4 Count distinct for patient date

```python
e.d1.count_distinct_for_patient()
```

## 5 Combining series

### 5.1 Combining two patient series

#### 5.1.1 Patient series and patient series

```python
p.i1 + p.i2
```

### 5.2 Combining a patient series with a value

#### 5.2.1 Patient series and value

```python
p.i1 + 1
```

#### 5.2.2 Value and patient series

```python
1 + p.i1
```

### 5.3 Combining two event series

#### 5.3.1 Event series and event series

```python
(e.i1 + e.i2).sum_for_patient()
```

#### 5.3.2 Event series and sorted event series
The sort order of the underlying event series does not affect their combination.

```python
(e.i1 + e.sort_by(e.s1).i2).minimum_for_patient()
```

### 5.4 Combining an event series with a patient series

#### 5.4.1 Event series and patient series

```python
(e.i1 + p.i1).sum_for_patient()
```

#### 5.4.2 Patient series and event series

```python
(p.i1 + e.i1).sum_for_patient()
```

### 5.5 Combining an event series with a value

#### 5.5.1 Event series and value

```python
(e.i1 + 1).sum_for_patient()
```

#### 5.5.2 Value and event series

```python
(1 + e.i1).sum_for_patient()
```

## 6 Operations on all series

### 6.1 Testing for equality

#### 6.1.1 Equals

```python
p.i1 == p.i2
```

#### 6.1.2 Not equals

```python
p.i1 != p.i2
```

#### 6.1.3 Is null

```python
p.i1.is_null()
```

#### 6.1.4 Is not null

```python
p.i1.is_not_null()
```

### 6.2 Testing for containment

#### 6.2.1 Is in

```python
p.i1.is_in([101, 301])
```

#### 6.2.2 Is not in

```python
p.i1.is_not_in([101, 301])
```

#### 6.2.3 Is in empty list

```python
p.i1.is_in([])
```

#### 6.2.4 Is not in empty list

```python
p.i1.is_not_in([])
```

### 6.3 Testing for containment in another series

#### 6.3.1 Is in series

```python
p.i1.is_in(e.i1)
```

#### 6.3.2 Is not in series

```python
p.i1.is_not_in(e.i1)
```

### 6.4 Map from one set of values to another

#### 6.4.1 Map values

```python
p.i1.map_values({101: "a", 201: "b", 301: "a"}, default="c")
```

#### 6.4.2 Map values with null default

```python
p.i1.map_values({101: "a", 201: "b"})
```

#### 6.4.3 Map values with explicit null

```python
p.i1.map_values({101: "a", 201: "b", 301: None}, default="c")
```

### 6.5 Replace missing values

#### 6.5.1 When null then integer column

```python
p.i1.when_null_then(0)
```

#### 6.5.2 When null then boolean column

```python
p.i1.is_in([101, 201]).when_null_then(False)
```

### 6.6 Minimum and maximum aggregations across Patient series

#### 6.6.1 Maximum of two integer patient series

```python
maximum_of(p.i1, p.i2)
```

#### 6.6.2 Minimum of two integer patient series

```python
minimum_of(p.i1, p.i2)
```

#### 6.6.3 Minimum of two integer patient series and a value

```python
minimum_of(p.i1, p.i2, 150)
```

#### 6.6.4 Maximum of two integer patient series and a value

```python
maximum_of(p.i1, p.i2, 150)
```

#### 6.6.5 Minimum of two date patient series

```python
minimum_of(p.d1, p.d2)
```

#### 6.6.6 Maximum of two date patient series

```python
maximum_of(p.d1, p.d2)
```

#### 6.6.7 Minimum of two date patient series and datetime a value

```python
minimum_of(p.d1, p.d2, date(2015, 5, 5))
```

#### 6.6.8 Maximum of two date patient series and datetime a value

```python
maximum_of(p.d1, p.d2, date(2015, 5, 5))
```

#### 6.6.9 Minimum of two date patient series and string a value

```python
minimum_of(p.d1, p.d2, "2015-05-05")
```

#### 6.6.10 Maximum of two date patient series and string a value

```python
maximum_of(p.d1, p.d2, "2015-05-05")
```

#### 6.6.11 Maximum of two float patient series

```python
maximum_of(p.f1, p.f2)
```

#### 6.6.12 Minimum of two float patient series

```python
minimum_of(p.f1, p.f2)
```

#### 6.6.13 Minimum of two float patient series and a value

```python
minimum_of(p.f1, p.f2, 1.5)
```

#### 6.6.14 Maximum of two float patient series and a value

```python
maximum_of(p.f1, p.f2, 1.5)
```

#### 6.6.15 Maximum of two string patient series

```python
maximum_of(p.s1, p.s2)
```

#### 6.6.16 Minimum of two string patient series

```python
minimum_of(p.s1, p.s2)
```

#### 6.6.17 Minimum of two string patient series and a value

```python
minimum_of(p.s1, p.s2, "e")
```

#### 6.6.18 Maximum of two string patient series and a value

```python
maximum_of(p.s1, p.s2, "e")
```

#### 6.6.19 Maximum of two integers all a values

```python
maximum_of(1, 2, 3)
```

### 6.7 Minimum and maximum aggregations across Event series

#### 6.7.1 Maximum of two integer event series

```python
maximum_of(e.i1, e.i2).maximum_for_patient()
```

#### 6.7.2 Minimum of two integer event series

```python
minimum_of(e.i1, e.i2).minimum_for_patient()
```

#### 6.7.3 Minimum of two integer event series and a value

```python
minimum_of(e.i1, e.i2, 150).minimum_for_patient()
```

#### 6.7.4 Maximum of two integer event series and a value

```python
maximum_of(e.i1, e.i2, 150).maximum_for_patient()
```

#### 6.7.5 Minimum of two date event series

```python
minimum_of(e.d1, e.d2).minimum_for_patient()
```

#### 6.7.6 Maximum of two date event series

```python
maximum_of(e.d1, e.d2).maximum_for_patient()
```

#### 6.7.7 Minimum of two date event series and datetime a value

```python
minimum_of(e.d1, e.d2, date(2015, 5, 5)).minimum_for_patient()
```

#### 6.7.8 Maximum of two date event series and datetime a value

```python
maximum_of(e.d1, e.d2, date(2015, 5, 5)).maximum_for_patient()
```

#### 6.7.9 Minimum of two date event series and string a value

```python
minimum_of(e.d1, e.d2, "2015-05-05").minimum_for_patient()
```

#### 6.7.10 Maximum of two date event series and string a value

```python
maximum_of(e.d1, e.d2, "2015-05-05").maximum_for_patient()
```

#### 6.7.11 Maximum of two float event series

```python
maximum_of(e.f1, e.f2).maximum_for_patient()
```

#### 6.7.12 Minimum of two float event series

```python
minimum_of(e.f1, e.f2).minimum_for_patient()
```

#### 6.7.13 Minimum of two float event series and float a value

```python
minimum_of(e.f1, e.f2, 1.5).minimum_for_patient()
```

#### 6.7.14 Maximum of two float event series and float a value

```python
maximum_of(e.f1, e.f2, 1.5).maximum_for_patient()
```

#### 6.7.15 Minimum of two float event series and integer a value

```python
minimum_of(e.f1, e.f2, 2).minimum_for_patient()
```

#### 6.7.16 Maximum of two float event series and integer a value

```python
maximum_of(e.f1, e.f2, 2).maximum_for_patient()
```

#### 6.7.17 Maximum of two string event series

```python
maximum_of(e.s1, e.s2).maximum_for_patient()
```

#### 6.7.18 Minimum of two string event series

```python
minimum_of(e.s1, e.s2).minimum_for_patient()
```

#### 6.7.19 Minimum of two string event series and a value

```python
minimum_of(e.s1, e.s2, "e").minimum_for_patient()
```

#### 6.7.20 Maximum of two string event series and a value

```python
maximum_of(e.s1, e.s2, "e").maximum_for_patient()
```

#### 6.7.21 Maximum of nested aggregate

```python
maximum_of(
    e.s1.count_distinct_for_patient(),
    e.s2.count_distinct_for_patient(),
)
```

#### 6.7.22 Maximum of nested aggregate and column and a value

```python
maximum_of(e.s1.count_distinct_for_patient(), e.i1, 1).maximum_for_patient()
```

## 7 Operations on boolean series

### 7.1 Logical operations

#### 7.1.1 Not

```python
~p.b1
```

#### 7.1.2 And

```python
p.b1 & p.b2
```

#### 7.1.3 Or

```python
p.b1 | p.b2
```

### 7.2 Convert a boolean value to an integer

#### 7.2.1 Bool as int
Booleans are converted to 0 (False) or 1 (True).

```python
p.b1.as_int()
```

## 8 Operations on integer series

### 8.1 Arithmetic operations without division

#### 8.1.1 Negate

```python
-p.i2
```

#### 8.1.2 Absolute

```python
(p.i1 - 200).absolute()
```

#### 8.1.3 Add

```python
p.i1 + p.i2
```

#### 8.1.4 Subtract

```python
p.i1 - p.i2
```

#### 8.1.5 Multiply

```python
p.i1 * p.i2
```

#### 8.1.6 Multiply with constant

```python
10 * p.i2
```

### 8.2 Comparison operations

#### 8.2.1 Less than

```python
p.i1 < p.i2
```

#### 8.2.2 Less than or equal to

```python
p.i1 <= p.i2
```

#### 8.2.3 Greater than

```python
p.i1 > p.i2
```

#### 8.2.4 Greater than or equal to

```python
p.i1 >= p.i2
```

### 8.3 Convert an integer value

#### 8.3.1 Integer as float

```python
p.i1.as_float()
```

#### 8.3.2 Integer as int

```python
p.i1.as_int()
```

#### 8.3.3 Add int to float

```python
p.i1 + p.f1.as_int()
```

### 8.4 Arithmetic division operations

#### 8.4.1 Truedivide

```python
p.i1 / p.i2
```

#### 8.4.2 Truedivide by constant

```python
p.i1 / 10
```

#### 8.4.3 Truedivide constant by series

```python
10 / p.i1
```

#### 8.4.4 Floordivide

```python
p.i1 // p.i2
```

#### 8.4.5 Floordivide by constant

```python
p.i1 // 10
```

#### 8.4.6 Floordivide constant by series

```python
10 // p.i1
```

### 8.5 Raise a value to a power

#### 8.5.1 Power

```python
p.f1**p.f2
```

#### 8.5.2 Raise series to a constant

```python
p.f1**10
```

#### 8.5.3 Raise constant to a series

```python
10**p.f1
```

## 9 Operations on all series containing codes

### 9.1 Testing for containment using codes

#### 9.1.1 Is in

```python
p.c1.is_in(["123000", "789000"])
```

#### 9.1.2 Is not in

```python
p.c1.is_not_in(["123000", "789000"])
```

#### 9.1.3 Is in codelist csv

```python
p.c1.is_in(codelist)
```

### 9.2 Test mapping codes to categories using a categorised codelist

#### 9.2.1 Map codes to categories

```python
p.c1.to_category(codelist)
```

## 10 Operations on all series containing multi code strings

### 10.1 Testing for containment using codes

#### 10.1.1 Contains code prefix

```python
p.m1.contains("M06")
```

#### 10.1.2 Contains code

```python
p.m1.contains("M069")
```

#### 10.1.3 Contains any of codelist

```python
p.m1.contains_any_of(["M069", "A429"])
```

## 11 Logical case expressions

### 11.1 Logical case expressions

#### 11.1.1 Case with expression

```python
case(
    when(p.i1 < 8).then(p.i1),
    when(p.i1 > 8).then(100),
)
```

#### 11.1.2 Case with default

```python
case(
    when(p.i1 < 8).then(p.i1),
    when(p.i1 > 8).then(100),
    otherwise=0,
)
```

#### 11.1.3 Case with boolean column
Note that individual boolean columns can be converted to the integers 0 and 1 using
the `as_int()` method.

```python
case(
    when(p.b1).then(p.i1),
    when(p.i1 > 8).then(100),
)
```

#### 11.1.4 Case with explicit null

```python
case(
    when(p.i1 < 8).then(None),
    when(p.i1 > 8).then(100),
    otherwise=200,
)
```

#### 11.1.5 Case evaluated in order

```python
case(
    when(p.i1.is_in([2, 4, 6, 8])).then("even"),
    when(p.i1 < 8).then("small"),
    when(p.i1 >= 8).then("large"),
)
```

#### 11.1.6 Case pick first non null value

```python
case(
    when(p.i1.is_not_null()).then(p.i1),
    when(p.i2.is_not_null()).then(p.i2),
)
```

#### 11.1.7 Case pick first non null value with only one value
This is a fairly pointless operation, but ehrQL should handle it without error

```python
case(
    when(p.i1.is_not_null()).then(p.i1),
)
```

### 11.2 Case expressions with single condition

#### 11.2.1 When with expression

```python
when(p.i1 < 8).then(p.i1).otherwise(100)
```

#### 11.2.2 When with boolean column

```python
when(p.b1).then(p.i1).otherwise(100)
```

## 12 Operations on all series containing dates

### 12.1 Operations which apply to all series containing dates

#### 12.1.1 Get year

```python
p.d1.year
```

#### 12.1.2 Get month

```python
p.d1.month
```

#### 12.1.3 Get day

```python
p.d1.day
```

#### 12.1.4 To first of year

```python
p.d1.to_first_of_year()
```

#### 12.1.5 To first of month

```python
p.d1.to_first_of_month()
```

#### 12.1.6 Add days

```python
p.d1 + days(p.i1)
```

#### 12.1.7 Subtract days

```python
p.d1 - days(p.i1)
```

#### 12.1.8 Add months

```python
p.d1 + months(p.i1)
```

#### 12.1.9 Add years

```python
p.d1 + years(p.i1)
```

#### 12.1.10 Add date to duration

```python
days(100) + p.d1
```

#### 12.1.11 Difference between dates in years

```python
(date(2021, 2, 28) - p.d1).years
```

#### 12.1.12 Difference between dates in months

```python
(p.d1 - p.d2).months
```

#### 12.1.13 Difference between dates in days

```python
(p.d1 - p.d2).days
```

#### 12.1.14 Reversed date differences

```python
(p.d1 - "1980-01-20").years
```

#### 12.1.15 Add days to static date

```python
date(2000, 1, 1) + days(p.i1)
```

#### 12.1.16 Add months to static date

```python
date(2000, 1, 1) + months(p.i1)
```

#### 12.1.17 Add years to static date

```python
date(2000, 1, 1) + years(p.i1)
```

### 12.2 Comparisons involving dates

#### 12.2.1 Is before

```python
p.d1.is_before(date(2000, 1, 1))
```

#### 12.2.2 Is on or before

```python
p.d1.is_on_or_before(date(2000, 1, 1))
```

#### 12.2.3 Is after

```python
p.d1.is_after(date(2000, 1, 1))
```

#### 12.2.4 Is on or after

```python
p.d1.is_on_or_after(date(2000, 1, 1))
```

#### 12.2.5 Is in

```python
p.d1.is_in([date(2010, 1, 1), date(1900, 1, 1)])
```

#### 12.2.6 Is not in

```python
p.d1.is_not_in([date(2010, 1, 1), date(1900, 1, 1)])
```

#### 12.2.7 Is between but not on

```python
p.d1.is_between_but_not_on(date(2010, 1, 2), date(2010, 1, 4))
```

#### 12.2.8 Is on or between

```python
p.d1.is_on_or_between(date(2010, 1, 2), date(2010, 1, 4))
```

#### 12.2.9 Is during

```python
p.d1.is_during(interval)
```

#### 12.2.10 Is on or between backwards

```python
p.d1.is_on_or_between(date(2010, 1, 4), date(2010, 1, 2))
```

### 12.3 Types usable in comparisons involving dates

#### 12.3.1 Accepts python date object

```python
p.d1.is_before(datetime.date(2000, 1, 20))
```

#### 12.3.2 Accepts iso formated date string

```python
p.d1.is_before("2000-01-20")
```

#### 12.3.3 Accepts another date series

```python
p.d1.is_before(p.d2)
```

### 12.4 Aggregations which apply to all series containing dates

#### 12.4.1 Count episodes

```python
e.d1.count_episodes_for_patient(days(3))
```

## 13 Operations on all series containing strings

### 13.1 Testing whether one string contains another string

#### 13.1.1 Contains fixed value

```python
p.s1.contains("ab")
```

#### 13.1.2 Contains fixed value with special characters

```python
p.s1.contains("/a%b_")
```

#### 13.1.3 Contains value from column

```python
p.s1.contains(p.s2)
```

#### 13.1.4 Contains value from column with special characters

```python
p.s1.contains(p.s2)
```

## 14 Defining the dataset population

### 14.1 Defining a population

`define_population` is used to limit the population from which data is extracted.

#### 14.1.1 Population with single table
Extract a column from a patient table after limiting the population by another column.

```python
p.i1
define_population(~p.b1)
```

#### 14.1.2 Population with multiple tables
Limit the patient population by a column in one table, and return values from another
table.

```python
e.exists_for_patient()
define_population(p.i1 > 0)
```

#### 14.1.3 Case with case expression
Limit the patient population by a case expression.

```python
p.i1
define_population(
    case(
        when(p.i1 <= 8).then(True),
        when(p.i1 > 8).then(False),
    )
)
```

## 15 Operations on float series

### 15.1 Arithmetic operations without division

#### 15.1.1 Negate

```python
-p.f2
```

#### 15.1.2 Absolute

```python
(p.f1 - 200.0).absolute()
```

#### 15.1.3 Add

```python
p.f1 + p.f2
```

#### 15.1.4 Subtract with positive result

```python
p.f2 - p.f1
```

#### 15.1.5 Subtract with negative result

```python
p.f1 - p.f2
```

#### 15.1.6 Multiply

```python
p.f1 * p.f2
```

#### 15.1.7 Multiply with constant

```python
10.0 * p.f2
```

### 15.2 Comparison operations

#### 15.2.1 Less than

```python
p.f1 < p.f2
```

#### 15.2.2 Less than or equal to

```python
p.f1 <= p.f2
```

#### 15.2.3 Greater than

```python
p.f1 > p.f2
```

#### 15.2.4 Greater than or equal to

```python
p.f1 >= p.f2
```

### 15.3 Convert a float value

#### 15.3.1 Float as int
Floats are rounded towards zero.

```python
p.f1.as_int()
```

#### 15.3.2 Float as float

```python
p.f1.as_float()
```

#### 15.3.3 Add float to int

```python
p.f1 + p.i1.as_float()
```

### 15.4 Arithmetic division operations

#### 15.4.1 Truedivide

```python
p.f1 / p.f2
```

#### 15.4.2 Truedivide by constant

```python
p.f1 / 10.0
```

#### 15.4.3 Truedivide constant by series

```python
10.0 / p.f1
```

#### 15.4.4 Floordivide

```python
p.f1 // p.f2
```

#### 15.4.5 Floordivide by constant

```python
p.f1 // 10.0
```

#### 15.4.6 Floordivide constant by series

```python
10.0 // p.f1
```

### 15.5 Raise a value to a power

#### 15.5.1 Power

```python
p.f1**p.f2
```

#### 15.5.2 Raise series to a constant

```python
p.f1**10.0
```

#### 15.5.3 Raise constant to a series

```python
10.0**p.f1
```
