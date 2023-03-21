variable "NEW_RELIC_ACCOUNT_ID" {
  type = string
}

variable "NEW_RELIC_CLOUDWATCH_ENDPOINT" {
  type = string
  # Depending on where your New Relic Account is located you need to change the default
  default = "https://aws-api.newrelic.com/cloudwatch-metrics/v1" # US Datacenter
  # default = "https://aws-api.eu01.nr-data.net/cloudwatch-metrics/v1" # EU Datacenter
}

variable "NEW_RELIC_ACCOUNT_NAME" {
    type = string
    default = "Production"
}