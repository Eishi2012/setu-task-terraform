## ---------------------------------
## VPC Name
## ---------------------------------
variable "name_z" {
  description = " VPC Name"
  default = "setu_task"
}
variable "region" {
  description = "vpc_region"
}

## ---------------------------------
## VPC CIDR 
## ---------------------------------
variable "vpc_cidr" {
  description = "VPC CIDR"
}
## ---------------------------------
## Subnet
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
## ---------------------------------
## AZ's
## ---------------------------------
variable "azs" {
  description = "Availability Zones"
  default = ["a","b"]
}

