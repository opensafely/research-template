# Statistical disclosure control (SDC)

Please add a description of the [statistical disclosure control](https://docs.opensafely.org/outputs/sdc/) methods used in this study below. This can accessed and copied as context for your [output requests](https://docs.opensafely.org/outputs/releasing-overview/) within [airlock](https://docs.opensafely.org/using-opensafely/viewing-and-releasing-outputs/viewing-and-releasing-with-airlock/), and should be kept up-to-date to maintain openness of methods.

> Placeholder text describing your SDC approach: 
> 
> Example.csv - We suppressed counts of 7 or fewer patients and rounded counts to the nearest 5 after suppression.
> 
> Example_2.csv - We applied midpoint 6 rounding to the numerator and denominator columns, and the derived rates are labelled as 'mp6_derived' for clarity.

## SDC functions

Below are some helper functions for common approaches to SDC:

### Suppression of <=7 and rounding to 5 ([docs](https://docs.opensafely.org/outputs/sdc/#redacting-counts-less-than-or-equal-to-7))

R function:
```
suppress_and_round <- function(x) {
  # Suppress counts of 7 or fewer (including zero)
  x[x <= 7] <- NA

  # Round remaining counts to the nearest 5
  round(x / 5) * 5
}
```

Python function:

```
import numpy as np

def suppress_and_round(x):
    """
    Suppress counts of 7 or fewer (including zero)
    and round remaining counts to the nearest 5.
    """
    x = np.asarray(x, dtype=float)

    # Suppress counts of 7 or fewer
    x = np.where(x <= 7, np.nan, x)

    # Round remaining counts to the nearest 5
    return np.round(x / 5) * 5
```

If your using the [measures](https://docs.opensafely.org/ehrql/explanation/measures/) framework, there is an inbuilt function available:
```
measures.configure_disclosure_control(enabled=True)
```

### Midpoint 6 rounding ([docs](https://docs.opensafely.org/outputs/sdc/#midpoint-6-rounding))

R function:
```
roundmid_any <- function(x, to=6){

  # like round_any, but centers on (integer) midpoint of the rounding points
  ceiling(x/to)*to - (floor(to/2)*(x!=0))
}
```

Python function:
```
import math

def roundmid_any(x, to=6):

    return math.ceil(x / to) * to - math.floor(to / 2) * (x != 0)
```

Other midpoints can be used by modifying the 'to' parameter in the above functions (e.g. midpoint 10).

