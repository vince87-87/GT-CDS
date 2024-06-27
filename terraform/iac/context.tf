module "this" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  name    = "${local.env}-cds"
  enabled = true

  tags = {
    Environment = "${local.env}"
  }

}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = ["cluster"]

  context = module.this.context
  tags = {
    Environment = "${local.env}"
  }
}