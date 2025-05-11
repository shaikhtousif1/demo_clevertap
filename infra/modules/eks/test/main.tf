provider "aws" {
  region = "us-east-1"
  # Use fake credentials for testing
  access_key = "mock_access_key"
  secret_key = "mock_secret_key"
  
  # Skip credential validation for testing
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

module "eks" {
  source = "../"

  environment        = "test"
  vpc_id             = "vpc-12345"
  private_subnet_ids = ["subnet-1", "subnet-2"]
  
  kubernetes_version     = "1.27"
  on_demand_instance_types = ["m5.large"]
  on_demand_desired_size = 2
  on_demand_min_size     = 1
  on_demand_max_size     = 4
  spot_instance_types    = ["m5.large", "m4.large"]
  spot_desired_size      = 3
  spot_min_size          = 1
  spot_max_size          = 10
}

# Output values for verification
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}