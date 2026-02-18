terraform {
  backend "s3" {
    bucket = "strapi-ecs-tfstate"
    key    = "ecs/terraform.tfstate"
    region = "ap-south-1"
  }
}

