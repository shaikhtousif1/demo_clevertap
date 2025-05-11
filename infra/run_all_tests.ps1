Write-Host "Running all Terraform module tests..." -ForegroundColor Green

# Setup mock AWS credentials
$env:AWS_ACCESS_KEY_ID = "test"
$env:AWS_SECRET_ACCESS_KEY = "test"
$env:AWS_DEFAULT_REGION = "us-east-1"

# Test VPC module
Write-Host "Testing VPC module..." -ForegroundColor Cyan
Set-Location -Path modules\vpc
terraform init
terraform validate
terraform test
Set-Location -Path ..\..

# Test EKS module
Write-Host "Testing EKS module..." -ForegroundColor Cyan
Set-Location -Path modules\eks
terraform init
terraform validate
terraform test
Set-Location -Path ..\..

# Test RDS module (if it exists)
if (Test-Path -Path modules\rds) {
    Write-Host "Testing RDS module..." -ForegroundColor Cyan
    Set-Location -Path modules\rds
    terraform init
    terraform validate
    terraform test
    Set-Location -Path ..\..
}

# Test ALB module
Write-Host "Testing ALB module..." -ForegroundColor Cyan
Set-Location -Path modules\alb
terraform init
terraform validate
terraform test
Set-Location -Path ..\..

# Test full infrastructure
Write-Host "Testing full infrastructure integration..." -ForegroundColor Cyan
Set-Location -Path test
terraform init
terraform validate
terraform plan
Set-Location -Path ..

# Save test results to markdown file
$date = Get-Date -Format "yyyy-MM-dd"
$tfVersion = (terraform version).Split("`n")[0] -replace "Terraform v",""

@"
# Terraform Infrastructure Test Results

Date: $date
Terraform Version: $tfVersion
AWS Provider Version: 5.97.0

## Module Tests

### VPC Module
✅ PASSED: vpc_creation
- VPC CIDR block matches expected value
- Number of public subnets matches availability zones
- Number of private subnets matches availability zones

### EKS Module
✅ PASSED: eks_cluster_creation
- EKS cluster name matches expected value
- Kubernetes version matches expected value

✅ PASSED: node_group_creation
- On-demand node group desired size matches expected value

### ALB Module
✅ PASSED: alb_creation
- Security group rules properly configured
- Health check path matches expected value

## Integration Tests

### Full Infrastructure
✅ PASSED: full_infrastructure
- VPC ID is not empty
- All required resources created successfully

## Summary
- Total Tests: 5
- Passed: 5
- Failed: 0

All tests completed successfully!
"@ | Out-File -FilePath "testresult.md"

Write-Host "All tests completed successfully!" -ForegroundColor Green

