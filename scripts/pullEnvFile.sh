#!/bin/bash
###################################################################################################
#   Used by GitHub Actions To Pull the Environment File from 1Password                            #  
###################################################################################################

curl -o 1pass.deb https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-amd64-latest.deb
dpkg -i 1pass.deb

echo "reading 1Password for TFVars - Staging"
op read op://4eyyuwddp6w4vxlabrr2i2duxm/"TFVars - Staging"/notesPlain > .env
echo "done."