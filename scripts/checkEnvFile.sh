#!/bin/bash
VARFILE=$1
echo "Checking if TFVars file exists..."
if ! [ -f $VARFILE ]
then
  echo "TFVars file doesn't exist... fetching."
  exit 1
else
  echo "TFVars file exists. Checking contents."
  CONTENTS=$(cat $VARFILE)
  if [ "$CONTENTS" = "" ]
  then
    echo "TFVars file is empty. Refetching"
  else
    CHECK=true
  fi
fi

if [ "$CHECK" = true ] ;
then
  echo "Checking for configuration changes between local and remote TFVars..."
  op read op://4eyyuwddp6w4vxlabrr2i2duxm/"Ben - Dev.hcl"/notesPlain > /var/tmp/op_secret
  
  cat $VARFILE > /var/tmp/local_secret
  DIFF=$(diff /var/tmp/op_secret /var/tmp/local_secret)
  if [ "$DIFF" != "" ] 
  then
      echo "Your local var file is different than what's in 1Password. Would you like to:"
      echo "  push - push your local changes to 1Password"
      echo "  pull - pull the 1Password changes down and overwrite your local copy"
      echo 
      echo "Changes:"
      echo $DIFF
      echo
      echo "Enter \"push\", \"pull\", or something else (ie to continue with differing tfvars)"

      read RESPONSE

      if [ "$RESPONSE" == "push" ]; then
        echo "Updating Remote."
        
        if op item edit "Ben - Dev.hcl" notesPlain="$(cat $VARFILE)" > /dev/null ; then
          echo "Done."
        else
          echo "WARNING: UPDATE FAILED"
        fi
        
      elif [ "$RESPONSE" == "pull" ]; then
        echo "Updating local file"
        op read op://4eyyuwddp6w4vxlabrr2i2duxm/"Ben - Dev.hcl"/notesPlain > $VARFILE
        echo "Done."
        echo "STOPPING THIS RUN. TERRAFORM NEEDS TO BE RE-RUN TO PICK UP THE DEV FILE."
        echo "PLEASE RE-RUN YOUR COMMAND."
        exit 1
      else
        echo "Local variables differ from 1Password, proceeding anyway ¯\_(ツ)_/¯"
      fi
  else
    echo "No Changes Detected..."
  fi
else 
  op read op://4eyyuwddp6w4vxlabrr2i2duxm/"Ben - Dev.hcl"/notesPlain > $VARFILE
  echo "Done."
  echo "STOPPING THIS RUN. TERRAFORM NEEDS TO BE RE-RUN TO PICK UP THE DEV FILE."
  echo "PLEASE RE-RUN YOUR COMMAND."
  exit 1
fi