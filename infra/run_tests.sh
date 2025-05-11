#!/bin/bash

# Set -e to exit on any error
set -e

echo "Running VPC module tests..."
cd infra/modules/vpc
# Make sure the test file exists
if [ ! -f "vpc.tftest.hcl" ]; then
  echo "Creating VPC test file..."
  cat > vpc.tftest.hcl << 'EOF'
variables {
  region = "us-east-1"
  environment = "test"
  vpc_cidr = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
}

run "vpc_creation" {
  command = plan

  assert {
    condition     = aws_vpc.main.cidr_block == var.vpc_cidr
    error_message = "VPC CIDR block does not match expected value"
  }
}
EOF
fi

# Run the test
terraform init
terraform test

echo "Running EKS module tests..."
cd ../eks
# Make sure the test file exists
if [ ! -f "eks.tftest.hcl" ]; then
  echo "Creating EKS test file..."
  cat > eks.tftest.hcl << 'EOF'
variables {
  environment = "test"
  vpc_id = "vpc-12345"
  private_subnet_ids = ["subnet-1", "subnet-2"]
  kubernetes_version = "1.27"
  on_demand_instance_types = ["m5.large"]
  on_demand_desired_size = 2
  on_demand_min_size = 1
  on_demand_max_size = 4
  spot_instance_types = ["m5.large", "m4.large"]
  spot_desired_size = 3
  spot_min_size = 1
  spot_max_size = 10
}

run "eks_cluster_creation" {
  command = plan

  assert {
    condition     = aws_eks_cluster.main.name == "${var.environment}-eks-cluster"
    error_message = "EKS cluster name does not match expected value"
  }
}
EOF
fi

# Run the test
terraform init
terraform test

echo "All tests completed successfully!"
cd ../../..

