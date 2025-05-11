provider "aws" {
  region = "us-east-1"
  # Mock credentials
  access_key = "test"
  secret_key = "test"
  
  # Skip AWS API calls
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}