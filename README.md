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
  
# Running this repository against dummy data

[//]: # (TODO: Add instructions for codespaces)

For your interest — to evaluate the code only, without any use of any actual patient data — you can execute the code for this project against randomly generated dummy patient data via....

# DISCLAIMER

This repository contains technical content. It is not a research publication. It has been made public to support the OpenSAFELY [open science and transparency principles](https://www.opensafely.org/about/#contributing-to-best-practice-around-open-science) and to support the sharing of re-usable code for other subsequent users of the OpenSAFELY platform. 
This repository must be interpreted in context: it may reflect the final codebase for a published project; or it may be an incomplete project; or have other shortcomings to be expected of a technical working document shared during development of the work. Therefore the contents of this repository may not be an accurate or valid representation of the study or its purpose. For this, you should view the project on OpenSAFELY using the link provided above.

No clinical, policy or safety conclusions must be drawn from the contents of this repository.


# About the OpenSAFELY framework

The OpenSAFELY framework is a Trusted Research Environment (TRE) for electronic
health records research in the NHS, with a focus on public accountability and
research quality.

Read more at [OpenSAFELY.org](https://opensafely.org).

# Licences
As standard, research projects have a MIT license. 
