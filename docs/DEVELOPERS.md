# For statisticians

The OpenSAFELY framework is a new secure analytics platform for
electronic health records research in the NHS.

Instead of requesting access for slices of patient data and
transporting them elsewhere for analysis, the framework supports
developing analytics against dummy data, and then running against the
real data *within the same infrastructure that the data is stored*.
Read more at [OpenSAFELY.org](https://opensafely.org).

The framework is under fast, active development to support rapid
analytics relating to COVID19; we're currently seeking funding to make
it easier for outside collaborators to work with our system.  Until
then, be warned that these instructions are preliminary, you will
almost certainly need more support from the OpenSAFELY team to get
running, and the framework API is changing quickly.  In other words,
if you'd like to work with us at this stage, get in touch before
writing too much code.

Currently there is a single backend implemented for the data, for
running analytics against TPP SystmOne records.  Other backends are
under development.

This repository contains everything needed to:

* Define a set of covariates needed for your model
* Generate an input dataset from dummy data against which you can develop your model
* Request that the model be run against the live data

You will need access to a dummy dataset to do this; get in touch to
request credentials.  Our first analyses are with Stata - you will,
therefore, also need a licenced copy of Stata (see below for
information about the Docker version)

Until we have developed a deployment framework, you should use this
repository as a *template* when you create a new Github Repo.  When
you do so, for the automated tests to run, you should also add two
*Secrets* to the settings for your repo:

 * `DOCKER_GITHUB_TOKEN`: a token generated using your Github account (see instructions in "Running the model against real data", below)

The entrypoint of your model **must** be called `model.do` and it must
live in the `analysis/` folder.

Your model **must** start by importing the dataset, which will be called
`input.csv` and be in the same folder.

For portability, the recommended way of starting your model is:

```stata
import delimited `c(pwd)'/output/input.csv
```

## Defining covariates

At the moment, this involves writing some simple Python code.

This must live in a file at `analysis/study_definition.py` (or
`analysis/study_definition_<name>.py` if you have multiple studies).
Until more documentation is written, refer to the sample one provided
here for inspiration; or, if you're feeling adventurous, search the
tests (in `tests/`) for `StudyDefinition` examples.

## Generating dummy data

The [OpenSAFELY cohort extractor tool](https://github.com/opensafely/cohort-extractor) provides everything you need to generate random data from your study definition. You can then use this to develop your model.

## Running the model

There are three ways to run your model:

* Directly in your usual development environent. For example, if you have Stata installed locally, just open `model.do` and run as normal
* Using a dockerised Stata docker image (documentation to follow)
