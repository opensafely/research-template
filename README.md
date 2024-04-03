# ${GITHUB_REPOSITORY_NAME}

This is a repository for work conducted on electronic health records in England via [OpenSAFELY](https://opensafely.org).

Up to date details of this project can be found by
[viewing this project on OpenSAFELY](https://jobs.opensafely.org/repo/https%253A%252F%252Fgithub.com%252Fopensafely%252F${GITHUB_REPOSITORY_NAME}). This includes:

*  The project purpose
*  Logs for all analyses run against real patient data
*  Published outputs
*  Links to any related reports/papers

# Contents

* Analysis code can be found in the [analysis folder](./analysis/).
* If you are interested in how we defined our variables and study population, take a look at the [dataset definition](analysis/dataset_definition.py); this is written in `python`, but non-programmers should be able to understand what is going on there.
* Codelists used to define these variables can be found in the [codelists folder](./codelists/).
* The project pipeline is specified in [`project.yaml`](./project.yaml).
* The [logs](./logs/) and [outputs](./outputs/) folders are empty. These are populated when a study is run on OpenSAFELY. Logs and published outputs for analyses run against real patient data are available on OpenSAFELY via the link above.
  


The contents of this repository MUST NOT be considered an accurate or valid representation of the study or its purpose. 
This repository may reflect an incomplete or incorrect analysis with no further ongoing work.
The content has ONLY been made public to support the OpenSAFELY [open science and transparency principles](https://www.opensafely.org/about/#contributing-to-best-practice-around-open-science) and to support the sharing of re-usable code for other subsequent users.
No clinical, policy or safety conclusions must be drawn from the contents of this repository.

# About the OpenSAFELY framework

The OpenSAFELY framework is a Trusted Research Environment (TRE) for electronic
health records research in the NHS, with a focus on public accountability and
research quality.

Read more at [OpenSAFELY.org](https://opensafely.org).

# Licences
As standard, research projects have a MIT license. 
