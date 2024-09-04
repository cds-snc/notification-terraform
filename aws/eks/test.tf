data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = split("/", data.aws_caller_identity.current.arn)[1] 
}


output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}