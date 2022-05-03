
resource "aws_sqs_queue" "priority_db_tasks_queue" {
  name                  = "${var.celery_queue_prefix}${var.sqs_priority_db_tasks_queue_name}"
  fifo_queue            = true
  deduplication_scope   = "messageGroup"
  fifo_throughput_limit = "perMessageGroupId"
}
