resource "aws_glue_catalog_table" "notifications" {
  name          = "notifications"
  database_name = aws_athena_database.notification_quicksight.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://bucket_placeholder/table/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name = "id"
      type = "string"
    }

    columns {
      name = "to"
      type = "string"
    }

    columns {
      name = "job_id"
      type = "string"
    }

    columns {
      name = "service_id"
      type = "string"
    }

    columns {
      name = "template_id"
      type = "string"
    }

    columns {
      name = "created_at"
      type = "string"
    }

    columns {
      name = "sent_at"
      type = "string"
    }

    columns {
      name = "sent_by"
      type = "string"
    }

    columns {
      name = "updated_at"
      type = "string"
    }

    columns {
      name = "reference"
      type = "string"
    }

    columns {
      name = "template_version"
      type = "integer"
    }

    columns {
      name = "job_row_number"
      type = "integer"
    }

    columns {
      name = "_personalisation"
      type = "string"
    }

    columns {
      name = "api_key_id"
      type = "string"
    }

    columns {
      name = "key_type"
      type = "string"
    }

    columns {
      name = "notification_type"
      type = "string"
    }

    columns {
      name = "billable_units"
      type = "integer"
    }

    columns {
      name = "client_reference"
      type = "string"
    }

    columns {
      name = "international"
      type = "boolean"
    }

    columns {
      name = "phone_prefix"
      type = "string"
    }

    columns {
      name = "rate_multiplier"
      type = "string"
    }

    columns {
      name = "notification_status"
      type = "string"
    }

    columns {
      name = "normalised_to"
      type = "string"
    }

    columns {
      name = "created_by_id"
      type = "string"
    }

    columns {
      name = "reply_to_text"
      type = "string"
    }

    columns {
      name = "postage"
      type = "string"
    }

    columns {
      name = "provider_response"
      type = "string"
    }

    columns {
      name = "queue_name"
      type = "string"
    }

    columns {
      name = "feedback_type"
      type = "string"
    }

    columns {
      name = "feedback_subtype"
      type = "string"
    }

    columns {
      name = "ses_feedback_id"
      type = "string"
    }

    columns {
      name = "ses_feedback_date"
      type = "string"
    }

    columns {
      name = "sms_total_message_price"
      type = "double"
    }

    columns {
      name = "sms_total_carrier_fee"
      type = "double"
    }

    columns {
      name = "sms_iso_country_code"
      type = "string"
    }

    columns {
      name = "sms_carrier_name"
      type = "string"
    }

    columns {
      name = "sms_message_encoding"
      type = "string"
    }

    columns {
      name = "sms_origination_phone_number"
      type = "string"
    }

    columns {
      name = "feedback_reason"
      type = "string"
    }

  }

  lifecycle {
    ignore_changes = [
      storage_descriptor[0].location
    ]
  }
}

resource "aws_glue_catalog_table" "notification_history" {
  name          = "notification_history"
  database_name = aws_athena_database.notification_quicksight.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://bucket_placeholder/table/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name = "id"
      type = "string"
    }

    columns {
      name = "job_id"
      type = "string"
    }

    columns {
      name = "job_row_number"
      type = "integer"
    }

    columns {
      name = "service_id"
      type = "string"
    }

    columns {
      name = "template_id"
      type = "string"
    }

    columns {
      name = "template_version"
      type = "integer"
    }

    columns {
      name = "api_key_id"
      type = "string"
    }

    columns {
      name = "key_type"
      type = "string"
    }

    columns {
      name = "notification_type"
      type = "string"
    }

    columns {
      name = "created_at"
      type = "string"
    }

    columns {
      name = "sent_at"
      type = "string"
    }

    columns {
      name = "sent_by"
      type = "string"
    }

    columns {
      name = "updated_at"
      type = "string"
    }

    columns {
      name = "reference"
      type = "string"
    }

    columns {
      name = "billable_units"
      type = "integer"
    }

    columns {
      name = "client_reference"
      type = "string"
    }

    columns {
      name = "international"
      type = "boolean"
    }

    columns {
      name = "phone_prefix"
      type = "string"
    }

    columns {
      name = "rate_multiplier"
      type = "string"
    }

    columns {
      name = "notification_status"
      type = "string"
    }

    columns {
      name = "created_by_id"
      type = "string"
    }

    columns {
      name = "postage"
      type = "string"
    }

    columns {
      name = "queue_name"
      type = "string"
    }

    columns {
      name = "feedback_type"
      type = "string"
    }

    columns {
      name = "feedback_subtype"
      type = "string"
    }

    columns {
      name = "ses_feedback_id"
      type = "string"
    }

    columns {
      name = "ses_feedback_date"
      type = "string"
    }

    columns {
      name = "sms_total_message_price"
      type = "double"
    }

    columns {
      name = "sms_total_carrier_fee"
      type = "double"
    }

    columns {
      name = "sms_iso_country_code"
      type = "string"
    }

    columns {
      name = "sms_carrier_name"
      type = "string"
    }

    columns {
      name = "sms_message_encoding"
      type = "string"
    }

    columns {
      name = "sms_origination_phone_number"
      type = "string"
    }

    columns {
      name = "feedback_reason"
      type = "string"
    }

  }

  lifecycle {
    ignore_changes = [
      storage_descriptor[0].location
    ]
  }
}

resource "aws_glue_catalog_table" "services" {
  name          = "services"
  database_name = aws_athena_database.notification_quicksight.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://bucket_placeholder/table/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name = "id"
      type = "string"
    }

    columns {
      name = "name"
      type = "string"
    }

    columns {
      name = "created_at"
      type = "string"
    }

    columns {
      name = "updated_at"
      type = "string"
    }

    columns {
      name = "active"
      type = "boolean"
    }

    columns {
      name = "message_limit"
      type = "bigint"
    }

    columns {
      name = "restricted"
      type = "boolean"
    }

    columns {
      name = "email_from"
      type = "string"
    }

    columns {
      name = "created_by_id"
      type = "string"
    }

    columns {
      name = "version"
      type = "integer"
    }

    columns {
      name = "research_mode"
      type = "boolean"
    }

    columns {
      name = "organisation_type"
      type = "string"
    }

    columns {
      name = "prefix_sms"
      type = "boolean"
    }

    columns {
      name = "crown"
      type = "boolean"
    }

    columns {
      name = "rate_limit"
      type = "integer"
    }

    columns {
      name = "contact_link"
      type = "string"
    }

    columns {
      name = "consent_to_research"
      type = "boolean"
    }

    columns {
      name = "volume_email"
      type = "integer"
    }

    columns {
      name = "volume_letter"
      type = "integer"
    }

    columns {
      name = "volume_sms"
      type = "integer"
    }

    columns {
      name = "count_as_live"
      type = "boolean"
    }

    columns {
      name = "go_live_at"
      type = "string"
    }

    columns {
      name = "go_live_user_id"
      type = "string"
    }

    columns {
      name = "organisation_id"
      type = "string"
    }

    columns {
      name = "sending_domain"
      type = "string"
    }

    columns {
      name = "default_branding_is_french"
      type = "boolean"
    }

    columns {
      name = "sms_daily_limit"
      type = "bigint"
    }

    columns {
      name = "organisation_notes"
      type = "string"
    }

    columns {
      name = "sensitive_service"
      type = "boolean"
    }

    columns {
      name = "email_annual_limit"
      type = "bigint"
    }

    columns {
      name = "sms_annual_limit"
      type = "bigint"
    }

    columns {
      name = "suspended_by_id"
      type = "string"
    }

    columns {
      name = "suspended_at"
      type = "string"
    }

  }

  lifecycle {
    ignore_changes = [
      storage_descriptor[0].location
    ]
  }
}

resource "aws_glue_catalog_table" "organisation" {
  name          = "organisation"
  database_name = aws_athena_database.notification_quicksight.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://bucket_placeholder/table/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name = "id"
      type = "string"
    }

    columns {
      name = "name"
      type = "string"
    }

    columns {
      name = "active"
      type = "boolean"
    }

    columns {
      name = "created_at"
      type = "string"
    }

    columns {
      name = "updated_at"
      type = "string"
    }

    columns {
      name = "email_branding_id"
      type = "string"
    }

    columns {
      name = "letter_branding_id"
      type = "string"
    }

    columns {
      name = "agreement_signed"
      type = "boolean"
    }

    columns {
      name = "agreement_signed_at"
      type = "string"
    }

    columns {
      name = "agreement_signed_by_id"
      type = "string"
    }

    columns {
      name = "agreement_signed_version"
      type = "double"
    }

    columns {
      name = "crown"
      type = "boolean"
    }

    columns {
      name = "organisation_type"
      type = "string"
    }

    columns {
      name = "request_to_go_live_notes"
      type = "string"
    }

    columns {
      name = "agreement_signed_on_behalf_of_email_address"
      type = "string"
    }

    columns {
      name = "agreement_signed_on_behalf_of_name"
      type = "string"
    }

    columns {
      name = "default_branding_is_french"
      type = "boolean"
    }

  }

  lifecycle {
    ignore_changes = [
      storage_descriptor[0].location
    ]
  }
}

resource "aws_glue_catalog_table" "templates" {
  name          = "templates"
  database_name = aws_athena_database.notification_quicksight.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://bucket_placeholder/table/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name = "id"
      type = "string"
    }

    columns {
      name = "name"
      type = "string"
    }

    columns {
      name = "template_type"
      type = "string"
    }

    columns {
      name = "created_at"
      type = "string"
    }

    columns {
      name = "updated_at"
      type = "string"
    }

    columns {
      name = "content"
      type = "string"
    }

    columns {
      name = "service_id"
      type = "string"
    }

    columns {
      name = "subject"
      type = "string"
    }

    columns {
      name = "created_by_id"
      type = "string"
    }

    columns {
      name = "version"
      type = "integer"
    }

    columns {
      name = "archived"
      type = "boolean"
    }

    columns {
      name = "process_type"
      type = "string"
    }

    columns {
      name = "service_letter_contact_id"
      type = "string"
    }

    columns {
      name = "hidden"
      type = "boolean"
    }

    columns {
      name = "postage"
      type = "string"
    }

    columns {
      name = "template_category_id"
      type = "string"
    }

    columns {
      name = "text_direction_rtl"
      type = "boolean"
    }

  }

  lifecycle {
    ignore_changes = [
      storage_descriptor[0].location
    ]
  }
}

resource "aws_glue_catalog_table" "template_categories" {
  name          = "template_categories"
  database_name = aws_athena_database.notification_quicksight.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://bucket_placeholder/table/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name = "id"
      type = "string"
    }

    columns {
      name = "name_en"
      type = "string"
    }

    columns {
      name = "name_fr"
      type = "string"
    }

    columns {
      name = "description_en"
      type = "string"
    }

    columns {
      name = "description_fr"
      type = "string"
    }

    columns {
      name = "sms_process_type"
      type = "string"
    }

    columns {
      name = "email_process_type"
      type = "string"
    }

    columns {
      name = "hidden"
      type = "boolean"
    }

    columns {
      name = "created_at"
      type = "string"
    }

    columns {
      name = "updated_at"
      type = "string"
    }

    columns {
      name = "sms_sending_vehicle"
      type = "string"
    }

    columns {
      name = "created_by_id"
      type = "string"
    }

    columns {
      name = "updated_by_id"
      type = "string"
    }

  }

  lifecycle {
    ignore_changes = [
      storage_descriptor[0].location
    ]
  }
}

resource "aws_glue_catalog_table" "vw_notification" {
  name          = "vw_notification"
  database_name = aws_athena_database.notification_quicksight.name
  table_type    = "VIRTUAL_VIEW"

  view_expanded_text = <<SQL
WITH
  notification_data AS (
   SELECT
     id notification_id
   , billable_units notification_billable_units
   , created_at notification_created_at
   , queue_name notification_queue_name
   , sent_at notification_sent_at
   , notification_status
   , notification_type
   , updated_at notification_updated_at
   , job_id
   , api_key_id
   , key_type api_key_type
   , service_id
   , template_id
   , reference notification_reference
   , sms_total_message_price
   , sms_total_carrier_fee
   , sms_iso_country_code
   , sms_carrier_name
   , sms_message_encoding
   , sms_origination_phone_number
   FROM
     notifications
UNION    SELECT
     id notification_id
   , billable_units notification_billable_units
   , created_at notification_created_at
   , queue_name notification_queue_name
   , sent_at notification_sent_at
   , notification_status
   , notification_type
   , updated_at notification_updated_at
   , job_id
   , api_key_id
   , key_type api_key_type
   , service_id
   , template_id
   , reference notification_reference
   , sms_total_message_price
   , sms_total_carrier_fee
   , sms_iso_country_code
   , sms_carrier_name
   , sms_message_encoding
   , sms_origination_phone_number
   FROM
     notification_history
) 
, service_data AS (
   SELECT
     s.id service_id
   , s.active service_active
   , s.restricted service_restricted
   , s.research_mode service_research_mode
   , count_as_live service_count_as_live
   , CAST(s.go_live_at AS timestamp) service_go_live_at
   , s.name service_name
   , s.message_limit service_message_limit
   , s.rate_limit service_rate_limit
   , s.sms_daily_limit service_sms_daily_limit
   , o.name organisation_name
   , s.organisation_id
   FROM
     (services s
   INNER JOIN organisation o ON (s.organisation_id = o.id))
) 
, template_data AS (
   SELECT
     t.id template_id
   , CAST(t.created_at AS timestamp) template_created_at
   , t.name template_name
   , CAST(t.updated_at AS timestamp) template_updated_at
   , t.version template_version
   , tc.id tc_id
   , tc.name_en tc_name_en
   , tc.name_fr tc_name_fr
   , tc.email_process_type tc_email_process_type
   , tc.sms_process_type tc_sms_process_type
   , tc.sms_sending_vehicle tc_sms_sending_vehicle
   FROM
     (templates t
   LEFT JOIN template_categories tc ON (tc.id = t.template_category_id))
) 
SELECT
  notification_id
, notification_billable_units
, CAST(notification_created_at AS timestamp) notification_created_at
, CAST(notification_sent_at AS timestamp) notification_sent_at
, notification_status
, notification_queue_name
, notification_type
, CAST(notification_updated_at AS timestamp) notification_updated_at
, notification_reference
, job_id
, api_key_id
, api_key_type
, sms_total_message_price
, sms_total_carrier_fee
, sms_iso_country_code
, sms_carrier_name
, sms_message_encoding
, sms_origination_phone_number
, s.*
, t.*
FROM
  ((notification_data n
INNER JOIN service_data s ON (n.service_id = s.service_id))
INNER JOIN template_data t ON (n.template_id = t.template_id))
SQL

  view_original_text = <<SQL
WITH
  notification_data AS (
   SELECT
     id notification_id
   , billable_units notification_billable_units
   , created_at notification_created_at
   , queue_name notification_queue_name
   , sent_at notification_sent_at
   , notification_status
   , notification_type
   , updated_at notification_updated_at
   , job_id
   , api_key_id
   , key_type api_key_type
   , service_id
   , template_id
   , reference notification_reference
   , sms_total_message_price
   , sms_total_carrier_fee
   , sms_iso_country_code
   , sms_carrier_name
   , sms_message_encoding
   , sms_origination_phone_number
   FROM
     notifications
UNION    SELECT
     id notification_id
   , billable_units notification_billable_units
   , created_at notification_created_at
   , queue_name notification_queue_name
   , sent_at notification_sent_at
   , notification_status
   , notification_type
   , updated_at notification_updated_at
   , job_id
   , api_key_id
   , key_type api_key_type
   , service_id
   , template_id
   , reference notification_reference
   , sms_total_message_price
   , sms_total_carrier_fee
   , sms_iso_country_code
   , sms_carrier_name
   , sms_message_encoding
   , sms_origination_phone_number
   FROM
     notification_history
) 
, service_data AS (
   SELECT
     s.id service_id
   , s.active service_active
   , s.restricted service_restricted
   , s.research_mode service_research_mode
   , count_as_live service_count_as_live
   , CAST(s.go_live_at AS timestamp) service_go_live_at
   , s.name service_name
   , s.message_limit service_message_limit
   , s.rate_limit service_rate_limit
   , s.sms_daily_limit service_sms_daily_limit
   , o.name organisation_name
   , s.organisation_id
   FROM
     (services s
   INNER JOIN organisation o ON (s.organisation_id = o.id))
) 
, template_data AS (
   SELECT
     t.id template_id
   , CAST(t.created_at AS timestamp) template_created_at
   , t.name template_name
   , CAST(t.updated_at AS timestamp) template_updated_at
   , t.version template_version
   , tc.id tc_id
   , tc.name_en tc_name_en
   , tc.name_fr tc_name_fr
   , tc.email_process_type tc_email_process_type
   , tc.sms_process_type tc_sms_process_type
   , tc.sms_sending_vehicle tc_sms_sending_vehicle
   FROM
     (templates t
   LEFT JOIN template_categories tc ON (tc.id = t.template_category_id))
) 
SELECT
  notification_id
, notification_billable_units
, CAST(notification_created_at AS timestamp) notification_created_at
, CAST(notification_sent_at AS timestamp) notification_sent_at
, notification_status
, notification_queue_name
, notification_type
, CAST(notification_updated_at AS timestamp) notification_updated_at
, notification_reference
, job_id
, api_key_id
, api_key_type
, sms_total_message_price
, sms_total_carrier_fee
, sms_iso_country_code
, sms_carrier_name
, sms_message_encoding
, sms_origination_phone_number
, s.*
, t.*
FROM
  ((notification_data n
INNER JOIN service_data s ON (n.service_id = s.service_id))
INNER JOIN template_data t ON (n.template_id = t.template_id))
SQL
}
