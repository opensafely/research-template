# Dev container experiment

This is an experiment to see if
we can make OpenSAFELY tooling easier for users to install,
cross-platform and locally.

It contains a `devcontainer.json` that configures a Visual Studio Code dev container.
This container contains some rudimentary tooling that might get someone setup with OpenSAFELY,
without installing Python themselves.

## Requirements

* Docker
* Visual Studio Code

## What gets installed?

* Consult the [devcontainer.json](.devcontainer/devcontainer.json) to see everything.
* In brief:
  * a Debian installation with Python and Git already installed
  * Jupyter
  * a couple of Visual Studio Code extensions,
    more as an example of how to do that
  * OpenSAFELY (specified via the `requirements` files)

## Trying out this repository

### Starting up locally

To run locally:

1. Clone this repository with `git clone`.
1. Change to the repository directory.
1. Checkout this branch with `git checkout`.
1. Run Visual Studio Code: `code .`
1. Visual Studio Code should prompt that there is a dev container configuration
   and ask if you want to reopen the folder in a container
   (or go to VSCode's Command Palette and select "Reload in container").

### Starting up via Codespaces

Alternatively you can run this via GitHub Codespaces:

1. Create a new, empty repository of your own under your own GitHub username.
1. Push a copy (not a fork) of this repository to that remote repository.
1. View this branch on GitHub, from the branches dropdown in the repository file view.
1. Select "Code" and open a GitHub Codespace.

(It has to be your own copy,
because otherwise GitHub tries to open the Codespace under the `opensafely` organisation,
which, at this time, does not allow me to do so due to billing issues.
Your personal account gets an allowance of free Codespace usage per month.)

### Running tools

If the dev container starts successfully,
you should be able to run commands inside the VSCode terminal,
These commands are actually running inside the dev container.

Things you could try:

* `opensafely run run_all`
* `jupyter lab`
  * Note that in Codespaces, you'll have to do something like:
    Ctrl+click on the localhost link in the terminal.
    When you do this,
    the VSCode Ports tab updates to give you an actual `github.dev` link to the running server.
* Running ehrQL's sandbox:
  1. Download the example data:
     `wget "https://github.com/opensafely-core/ehrql-example-data/archive/refs/heads/main.zip"`
  2. Unzip the example data:
     `unzip main.zip`
  3. Run the sandbox:
     `opensafely exec ehrql:v0 sandbox ehrql-example-data-main`
  4. In the sandbox: `from ehrql.tables.beta.core import patients` and press Enter.
  5. In the sandbox: `patients` and press Enter, to see the example patients data.

## Potential issues

* VSCode can have different installation methods.
  Might these cause problems?
  * On Linux, there are packages for package managers and a snap.
  * On Windows, you can have a per-user or full system installation.
* Rootless Docker doesn't give the correct permissions for files in the dev container:
  https://github.com/microsoft/vscode-remote-release/issues/4646

## Other ideas

* [R Studio dev container installation](https://github.com/revodavid/devcontainers-rstudio)
* [Installing a full desktop in a dev container](https://web.archive.org/web/20230320153217/https://technology.amis.nl/software-development/run-and-access-gui-inside-vs-code-devcontainers/)

***

# ${GITHUB_REPOSITORY_NAME}

You can run this project via [Gitpod](https://gitpod.io) in a web browser by clicking on this badge: [![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-908a85?logo=gitpod)](https://gitpod.io/#https://github.com/${GITHUB_REPOSITORY})

[View on OpenSAFELY](https://jobs.opensafely.org/repo/https%253A%252F%252Fgithub.com%252Fopensafely%252F${GITHUB_REPOSITORY_NAME})

Details of the purpose and any published outputs from this project can be found at the link above.

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
