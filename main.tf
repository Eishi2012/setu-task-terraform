## --------------------------------
## Provider - AWS
## --------------------------------
provider "aws" {
  region = "ap-south-1"
}

## --------------------------------
## Modules
## --------------------------------
module "vpc" {
  source = "./vpc"
  region = var.region
  vpc_cidr = var.vpc_cidr
  publicSubnet1-1a = var.publicSubnet1-1a
  publicSubnet1-1b = var.publicSubnet1-1b
  privateSubnet1-1a = var.privateSubnet1-1a
  privateSubnet1-1b = var.privateSubnet1-1b
}


module "bastion_host" {

source = "./bastion_host"
security_group = [module.vpc.security_group_bastion]
subnet_pub1_1a = module.vpc.PublicSubnet1-1a
}

