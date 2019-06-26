# Bash script for backing up remote mysql database to Google Cloud Storage


# Check to make sure all required variables exist
[ -z "$GCS_FULL_BUCKET_UPLOAD_PATH" ] && echo "GCS_FULL_BUCKET_UPLOAD_PATH Not Set" && exit 1
[ -z "$MYSQL_DATABASE" ] && echo "MYSQL_DATABASE Not Set" && exit 1
[ -z "$MYSQL_ROOT_PASSWORD" ] && echo "MYSQL_ROOT_PASSWORD Not Set" && exit 1
[ -z "$MYSQL_HOST" ] && echo "MYSQL_HOST Not Set" && exit 1
[ ! -f /var/secrets/google/gcp_service_account.json ] && echo "GCS Service Account Does Not Exist" && exit 1


# Generate export variables from current datetime
export BACKUP_DATETIME=`date '+%Y-%m-%d__%H-%M'`
export BACKUP_LOCAL_FILENAME=mysql_$MYSQL_DATABASE_backup_$BACKUP_DATETIME.sql
export TAR_LOCAL_FILENAME=mysql_$MYSQL_DATABASE_backup_$BACKUP_DATETIME.tar.gz


# Dump the mysql database to a local file and upload to Google Cloud Storage
mysqldump -h $MYSQL_HOST -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE > $BACKUP_LOCAL_FILENAME && \
    tar -czvf $TAR_LOCAL_FILENAME $BACKUP_LOCAL_FILENAME && \
    gsutil -m cp $TAR_LOCAL_FILENAME $GCS_FULL_BUCKET_UPLOAD_PATH
