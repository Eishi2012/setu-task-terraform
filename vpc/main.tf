## --------------------------------
## Locals variable
## --------------------------------
locals {
  az_a_z1 = "${format("%s%s", var.region, var.azs[0])}"
  az_b_z1 = "${format("%s%s", var.region, var.azs[1])}"
}

## --------------------------------
## VPC 
## --------------------------------
resource "aws_vpc" "setu_task_vpc" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  enable_classiclink_dns_support = false
}

## ---------------------------------
## Subnets - Public & Private
## ---------------------------------
resource "aws_subnet" "PublicSubnet1-1a" {
  vpc_id     = "${aws_vpc.setu_task_vpc.id}"
  cidr_block = "${var.publicSubnet1-1a}"
  availability_zone = "${local.az_a_z1}"
  tags = {
    Name = "PublicSubnet1-1a"
  }
}
resource "aws_subnet" "PublicSubnet1-1b" {
  vpc_id     = "${aws_vpc.setu_task_vpc.id}"
  cidr_block = "${var.publicSubnet1-1b}"
  availability_zone = "${local.az_b_z1}"
  tags = {
    Name = "PublicSubnet1-1b"
  }
}
resource "aws_subnet" "PrivateSubnet1-1a" {
  vpc_id     = "${aws_vpc.setu_task_vpc.id}"
  cidr_block = "${var.privateSubnet1-1a}"
  availability_zone = "${local.az_a_z1}"
  tags = {
    Name = "PrivateSubnet1-1a"
  }
}
resource "aws_subnet" "PrivateSubnet1-1b" {
  vpc_id     = "${aws_vpc.setu_task_vpc.id}"
  cidr_block = "${var.privateSubnet1-1b}"
  availability_zone = "${local.az_b_z1}"
  tags = {
    Name = "PrivateSubnet1-1b"
  }
}

## ---------------------------------
## Internet Geteway 
## ---------------------------------
resource "aws_internet_gateway" "internetgw" {
  vpc_id = "${aws_vpc.setu_task_vpc.id}"

  tags = {
    Name = "setu_vpc_igw"
  }
}

## ---------------------------------
## Elastic IP NGW
## ---------------------------------
resource "aws_eip" "ngw-eip" {
  vpc      = true
}

## ---------------------------------
## NAT Gateway 
## ---------------------------------
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.ngw-eip.id}"
  subnet_id     = "${aws_subnet.PublicSubnet1-1a.id}"
}

## ---------------------------------
## Route Tables 
## ---------------------------------
resource "aws_route_table" "Private_Route_Table" {
  vpc_id = "${aws_vpc.setu_task_vpc.id}"
  tags = {
    Name = "Private Route Table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }
}

resource "aws_route_table_association" "Private_Route_Table_Association1_1a" {
  subnet_id      = "${aws_subnet.PrivateSubnet1-1a.id}"
  route_table_id = "${aws_route_table.Private_Route_Table.id}"
}
resource "aws_route_table_association" "Private_Route_Table_Association1_1b" {
  subnet_id      = "${aws_subnet.PrivateSubnet1-1b.id}"
  route_table_id = "${aws_route_table.Private_Route_Table.id}"
}

resource "aws_route_table" "Public_Route_Table" {
  vpc_id = "${aws_vpc.setu_task_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internetgw.id}"
  }
  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "Public_Route_Table_Association1_1a" {
  subnet_id      = "${aws_subnet.PublicSubnet1-1a.id}"
  route_table_id = "${aws_route_table.Public_Route_Table.id}"
}
resource "aws_route_table_association" "Public_Route_Table_Association1_1b" {
  subnet_id      = "${aws_subnet.PublicSubnet1-1b.id}"
  route_table_id = "${aws_route_table.Public_Route_Table.id}"
}

resource "aws_security_group" "bastion_open" {
  name        = "Port 22"
  description = "Port 22"
  vpc_id = "${aws_vpc.setu_task_vpc.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
tags = {
    Name = "Bastion Host"
  }
}


resource "aws_flow_log" "setu_vpc_flow" {
  iam_role_arn    = aws_iam_role.allow_vpc_flow_logging.arn
  log_destination = aws_cloudwatch_log_group.setu_vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.setu_task_vpc.id
}

## ---------------------------------
## Cloudwatch Log Group
## ---------------------------------
resource "aws_cloudwatch_log_group" "setu_vpc_flow_logs" {
  name = "setu_vpc_flow_logs"
}

## ---------------------------------
## IAM Role
## ---------------------------------

resource "aws_iam_role" "allow_vpc_flow_logging" {
  name = "allow_vpc_flow_logging"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "allow_vpc_flow_logging_p" {
  name = "allow_vpc_flow_logging_p"
  role = aws_iam_role.allow_vpc_flow_logging.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
