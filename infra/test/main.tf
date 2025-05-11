module "vpc" {
  source = "../modules/vpc"

  region             = "us-east-1"
  environment        = "test"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
}

# Output the VPC ID for verification
output "vpc_id" {
  value = module.vpc.vpc_id
}


