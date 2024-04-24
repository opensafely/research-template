#!/bin/bash

set -euo pipefail 

pip3 install --user -r .devcontainer/requirements.in

#set R working directory
! grep -q `pwd` $R_HOME/etc/Rprofile.site && sudo tee -a $R_HOME/etc/Rprofile.site <<< "setwd(\"`pwd`\")"
#set RStudio working directory
! grep -q `pwd` ~/.config/rstudio/rstudio-prefs.json && cat ~/.config/rstudio/rstudio-prefs.json | jq ". + {\"initial_working_directory\":\"`pwd`\"}" >  ~/.config/rstudio/rstudio-prefs.json 