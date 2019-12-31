variable "name" {
  description = "A name associated to all resources"
  type        = string
}

variable "enable_all_inspector_rule_packages" {
  description = "Create inspector assessment template with all rule package ARNs for the region"
  type        = bool
  default     = false
}

variable "inspector_rule_package_arns" {
  description = "A list of inspector rule package ARNs associated to the assessment template. See https://docs.aws.amazon.com/inspector/latest/userguide/inspector_rules-arns.html"
  type        = list(string)
  default     = []
}

variable "inspector_assessment_template_duration" {
  description = "The assessment duration"
  type        = number
  default     = 900
}

variable "cloudwatch_event_target_schedule_expression" {
  description = "the assessment run interval"
  type        = string
  default     = "rate(7 days)"
}

variable "cloudwatch_event_target_iam_role_arn" {
  description = "an iam role used by"
  type        = string
  default     = ""
}

variable "resource_group_arn" {
  description = ""
  type        = string
  default     = null

}

variable "resource_group_tags" {
  description = ""
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags applied to all taggable resources"
  type        = map(string)
  default     = {}
}
