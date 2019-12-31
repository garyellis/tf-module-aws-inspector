# tf-module-aws-inspector
Create amazon inspector assessments configuration.

* optionally creates resource group
* creates assessment target
* creates assessment template from input list of assessment rule package arns
* optionally enables all assessment rule packages on assessment template
* creates assessment run
* creates iam policy, service role, and cloudwatch events schedule
