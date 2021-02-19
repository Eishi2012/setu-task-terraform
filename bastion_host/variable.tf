variable "instance_types" {
  description = "Instance Type"
  default = "t2.micro"

}

## ---------------------------------
## Instance AMIs
## ---------------------------------

variable "generic_amis" {
  default = "ami-08e0ca9924195beba"
}
variable "security_group" {
  type = list(string) 
}
variable "subnet_pub1_1a" {
}


