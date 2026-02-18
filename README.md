🚀 Strapi Deployment on AWS ECS (EC2) using Terraform & GitHub Actions

This repository demonstrates a fully automated CI/CD pipeline to deploy a Strapi application on Amazon Web Services ECS (EC2 launch type) using Terraform and GitHub Actions.

The entire lifecycle — infrastructure provisioning, Docker image build, tagging, push to ECR, ECS task revision update, and deployment — is handled only via GitHub Actions.
No manual AWS Console steps after initial setup.

🧠 Architecture Overview
GitHub Push (main branch)
   ↓
GitHub Actions
   ↓
Docker Build → Tag (Git SHA)
   ↓
Amazon ECR
   ↓
Terraform Apply
   ↓
Amazon ECS (EC2)
   ↓
Strapi Container Running

🧱 Tech Stack

Amazon ECS (EC2 launch type)

Amazon ECR

Terraform (Infrastructure as Code)

GitHub Actions (CI/CD)

Docker

Strapi (Node.js CMS)

📁 Repository Structure
.
├── app/
│   ├── Dockerfile
│   ├── package.json
│   └── src/
│
├── terraform/
│   ├── provider.tf
│   ├── backend.tf
│   ├── ecr.tf
│   ├── ecs-cluster.tf
│   ├── ecs-task.tf
│   ├── ecs-service.tf
│   ├── variables.tf
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
└── README.md

🔐 Prerequisites
1. AWS Account

IAM user with programmatic access

Permissions:

AmazonECS_FullAccess

AmazonEC2ContainerRegistryFullAccess

AmazonEC2FullAccess

IAMFullAccess

2. Tools (Local)
aws --version
docker --version
terraform --version
git --version

🔑 Required GitHub Secrets

Go to:

GitHub Repo → Settings → Secrets and variables → Actions


Add ALL of the following:

Secret Name	Description
AWS_ACCESS_KEY_ID	IAM access key
AWS_SECRET_ACCESS_KEY	IAM secret key
AWS_REGION	AWS region (e.g. ap-south-1)
AWS_ACCOUNT_ID	12-digit AWS account ID

⚠️ If any secret is missing, the pipeline will fail.

🪣 Terraform Backend (One-Time Setup)

Terraform state is stored in S3.

Create the bucket once:

aws s3 mb s3://strapi-ecs-tfstate --region ap-south-1

🚀 Deployment Flow
1. Push to main branch
git add .
git commit -m "Deploy Strapi to ECS"
git push origin main

2. GitHub Actions Automatically:

Builds Docker image

Tags image using Git SHA

Pushes image to Amazon ECR

Runs terraform init

Runs terraform apply

Creates new ECS task revision

Deploys updated service

✅ How to Verify Application is Running
Check ECS Tasks
aws ecs list-tasks --cluster strapi-cluster

Check Task Status
aws ecs describe-tasks \
  --cluster strapi-cluster \
  --tasks <TASK_ARN>


Expected:

lastStatus: RUNNING

📜 Check Application Logs

Logs are stored in Amazon CloudWatch.

aws logs describe-log-groups


Look for:

/ecs/strapi-task


Then:

aws logs get-log-events \
  --log-group-name /ecs/strapi-task \
  --log-stream-name <STREAM_NAME>


Expected logs:

Strapi started successfully
Server running on http://0.0.0.0:1337

🌐 Public Access (Important)

⚠️ By design, this setup does NOT expose Strapi publicly.

Missing intentionally:

Application Load Balancer

HTTPS

Public Security Group ingress

This follows secure-by-default cloud architecture.

🔜 Next Enhancements (Optional)

Application Load Balancer (ALB)

HTTPS using ACM + Route53

Secrets via AWS SSM / Secrets Manager

Auto Scaling (CPU / Memory)

Blue-Green deployments

🧑‍💻 Author Notes

This project is designed following real-world DevOps best practices:

No SSH

No click-ops

Immutable Docker images

Infrastructure as Code

Git-driven deployments

🟢 Status
✔ CI/CD automated
✔ ECS running
✔ Strapi container healthy

✔ CI/CD automated
✔ ECS running
✔ Strapi container healthy
