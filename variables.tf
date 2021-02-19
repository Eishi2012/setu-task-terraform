## ---------------------------------
## Regions
## ---------------------------------
variable "region" {
  description = "region"
  default = "ap-south-1"
}

## ---------------------------------
## VPC CIDR
## ---------------------------------
variable "vpc_cidr" {
  description = "VPC CIDR"
}
## ---------------------------------
## Subnet Name 
## ---------------------------------
variable "publicSubnet1-1a" {
   description = "Public Subnet CIDR1-1a"
}
variable "publicSubnet1-1b" {
   description = "Public Subnet CIDR1-1b"
}
variable "privateSubnet1-1a" {
   description = "Private Subnet CIDR1-1a"
}
variable "privateSubnet1-1b" {
   description = "Private Subnet CIDR1-1b"
}

