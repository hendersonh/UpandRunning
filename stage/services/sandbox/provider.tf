terraform {
  backend "remote" {
    organization = "hendy"

    workspaces {
      name = "sandbox"
    }
  }
}

provider "aws" {
region = "us-east-2"
}