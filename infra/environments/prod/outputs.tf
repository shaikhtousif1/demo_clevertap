output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "redis_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "logs_bucket_name" {
  value = aws_s3_bucket.logs.bucket
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}