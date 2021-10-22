variable "schedule_expression" {
  default     = "cron(0 0 * * ? *)"
  description = "This aws cloudwatch event rule scheule expression that specifies when the scheduler runs."
}
