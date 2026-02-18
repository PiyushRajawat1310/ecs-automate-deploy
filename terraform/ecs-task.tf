resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = var.image_uri
      essential = true
      portMappings = [{
        containerPort = 1337
        hostPort      = 1337
      }]
    }
  ])
}

