# State migration: prevent resource destruction during refactor
moved {
  from = aws_pinpointsmsvoicev2_configuration_set.ca
  to   = aws_pinpointsmsvoicev2_configuration_set.main
}

moved {
  from = module.pinpoint_to_sqs_sms_callbacks_us_west_2.aws_lambda_function.this
  to   = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].aws_lambda_function.this
}
moved {
  from = module.pinpoint_to_sqs_sms_callbacks_us_west_2.aws_iam_role.this
  to   = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].aws_iam_role.this
}
moved {
  from = module.pinpoint_to_sqs_sms_callbacks_us_west_2.aws_iam_policy.policies
  to   = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].aws_iam_policy.policies[0]
}
moved {
  from = module.pinpoint_to_sqs_sms_callbacks_us_west_2.aws_iam_policy.non_vpc_policies
  to   = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].aws_iam_policy.non_vpc_policies[0]
}
moved {
  from = module.pinpoint_to_sqs_sms_callbacks_us_west_2.aws_cloudwatch_log_group.this
  to   = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].aws_cloudwatch_log_group.this
}
moved {
  from = module.pinpoint_to_sqs_sms_callbacks_us_west_2.aws_cloudwatch_query_definition.lambda_statistics
  to   = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].aws_cloudwatch_query_definition.lambda_statistics
}
moved {
  from = module.pinpoint_to_sqs_sms_callbacks_us_west_2.aws_iam_role_policy_attachment.attachments
  to   = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].aws_iam_role_policy_attachment.attachments[0]
}
moved {
  from = module.pinpoint_to_sqs_sms_callbacks_us_west_2.aws_iam_role_policy_attachment.lambda_insights
  to   = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].aws_iam_role_policy_attachment.lambda_insights[0]
}
moved {
  from = module.pinpoint_to_sqs_sms_callbacks_us_west_2.aws_iam_role_policy_attachment.non_vpc_policies
  to   = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].aws_iam_role_policy_attachment.non_vpc_policies[0]
}
# --- 1. CONFIGURATION ---
locals {
  target_phone_arns = [
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-f7a9ef4e23354c5cac1cdf627fb22e06",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-f2d9164e3a404c1ba053b498089d3d90",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-ef5d5a22d30c46e1926a74f62ae6d0e6",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-ed45be349fbb46e7a09fb1185910d8d2",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-e91bb3aaa0b64ac8a79b7b6e3667700c",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-db0709c5b2ef496b80cdc2cd35e8bd1e",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-bcc03d2d1232449492694ab52a486bef",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-bb860bb09d28435da8ded41f8c17c1cd",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-ab220142f4204b5e873bb169ed6ac79c",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-aa65a10ed56545d69a673c180f3c0682",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-a8d0eca588e241eaa777e9a6f82ab3c4",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-a7f7a12177704709a6c811a2bda3aee1",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-a7d915aa58054a24952ba5cab94d7a1b",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-a3d10caf8a6c4c3b81daa248927c734d",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-9e5db9205cc34e3c9144871483901dcc",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-8668e0e720d643a7b4d2427a216f9812",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-6a3d154f28364cf5a188dd3ea5065fb1",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-598cfcc0eb8c4df8ac86f528f0660663",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-55f6a99429724e96aa25c113add6f1ff",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-50b4fc1ff57a4929a22be1708d69ab7e",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-4c94c9a35a69449db18465f66ee88985",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-3faa6632c4664c3a9cc68c661bfd1aba",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-3e08c13341b34ea196d453a4030e3866",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-392b106a592d4d1493ed52729dc95cf0",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-3050ed68826c42c8ac4f519c965641bc",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-2a6fc972ea6548f79a6c9f9d904140ed",
    "arn:aws:sms-voice:ca-central-1:800095993820:phone-number/phone-0d2809e734b14376a8bad4057d4fc17f"
  ]
}

# --- 2. NATIVE RESOURCES ---

resource "aws_pinpointsmsvoicev2_configuration_set" "main" {
  name = "notify-config-set"
}

# --- 3. THE BRIDGE (CloudFormation) ---

resource "aws_cloudformation_stack" "pinpoint_hybrid_stack" {
  name = "pinpoint-sms-bridge-stack"

  template_body = jsonencode({
    Resources = {
      SmsPool = {
        Type = "AWS::PinpointSMSVoiceV2::Pool"
        Properties = {
          OriginationIdentities = local.target_phone_arns
          MessageType           = "TRANSACTIONAL"
          TwoWayEnabled         = true
        }
      }
      SmsEventDestination = {
        Type = "AWS::PinpointSMSVoiceV2::EventDestination"
        Properties = {
          ConfigurationSetName = aws_pinpointsmsvoicev2_configuration_set.main.name
          EventDestinationName = "sqs-callback-destination"
          MatchingEventTypes   = ["ALL"]
          SnsDestination = {
            TopicArn = aws_sns_topic.sms_events.arn
          }
        }
      }
    }
    Outputs = {
      PoolId = { Value = { Ref = "SmsPool" } }
    }
  })
}

# --- 4. CALLBACK PLUMBING (SNS -> SQS) ---

resource "aws_sns_topic" "sms_events" {
  name = "pinpoint-sms-events"
}

resource "aws_sqs_queue" "sms_callbacks" {
  name = "pinpoint-sms-callbacks-queue"
}

resource "aws_sqs_queue_policy" "sns_to_sqs" {
  queue_url = aws_sqs_queue.sms_callbacks.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "sns.amazonaws.com" }
      Action    = "sqs:SendMessage"
      Resource  = aws_sqs_queue.sms_callbacks.arn
      Condition = {
        ArnEquals = { "aws:SourceArn" = aws_sns_topic.sms_events.arn }
      }
    }]
  })
}

resource "aws_sns_topic_subscription" "sms_to_sqs" {
  topic_arn = aws_sns_topic.sms_events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sms_callbacks.arn
}

# --- 5. OUTPUTS ---

output "pinpoint_pool_id" {
  value = aws_cloudformation_stack.pinpoint_hybrid_stack.outputs["PoolId"]
}

output "sqs_queue_url" {
  value = aws_sqs_queue.sms_callbacks.url
}