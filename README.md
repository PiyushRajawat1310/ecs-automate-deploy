Strapi Deployment on AWS ECS (EC2) using Terraform, GitHub Actions & CloudWatch

This repository demonstrates a production-grade CI/CD pipeline to deploy a Strapi application on Amazon Web Services ECS (EC2 launch type) using Terraform and GitHub Actions, with centralized logging and monitoring via CloudWatch.

All steps — infrastructure provisioning, Docker image build, tagging, push to ECR, ECS task revision update, deployment, and monitoring — are handled only through GitHub Actions.

🧠 Architecture Overview
Git Push (main)
   ↓
GitHub Actions (CI/CD)
   ↓
Docker Build & Tag (Git SHA)
   ↓
Amazon ECR
   ↓
Terraform Apply
   ↓
Amazon ECS (EC2)
   ↓
CloudWatch Logs & Metrics

🧱 Tech Stack

Amazon ECS (EC2 launch type)

Amazon ECR

Amazon CloudWatch

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
│   ├── iam.tf
│   ├── cloudwatch.tf
│   ├── variables.tf
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
└── README.md

🔐 Prerequisites
1. AWS Account

IAM user with programmatic access and the following permissions:

AmazonECS_FullAccess

AmazonEC2FullAccess

AmazonEC2ContainerRegistryFullAccess

IAMFullAccess

2. Local Tools
aws --version
docker --version
terraform --version
git --version

🔑 Required GitHub Secrets

Configure secrets in:

GitHub Repository → Settings → Secrets and variables → Actions

Secret Name	Description
AWS_ACCESS_KEY_ID	IAM access key
AWS_SECRET_ACCESS_KEY	IAM secret key
AWS_REGION	AWS region (e.g. ap-south-1)
AWS_ACCOUNT_ID	12-digit AWS account ID

⚠️ All secrets are mandatory. Missing any will break the pipeline.

🪣 Terraform Backend (One-Time Setup)

Terraform state is stored remotely in S3.

Create the backend bucket once:

aws s3 mb s3://strapi-ecs-tfstate --region ap-south-1

🚀 CI/CD Deployment Flow
Trigger Deployment
git add .
git commit -m "Deploy Strapi with CloudWatch monitoring"
git push origin main

GitHub Actions Automatically:

Builds Docker image

Tags image with Git SHA

Pushes image to Amazon ECR

Initializes Terraform

Applies infrastructure changes

Registers new ECS task revision

Deploys updated ECS service

Enables CloudWatch logging

📜 CloudWatch Logging (Enabled)
Log Group
/ecs/strapi

Log Stream Prefix
ecs/strapi


Each ECS task/container creates its own log stream under this group.

View Logs (CLI)
aws logs describe-log-groups --log-group-name-prefix /ecs/strapi

aws logs describe-log-streams \
  --log-group-name /ecs/strapi

aws logs get-log-events \
  --log-group-name /ecs/strapi \
  --log-stream-name <STREAM_NAME>

Expected Logs
Strapi started successfully
Server running on http://0.0.0.0:1337

📊 CloudWatch Metrics (Enabled Automatically)

ECS automatically publishes metrics to CloudWatch.

Available Metrics

CPUUtilization

MemoryUtilization

RunningTaskCount

NetworkRxBytes (Network In)

NetworkTxBytes (Network Out)

Console Path
CloudWatch → Metrics → ECS → ClusterName, ServiceName


⚠️ No additional Terraform or agents are required for metrics.

✅ How to Verify Application Is Running
Check ECS Tasks
aws ecs list-tasks --cluster strapi-cluster

Check Task Status
aws ecs describe-tasks \
  --cluster strapi-cluster \
  --tasks <TASK_ARN>


Expected:

lastStatus: RUNNING

🌐 Public Access (Intentional Design)

By default, the application is NOT publicly accessible.

Missing intentionally:

Application Load Balancer

HTTPS

Public Security Group ingress

This follows secure-by-default cloud architecture.

🔜 Optional Enhancements

Application Load Balancer (ALB)

HTTPS (ACM + Route53)

CloudWatch Alarms (CPU / Memory)

ECS Auto Scaling

CloudWatch Dashboards

Secrets via AWS SSM / Secrets Manager

🧑‍💻 DevOps Notes

This project follows real-world DevOps best practices:

No SSH access

No manual AWS Console changes

Immutable Docker images

Git-driven infrastructure changes

Centralized logging & monitoring.

🟢 Current Status

✔ CI/CD automated
✔ ECS service running
✔ CloudWatch logs enabled
✔ ECS metrics available.
