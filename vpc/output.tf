output "setu_task_vpc" {
  value = "${aws_vpc.setu_task_vpc.id}"
}
output "PublicSubnet1-1a" {
  value = "${aws_subnet.PublicSubnet1-1a.id}"
}
output "PublicSubnet1-1b" {
  value = "${aws_subnet.PublicSubnet1-1b.id}"
}
output "PrivateSubnet1-1a" {
  value = "${aws_subnet.PrivateSubnet1-1a.id}"
}
output "PrivateSubnet1-1b" {
  value = "${aws_subnet.PrivateSubnet1-1b.id}"
}
output "security_group_bastion" {
  value = "${aws_security_group.bastion_open.id}"
}
