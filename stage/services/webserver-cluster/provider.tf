terraform {
  backend "remote" {
    organization = "hendy"

    workspaces {
      name = "Web-cluster"
    }
  }
}

provider "aws" {
region = "us-east-2"
}