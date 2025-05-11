variables {
  region = "us-east-1"
  environment = "test"
  vpc_cidr = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
}

# Mock the AWS provider
mock_provider "aws" {
  mock_resource "aws_vpc" {
    defaults = {
      id = "vpc-12345"
      cidr_block = "10.0.0.0/16"
      enable_dns_support = true
      enable_dns_hostnames = true
      tags = {
        Name = "test-vpc"
      }
    }
  }
  
  mock_resource "aws_subnet" {
    defaults = {
      id = "subnet-12345"
      cidr_block = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      tags = {
        Name = "test-subnet"
      }
    }
  }
  
  mock_resource "aws_internet_gateway" {
    defaults = {
      id = "igw-12345"
      tags = {
        Name = "test-igw"
      }
    }
  }
  
  mock_resource "aws_nat_gateway" {
    defaults = {
      id = "nat-12345"
      tags = {
        Name = "test-nat"
      }
    }
  }
  
  mock_resource "aws_route_table" {
    defaults = {
      id = "rt-12345"
      tags = {
        Name = "test-rt"
      }
    }
  }
}

run "vpc_creation" {
  command = plan

  assert {
    condition     = aws_vpc.main.cidr_block == var.vpc_cidr
    error_message = "VPC CIDR block does not match expected value"
  }

  assert {
    condition     = length(aws_subnet.public) == length(var.availability_zones)
    error_message = "Number of public subnets doesn't match availability zones"
  }

  assert {
    condition     = length(aws_subnet.private) == length(var.availability_zones)
    error_message = "Number of private subnets doesn't match availability zones"
  }
}

