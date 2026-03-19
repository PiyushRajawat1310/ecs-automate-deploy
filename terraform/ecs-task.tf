resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = var.image_uri
      essential = true

      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]

      environment = [
        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" },

        # 🔐 APP_KEYS (first 4 keys, comma-separated)
        { name = "APP_KEYS", value = "1WkQyYeN0VQHk/ISVSTAB8eS2J2N8NJU5v1KedpAhds=,6OJJ9QvwFXhFk77nqlN6mCFLJ6s33xCZUG7sGk5oJAs=,dasahCUFTPP3yfr5ZgpoL7ZNn+6TbNhjWKaFoTxzgGQ=,BGCDfjSB/ttNRdKaN5PomlkfFuE7zXfvLt9RQa3Ba+s=" },

        # 🔐 Remaining secrets
        { name = "API_TOKEN_SALT", value = "Dob25C5G2bMVWN8fgVasDFCNbwfXfT+9esj6ZyF40Es=" },
        { name = "ADMIN_JWT_SECRET", value = "/gkBZxZ5Prg6Os4D5vKcUDC0nPXBKUtywW8tTBBaMhw=" },
        { name = "TRANSFER_TOKEN_SALT", value = "frpt4ZJ/yzv1moBqmynkm45xX65QHE3D/HeSXKJdnts=" },
        { name = "JWT_SECRET", value = "Lc8rc+l54sCqv+YtQkA2fPDd25HFiBwjkq2YD5WUh4o=" },
        { name = "ENCRYPTION_KEY", value = "wKKEDBiqRQ7goy9MmZBAlVveIU316Tu991Ph9ALyVH0=" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/strapi"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs/strapi"
        }
      }
    }
  ])
}
