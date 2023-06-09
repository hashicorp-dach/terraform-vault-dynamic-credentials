terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.12.0"
    }
  }
}

provider "vault" {}

data "vault_kv_secret_v2" "creds" {
  mount = "example"
  name = "awsSecrets"
  #This is an example of static K/V Secret retrieval
}

data "vault_aws_access_credentials" "awsdynamiccreds" {
  backend = "aws"
  role = "aws-role" 
  #This is an example of dynamic AWS credential retrieval
}

provider "aws" {
  region     = "eu-central-1"
  #Below is an example of using K/V Secrets to configure this AWS Provider
  #access_key = data.vault_kv_secret_v2.creds.data["AWS_ACCESS_KEY"]
  #secret_key = data.vault_kv_secret_v2.creds.data["AWS_SECRET_ACCESS_KEY"]
  #Below is the same configuration to configure the AWS Provider using the dynamically created credentials
  access_key = data.vault_aws_access_credentials.awsdynamiccreds.access_key
  secret_key = data.vault_aws_access_credentials.awsdynamiccreds.secret_key
}

resource "aws_instance" "instance" {
  instance_type = "t3.micro"
  
}



