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

# Mock the AWS provider
mock_provider "aws" {
  mock_resource "aws_eks_cluster" {
    defaults = {
      id = "eks-12345"
      name = "test-eks-cluster"
      version = "1.27"
      vpc_config = [{
        subnet_ids = ["subnet-1", "subnet-2"]
      }]
      endpoint = "https://example.com"
      certificate_authority = [{
        data = "dGVzdA=="
      }]
    }
  }
  
  mock_resource "aws_eks_node_group" {
    defaults = {
      id = "node-12345"
      cluster_name = "test-eks-cluster"
      node_group_name = "test-node-group"
      scaling_config = [{
        desired_size = 2
        min_size = 1
        max_size = 4
      }]
    }
  }
  
  mock_resource "aws_iam_role" {
    defaults = {
      id = "role-12345"
      name = "test-role"
      arn = "arn:aws:iam::123456789012:role/test-role"
    }
  }
}

run "eks_cluster_creation" {
  command = plan

  assert {
    condition     = aws_eks_cluster.main.name == "${var.environment}-eks-cluster"
    error_message = "EKS cluster name does not match expected value"
  }

  assert {
    condition     = aws_eks_cluster.main.version == var.kubernetes_version
    error_message = "Kubernetes version does not match expected value"
  }
}

run "node_group_creation" {
  command = plan

  assert {
    condition     = aws_eks_node_group.on_demand.scaling_config[0].desired_size == var.on_demand_desired_size
    error_message = "On-demand node group desired size does not match expected value"
  }
}


