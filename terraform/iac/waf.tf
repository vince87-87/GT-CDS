module "waf" {
  source  = "cloudposse/waf/aws"
  version = "1.6.0"

  association_resource_arns = ["arn:aws:elasticloadbalancing:ap-southeast-1:533266986781:loadbalancer/app/test/03cd3c845c40b0f9"]
  default_action            = "block"
  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "cds-rule-metric"
    sampled_requests_enabled   = true
  }
  managed_rule_group_statement_rules = [
    {
      name     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      priority = 1

      statement = {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      }
    },
    {
      name     = "AWS-AWSManagedRulesAmazonIpReputationList"
      priority = 2

      statement = {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      }
    },
    {
      name     = "AWS-AWSManagedRulesCommonRuleSet"
      priority = 3

      statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      }
    },

  ]

  geo_match_statement_rules = [
    {
      name     = "allow-sg"
      action   = "allow"
      priority = 80

      statement = {
        country_codes = ["SG"]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "allow-sg-metric"
      }
    }
  ]

  ip_set_reference_statement_rules = [
    {
      name     = "rule-allowed-ip"
      priority = 4
      action   = "allow"

      statement = {
        ip_set = {
          ip_address_version = "IPV4"
          addresses          = ["195.133.129.156/32"]
        }
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = "rule-allowed-ip"
      }
    }
  ]

  context = module.this.context
}