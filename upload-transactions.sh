#!/bin/bash

TXN_PATH=/mnt/exports
TXN_FILE=ecivis-transactions.csv
SSH_KEY=$HOME/.ssh/ecivis-data-integration.key
SFTP_HOST=di-ft-test.ecivis.com
SFTP_USER=sftpuser
SFTP_PATH=/home/$SFTP_USER/data/queue
MAIL_ENABLED=yes
MAIL_TO=admin@your-domain.tld
MAIL_SUBJECT="eCivis Transaction Upload"

error() {
  if [ "_$MAIL_ENABLED" == _yes ]; then
    echo -e "Error: $1" | tr -d \\r | mail -s "$MAIL_SUBJECT: Error" "$MAIL_TO"
  else
    echo "Error: $1"
  fi
  exit 1
}

# Validation
if [ ! -f "$TXN_PATH/$TXN_FILE" ]; then
  error "The transaction file ($TXN_PATH/$TXN_FILE) was not found."
elif [ ! -f "$SSH_KEY" ]; then
  error "The SFTP user's private key file ($SSH_KEY) was not found."
fi

# Ensure the private key is protected
chmod 0600 "$SSH_KEY"

# Upload transaction file
SFTP_OUT=$(
sftp -oIdentityFile="$SSH_KEY" -oIdentitiesOnly=yes -oCheckHostIP=no -oStrictHostKeyChecking=no -oLogLevel=INFO -oCompression=yes $SFTP_USER@$SFTP_HOST 2>&1 <<EOF
cd $SFTP_PATH
put $TXN_PATH/$TXN_FILE
ls -l $TXN_FILE
quit
EOF
)

# Notify administrator
if [ $? == 0 ]; then
  if [ "_$MAIL_ENABLED" == _yes ]; then
    echo -e "Successfully uploaded $TXN_FILE to $SFTP_HOST\n\n$SFTP_OUT" | tr -d \\r | mail -s "$MAIL_SUBJECT: Success" "$MAIL_TO"
  else
    echo "Successfully uploaded $TXN_FILE to $SFTP_HOST"
  fi
  exit 0
else
  if [ "_$MAIL_ENABLED" == _yes ]; then
    echo -e "Error uploading $TXN_FILE to $SFTP_HOST\n\n$SFTP_OUT" | tr -d \\r | mail -s "$MAIL_SUBJECT: Failure" "$MAIL_TO"
  else
    echo "Error uploading $TXN_FILE to $SFTP_HOST"
  fi
  exit 1
fi