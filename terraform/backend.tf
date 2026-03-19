terraform {
  backend "s3" {
    bucket = "strapi-ecs-tfstate-1"
    key    = "ecs/terraform.tfstate-1"
    region = "ap-south-1"
  }
}

