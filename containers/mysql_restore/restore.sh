# Script for restoring a snapshot of a mysql database

# Check to make sure all required variables exist
[ -z "$GCS_MYSQL_SNAPSHOT" ] && echo "GCS_MYSQL_SNAPSHOT Not Set" && exit 1
[ -z "$MYSQL_DATABASE" ] && echo "MYSQL_DATABASE Not Set" && exit 1
[ -z "$MYSQL_ROOT_PASSWORD" ] && echo "MYSQL_ROOT_PASSWORD Not Set" && exit 1
[ -z "$MYSQL_HOST" ] && echo "MYSQL_HOST Not Set" && exit 1
[ ! -f /var/secrets/google/gcp_service_account.json ] && echo "GCS Service Account Does Not Exist" && exit 1


# Check to make sure backup exists in Google Cloud Storage
if [ ! gsutil stat $GCS_MYSQL_SNAPSHOT ]; then echo "Snapshot Does Not Exist" && exit 1; fi;


# Set Local Variables
export MYSQL_RESTORE_PATH=/code/downloaded_restore.tar.gz
export MYSQL_RESTORE_EXTRACTED=/code/*.sql


# Download the snapshot from GCS and restore it into the running DB (in another pod)
gsutil -m cp $GCS_MYSQL_SNAPSHOT $MYSQL_RESTORE_PATH && \
    tar -zxvf $MYSQL_RESTORE_PATH
    mysql -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < $MYSQL_RESTORE_EXTRACTED
