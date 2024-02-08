resource "aws_secretsmanager_secret" "nginx_target_group_arn" {
  name = "NGINX_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "nginx_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.nginx_target_group_arn.id
  secret_string = aws_alb_target_group.internal_nginx_http.arn
}
