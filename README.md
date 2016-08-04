# eCivis Data Integration: sftp-upload

The shell script `upload-transactions.sh` will upload a CSV file to the eCivis Data Integration SFTP server when configured with your specifics:

* `TXN_PATH` - The directory containing the generated CSV file
* `TXN_FILE` - The name of the generated CSV file
* `SSH_KEY` - The SSH private key issued during eCivis Data Integration setup
* `SFTP_HOST` - The SFTP server hostname. Use di-ft-test.ecivis.com initially; switch to di-ft-prod.ecivis.com when instructed
* `SFTP_USER` - The SFTP username issued during eCivis Data Integration setup
* `SFTP_PATH` - This can remain as-is
* `MAIL_ENABLED` - If email is desired on success/failure, leave as yes. Otherwise, set to no.
* `MAIL_TO` - Enter the email address to receive notification
* `MAIL_SUBJECT` - Change if needed to match an existing filter string

