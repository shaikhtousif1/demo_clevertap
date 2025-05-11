provider "aws" {
  region = var.region
  alias  = "us-west-2"
  default_tags {
    tags = {
      Environment = var.environment
      Project     = "CustomerEngagementPlatform"
      ManagedBy   = "Terraform"
    }
  }
}

# Create VPC
module "vpc" {
  source = "../../modules/vpc"
  providers = {
    aws = aws.us-west-2
  }

  region             = var.region
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

# Create EKS cluster
module "eks" {
  source = "../../modules/eks"
  providers = {
    aws = aws.us-west-2
  }

  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  
  kubernetes_version     = var.kubernetes_version
  on_demand_instance_types = var.on_demand_instance_types
  on_demand_desired_size = var.on_demand_desired_size
  on_demand_min_size     = var.on_demand_min_size
  on_demand_max_size     = var.on_demand_max_size
  spot_instance_types    = var.spot_instance_types
  spot_desired_size      = var.spot_desired_size
  spot_min_size          = var.spot_min_size
  spot_max_size          = var.spot_max_size
}

# Create RDS instance
module "rds" {
  source = "../../modules/rds"
  providers = {
    aws = aws.us-west-2
  }

  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  allowed_security_groups = [module.eks.node_security_group_id]
  
  engine_version        = var.db_engine_version
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  db_name               = var.db_name
  username              = var.db_username
  password              = var.db_password
  skip_final_snapshot   = var.db_skip_final_snapshot
}

# Create ALB
module "alb" {
  source = "../../modules/alb"
  providers = {
    aws = aws.us-west-2
  }

  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  
  health_check_path         = var.health_check_path
  certificate_arn           = var.certificate_arn
  enable_deletion_protection = var.enable_deletion_protection
}

# Create ElastiCache Redis
resource "aws_elasticache_subnet_group" "redis" {
  provider   = aws.us-west-2
  name       = "${var.environment}-redis-subnet-group"
  subnet_ids = module.vpc.private_subnet_ids
}

resource "aws_security_group" "redis" {
  provider    = aws.us-west-2
  name        = "${var.environment}-redis-sg"
  description = "Security group for Redis"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_replication_group" "redis" {
  provider                   = aws.us-west-2
  replication_group_id       = "${var.environment}-redis"
  description                = "Redis cluster for ${var.environment}"
  node_type                  = var.redis_node_type
  port                       = 6379
  parameter_group_name       = "default.redis6.x"
  automatic_failover_enabled = true
  engine_version             = "6.x"
  subnet_group_name          = aws_elasticache_subnet_group.redis.name
  security_group_ids         = [aws_security_group.redis.id]
  num_cache_clusters         = 2
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
}

# Create S3 bucket for logs and assets
resource "aws_s3_bucket" "logs" {
  provider = aws.us-west-2
  bucket   = "${var.environment}-logs-${var.account_id}-west"
}

resource "aws_s3_bucket_versioning" "logs" {
  provider = aws.us-west-2
  bucket   = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  provider = aws.us-west-2
  bucket   = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket" "assets" {
  provider = aws.us-west-2
  bucket   = "${var.environment}-assets-${var.account_id}-west"
}

resource "aws_s3_bucket_versioning" "assets" {
  provider = aws.us-west-2
  bucket   = aws_s3_bucket.assets.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets" {
  provider = aws.us-west-2
  bucket   = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}