set password_encryption = 'md5';
create role quicksight_db_user with login password $QUICKSIGHT_DB_PASSWORD;
Grant rds_superuser to quicksight_db_user;