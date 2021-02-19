## ---------------------------------
## Public Bastion Instance
## ---------------------------------

resource "aws_instance" "bastion_host" {
  ami                         = "${var.generic_amis}"
  instance_type               = "${var.instance_types}"
  vpc_security_group_ids      = "${var.security_group}"
  subnet_id                   = "${var.subnet_pub1_1a}"
}

resource "aws_eip" "bastion_host_eip" {
  vpc = true
}
resource "aws_eip_association" "bastion_host_eip_assoc" {
  instance_id   = "${aws_instance.bastion_host.id}"
}

