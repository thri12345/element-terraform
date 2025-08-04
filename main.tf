##################################################
# VPC
##################################################
resource "aws_vpc" "main" {
    cidr_block = "50.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = { Name = "my-vpc-element-project" }
  
}

######################################################
# Public Subnets
######################################################
resource "aws_subnet" "public" {
    for_each = var.public_subnets

    vpc_id = aws_vpc.main.id
    cidr_block = each.value
    availability_zone = var.az_map[each.key]
    map_public_ip_on_launch = true
    tags = {
      Name = each.key
    }
  
}

resource "aws_subnet" "private" {
for_each = var.PVT_subnets

    vpc_id = aws_vpc.main.id
    cidr_block = each.value
    availability_zone = var.az_map[each.key]
    map_public_ip_on_launch = false
    tags = {
      Name = each.key
    }
  
}

###############################################################
# Security Groups
###############################################################
resource "aws_security_group" "multi_sg" {
    for_each = var.security_groups

    name = "allow-${each.key}"
    description = "Allow ${each.key} traffic"
    vpc_id = aws_vpc.main.id

    ingress {
        description = "Allow ${each.key}"
        from_port = each.value
        to_port = each.value
        protocol = each.key == "icmp" ? "icmp" : "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "allow-${each.key}"
    }
}

##################################################################
# EC2 Instances using count and element
##################################################################
resource "aws_instance" "rhel_linux" {
    count = var.env == "Dev" ? 2 : 1
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = element(values(aws_subnet.public)[*].id, count.index)
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.multi_sg["ssh"].id]

    tags = {
      Name = "RHEL-linux-${count.index + 1}"
    }
  
}