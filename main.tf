# step1 configure the provider 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}


#step2 create a VPC

resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform-vpc"
  }
}

#step3 create a subnet 
resource "aws_subnet" "mypub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pubsubnet"
  }
}

#step4 internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "igw"
  }
}

#step5 route table 

resource "aws_route_table" "purtable" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "routetabel"
  }
}

#step6 subbet association


resource "aws_route_table_association" "asso" {
  subnet_id      = aws_subnet.mypub.id
  route_table_id = aws_route_table.purtable.id
}