###
# Outputs — Locust redline load testing
###

output "ecs_cluster_name" {
  description = "Name of the Locust ECS cluster"
  value       = aws_ecs_cluster.locust.name
}

output "master_service_name" {
  description = "Name of the Locust master ECS service"
  value       = aws_ecs_service.locust_master.name
}

output "worker_service_name" {
  description = "Name of the Locust worker ECS service"
  value       = aws_ecs_service.locust_workers.name
}

output "locust_master_dns" {
  description = "Cloud Map DNS name that workers use to reach the master (internal to VPC)"
  value       = "master.locust.local"
}

output "vpc_id" {
  description = "ID of the isolated Locust VPC"
  value       = aws_vpc.locust.id
}

output "how_to_access_web_ui" {
  description = "Manual Locust master startup notes"
  value       = <<-EOT
    The Locust master container now stays idle so you can start Locust manually.

    Open a shell in the master task:
      aws ecs execute-command \
        --cluster ${aws_ecs_cluster.locust.name} \
        --task <TASK_ARN> \
        --container locust-master \
        --interactive \
        --command "/bin/sh"

    Then launch the master from inside the container:
      locust \
        --config ${var.locust_config_path} \
        -f ${var.locust_file_path} \
        --host ${var.locust_target_host} \
        --master \
        --headless \
        --expect-workers ${var.locust_worker_count}

    Follow execution in CloudWatch logs:
      aws logs tail ${aws_cloudwatch_log_group.locust_master.name} --follow

    Scaling workers:
      aws ecs update-service \
        --cluster ${aws_ecs_cluster.locust.name} \
        --service ${aws_ecs_service.locust_workers.name} \
        --desired-count <N>
  EOT
}
