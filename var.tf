################################################
#VARIABLES
################################################
variable "region" {
    description = "AWS_Region"
    type        = string
    default     = "ap-south-1"
  
}

# variable "access_key" {
#     description = "AWS Access Key"
#     type = string
   
  
# }

# variable "secret_key" {
#     description = "AWS Access Key"
#     type = string
    
  
# }

variable "public_subnets" {
    description = "Map of subnet names to CIDR blocks"
    type = map(string)
    default = {
      public-subnet-1 = "50.0.1.0/24"
      public-subnet-2 = "50.0.2.0/24"

    }
  
}

variable "az_map" {
    description = "Availability Zone for each subnet"
    type = map(string)
    default = {
      public-subnet-1 = "ap-south-1a"
      public-subnet-2 = "ap-south-1b"
      PVT-subnet-1 = "ap-south-1a"
      PVT-subnet-2 = "ap-south-1b"
    }
  
}

variable "PVT_subnets" {
    description = "Map of subnet names to CIDR blocks"
    type = map(string)
    default = {
      PVT-subnet-1 = "50.0.3.0/24"
      PVT-subnet-2 = "50.0.4.0/24"
    }
  
}

variable "security_groups" {
    description = "Map of SG rules: name suffix -> port"
    type = map(number)
    default = {
      ssh  = 22
      http = 80
      icmp = -1
    }
  
}

variable "ami_id" {
    description = "AMI ID for EC2"
    type = string
    default = "ami-0521bc4c70257a054"      
}

variable "instance_type" {
    description = "EC2 instance type"
    type = string
    default = "t2.micro"
  
}

variable "env" {
    description = "Deployment Environment"
    type = string
    default = "Dev"
  
}