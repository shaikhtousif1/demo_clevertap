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
    }
  }
  
  mock_resource "aws_subnet" {
    defaults = {
      id = "subnet-12345"
    }
  }
  
  mock_resource "aws_eks_cluster" {
    defaults = {
      id = "eks-12345"
      name = "test-eks-cluster"
    }
  }
}

run "full_infrastructure" {
  command = plan

  assert {
    condition     = module.vpc.vpc_id != ""
    error_message = "VPC ID should not be empty"
  }
}
