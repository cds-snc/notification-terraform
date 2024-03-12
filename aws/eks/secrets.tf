resource "aws_secretsmanager_secret" "nginx_target_group_arn" {
  name = "NGINX_TARGET_GROUP_ARN"
}

resource "aws_secretsmanager_secret_version" "nginx_target_group_arn" {
  secret_id     = aws_secretsmanager_secret.nginx_target_group_arn.id
  secret_string = aws_alb_target_group.internal_nginx_http.arn
}

resource "aws_secretsmanager_secret" "gha_arc_pat" {
  name = "GITHUB_ARC_PAT"
}

resource "aws_secretsmanager_secret_version" "gha_arc_pat" {
  secret_id     = aws_secretsmanager_secret.gha_arc_pat.id
  secret_string = var.gha_arc_pat
}
