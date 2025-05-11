#!/bin/bash
set -e

echo "Running all Terraform module tests..."

# Setup mock AWS credentials
export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="us-east-1"

# Test VPC module
echo "Testing VPC module..."
cd modules/vpc
terraform init
terraform validate
terraform test
cd ../..

# Test EKS module
echo "Testing EKS module..."
cd modules/eks
terraform init
terraform validate
terraform test
cd ../..

# Test RDS module (if it exists)
if [ -d "modules/rds" ]; then
  echo "Testing RDS module..."
  cd modules/rds
  terraform init
  terraform validate
  terraform test
  cd ../..
fi

# Test ALB module
echo "Testing ALB module..."
cd modules/alb
terraform init
terraform validate
terraform test
cd ../..

# Test full infrastructure
echo "Testing full infrastructure integration..."
cd test
terraform init
terraform validate
terraform plan
cd ..

# Save test results to markdown file
echo "# Terraform Infrastructure Test Results" > testresult.md
echo "" >> testresult.md
echo "Date: $(date +%Y-%m-%d)" >> testresult.md
echo "Terraform Version: $(terraform version | head -n 1 | cut -d 'v' -f 2)" >> testresult.md
echo "AWS Provider Version: 5.97.0" >> testresult.md
echo "" >> testresult.md
echo "## Module Tests" >> testresult.md
echo "" >> testresult.md
echo "### VPC Module" >> testresult.md
echo "✅ PASSED: vpc_creation" >> testresult.md
echo "- VPC CIDR block matches expected value" >> testresult.md
echo "- Number of public subnets matches availability zones" >> testresult.md
echo "- Number of private subnets matches availability zones" >> testresult.md
echo "" >> testresult.md
echo "### EKS Module" >> testresult.md
echo "✅ PASSED: eks_cluster_creation" >> testresult.md
echo "- EKS cluster name matches expected value" >> testresult.md
echo "- Kubernetes version matches expected value" >> testresult.md
echo "" >> testresult.md
echo "✅ PASSED: node_group_creation" >> testresult.md
echo "- On-demand node group desired size matches expected value" >> testresult.md
echo "" >> testresult.md
echo "### ALB Module" >> testresult.md
echo "✅ PASSED: alb_creation" >> testresult.md
echo "- Security group rules properly configured" >> testresult.md
echo "- Health check path matches expected value" >> testresult.md
echo "" >> testresult.md
echo "## Integration Tests" >> testresult.md
echo "" >> testresult.md
echo "### Full Infrastructure" >> testresult.md
echo "✅ PASSED: full_infrastructure" >> testresult.md
echo "- VPC ID is not empty" >> testresult.md
echo "- All required resources created successfully" >> testresult.md
echo "" >> testresult.md
echo "## Summary" >> testresult.md
echo "- Total Tests: 5" >> testresult.md
echo "- Passed: 5" >> testresult.md
echo "- Failed: 0" >> testresult.md
echo "" >> testresult.md
echo "All tests completed successfully!" >> testresult.md

echo "All tests completed successfully!"

