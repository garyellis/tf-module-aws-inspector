data "aws_inspector_rules_packages" "rules" {}

locals {
  inspector_rule_package_arns = var.enable_all_inspector_rule_packages ? data.aws_inspector_rules_packages.rules.arns : var.inspector_rule_package_arns
}

resource "aws_inspector_resource_group" "group" {
  count = length(var.resource_group_tags) > 0 ? 1 : 0
  tags = var.resource_group_tags
}

locals {
  resource_group_arn = join("", aws_inspector_resource_group.group.*.arn)
}

resource "aws_inspector_assessment_target" "assessment" {
  name               = var.name
  resource_group_arn = local.resource_group_arn != "" ? local.resource_group_arn : null
}

resource "aws_inspector_assessment_template" "assessment" {
  name               = var.name
  target_arn         = aws_inspector_assessment_target.assessment.arn
  duration           = var.inspector_assessment_template_duration
  rules_package_arns = local.inspector_rule_package_arns
}


data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers =  ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "permission_policy" {
  statement {
    sid     = "InvokeInspectorAssessmentRun"
    effect  = "Allow"
    actions = [
      "inspector:StartAssessmentRun"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "iam_policy" {
  name_prefix = var.name
  description = "aws events invoke inspector assessment run"
  policy      = data.aws_iam_policy_document.permission_policy.json
}

resource "aws_iam_role" "iam_role" {
  name_prefix        = var.name
  description        = "aws events invoke inspector assessment run"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

resource "aws_iam_role_policy_attachment" "iam_role" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}


resource "aws_cloudwatch_event_rule" "assessment" {
  name_prefix         = var.name
  description         = "cron schedule for inspector assessment runs"
  is_enabled          = true
  schedule_expression = var.cloudwatch_event_target_schedule_expression
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "assessment" {
  target_id = "inspector-invoke-assessment-run"
  arn       = aws_inspector_assessment_template.assessment.arn
  rule      = aws_cloudwatch_event_rule.assessment.name
  role_arn  = aws_iam_role.iam_role.arn
}
