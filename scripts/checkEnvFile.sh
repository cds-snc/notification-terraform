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
  if [$CONTENTS = ""] 
  then
    echo "TFVars file is empty. Refetching"
  else
    CHECK=true
  fi
fi

if [ "$CHECK" = true ] ;
then
  echo "Checking for configuration changes between local and remote TFVars..."
  op read op://4eyyuwddp6w4vxlabrr2i2duxm/"TFVars - Dev"/notesPlain > /var/tmp/op_secret
  cat $VARFILE > /var/tmp/local_secret
  DIFF=$(diff /var/tmp/op_secret /var/tmp/local_secret)
  if [ "$DIFF" != "" ] 
  then
      echo "Your local var file is different than what's in 1Password. Do you want to update 1Password?"
      echo 
      echo "Changes:"
      echo $DIFF
      echo
      echo "Only \"yes\" will be accepted."

      read RESPONSE

      if [ "$RESPONSE" == "yes" ]; then
        echo "Updating Remote."
        
        if op item edit "Bentest" notesPlain="$(cat $VARFILE)" > /dev/null ; then
          echo "Done."
        else
          echo "WARNING: UPDATE FAILED"
        fi
        
      else
        echo "Remote will not be updated."
      fi
  else
    echo "No Changes Detected..."
  fi
else 
  op read op://4eyyuwddp6w4vxlabrr2i2duxm/"TFVars - Dev"/notesPlain > $VARFILE
  echo "Done."
  echo "STOPPING THIS RUN. TERRAFORM NEEDS TO BE RE-RUN TO PICK UP THE DEV FILE."
  echo "PLEASE RE-RUN YOUR COMMAND."
  exit 1
fi