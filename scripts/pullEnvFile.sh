#!/bin/bash
###################################################################################################
#   Used by GitHub Actions To Pull the Environment File from 1Password                            #  
###################################################################################################

TARGET=$1

pwd
echo "reading 1Password for TFVars - Staging"
op read op://4eyyuwddp6w4vxlabrr2i2duxm/"TFVars - Staging"/notesPlain > staging.tfvars
echo "done."