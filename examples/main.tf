module "inspector-assessment-network" {
  source = "../"

  name                               = "network"
  enable_all_inspector_rule_packages = false
  inspector_rule_package_arns        = ["arn:aws:inspector:us-west-2:758058086616:rulespackage/0-rD1z6dpl"]  
}

module "inspector-assessment-sec-best-practices" {
  source = "../"

  name                        = "sec-best-practices"
  inspector_rule_package_arns = [
    "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-JJOtZiqQ",
    "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-9hgA516p"
  ]
}

module "inspector-assessment-w-resource-group-filter" {
  source = "../"

  name                        = "cis-benchmarks"
  resource_group_tags         = { "Name" = "windows-demo" }
  inspector_rule_package_arns = [
    "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-H5hpSawc"
  ]
}
