# Using Terraform module
# source: https://www.terraform.io/docs/language/modules/index.html
module "cluster" {
  source = "./modules/my_resourcegroup"

  # Defines multiple resource from TF variables (list of objects)
  count                 = length(var.resourcegroup_cfg)
  resource_name         = var.resourcegroup_cfg[count.index].name
  resource_contributors = var.resourcegroup_cfg[count.index].user
}

