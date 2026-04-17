![Terraform](https://img.shields.io/badge/Terraform-1.6+-623CE4)
![AWS](https://img.shields.io/badge/AWS-ECS%20%7C%20RDS%20%7C%20ALB-orange)
![IaC](https://img.shields.io/badge/IaC-Terraform-blue)
![Status](https://img.shields.io/badge/status-portfolio--ready-success)

# terraform-aws-api-collaboration-platform

Production-grade Terraform repository for deploying a highly available API collaboration and testing platform on AWS. The project models a Postman-style application stack with ECS Fargate, ALB + ACM, Route 53, private Multi-AZ PostgreSQL on RDS, KMS-backed encryption, centralized secrets management, and environment-specific infrastructure for `dev`, `stage`, and `prod`.

## Project description

This repository showcases how to design and provision a realistic cloud platform for an internal API product used by engineering teams to test endpoints, manage collections, and collaborate on integrations. The infrastructure emphasizes the qualities expected in a real production environment:

- modular Terraform architecture that is easy to review and extend
- high availability across multiple Availability Zones
- private compute and database tiers with least-privilege access
- secure secret handling through Secrets Manager and SSM Parameter Store
- encrypted logging, storage, and database layers using KMS
- built-in observability with CloudWatch logs, metrics, and alarms
- CI guardrails with formatting, validation, linting, security scanning, and plan workflows

## GitHub About / short describe

Use this as the repository description:

`Production-grade Terraform AWS platform for a highly available Postman-style API collaboration app with ECS Fargate, ALB, RDS PostgreSQL, KMS, Route 53, and CI security checks.`

## What this project demonstrates

- production-style AWS infrastructure design for a modern SaaS-style API platform
- reusable Terraform modules with thin environment composition layers
- security-first networking with private application and database subnets
- operational readiness through monitoring, alerting, and remote state patterns
- portfolio-quality documentation suitable for a Senior DevOps / Platform Engineer showcase

## Architecture explanation

The repository is structured around a thin environment layer and reusable Terraform modules.

- `modules/network` creates a multi-AZ VPC with public ALB/NAT subnets, private ECS subnets, and isolated DB subnets.
- `modules/acm`, `modules/alb`, and `modules/route53_records` handle edge delivery: DNS, ACM certificate validation, TLS termination, and ALB listener routing.
- `modules/ecs_service` runs the application on ECS Fargate with CloudWatch log encryption, autoscaling, and least-privilege task execution.
- `modules/rds_postgres` provisions an encrypted Multi-AZ PostgreSQL instance, parameter group, monitoring role, and database secret in Secrets Manager.
- `modules/kms` centralizes encryption material for logs, parameters, secrets, and RDS storage.
- `modules/monitoring` defines core CloudWatch alarms for ALB, ECS, and RDS health.

The runtime pattern is:

1. Route 53 resolves the application DNS record to the ALB.
2. ACM supplies the TLS certificate for the HTTPS listener.
3. The ALB terminates TLS and forwards traffic to ECS Fargate tasks in private subnets.
4. ECS tasks read runtime secrets from Secrets Manager and secure parameters from SSM.
5. The application connects to Multi-AZ RDS PostgreSQL in private DB subnets.
6. CloudWatch and SNS provide operational visibility and alerting.

See [docs/architecture.md](docs/architecture.md) for the Mermaid diagram and deeper rationale.

## Core capabilities

- Multi-AZ VPC with public, private application, and private database subnet tiers
- ECS Fargate service behind an Application Load Balancer with enforced HTTPS
- ACM certificate validation and Route 53 DNS integration
- RDS PostgreSQL with Multi-AZ deployment, encryption, backups, and monitoring
- Secrets Manager and SSM Parameter Store for runtime configuration and secrets
- CloudWatch log groups, alarms, ECS Container Insights, and SNS notifications
- GitHub Actions workflows for Terraform quality gates and plan generation

## Repository tree

```text
.
├── .github/
│   └── workflows/
│       ├── terraform-ci.yml
│       └── terraform-plan.yml
├── docs/
│   ├── architecture.md
│   ├── operations.md
│   └── security.md
├── environments/
│   ├── dev/
│   ├── prod/
│   └── stage/
├── examples/
│   └── backend/
├── modules/
│   ├── acm/
│   ├── alb/
│   ├── ecs_service/
│   ├── kms/
│   ├── monitoring/
│   ├── network/
│   ├── rds_postgres/
│   └── route53_records/
├── .checkov.yml
├── .editorconfig
├── .tfsec.yml
├── .tflint.hcl
└── README.md
```

## Terraform code

Each environment is self-contained and deployable, with its own backend config example and `terraform.tfvars.example`.

- `environments/dev`: lower-cost version of the platform with a single NAT gateway and shorter retention.
- `environments/stage`: production-like topology for integration validation and pre-release testing.
- `environments/prod`: full production posture with three AZ support, larger scaling bounds, deletion protection, and longer retention.

Each stack follows the same deployment model:

1. create the network foundation
2. provision encryption and secret management
3. attach the HTTPS edge with DNS
4. deploy the ECS application service
5. create the private PostgreSQL data tier
6. enable alarms and operational visibility

### Example init and plan

```bash
cd environments/dev
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars
terraform init -backend-config=backend.hcl
terraform plan
```

## CI/CD

GitHub Actions workflows included in `.github/workflows/` provide:

- `terraform-ci.yml`: `fmt`, `init`, `validate`, `tflint`, `tfsec`, and `checkov`.
- `terraform-plan.yml`: matrix plan job for `dev`, `stage`, and `prod` using GitHub OIDC when `AWS_ROLE_ARN` is configured.

Recommended GitHub setup:

- Create an AWS IAM role trusted by GitHub OIDC.
- Store the role ARN as `AWS_ROLE_ARN`.
- Use branch protection so pull requests must pass `terraform-ci`.

## Remote state backend example

The `examples/backend/` directory contains an S3 bucket and DynamoDB lock table example for remote Terraform state. Each environment also ships with a `backend.hcl.example` showing the expected backend shape.

## Security, observability, scalability, and cost notes

### Security

- Customer-managed KMS key for encryption at rest.
- Secrets in Secrets Manager and secure parameters in SSM.
- Private ECS and RDS tiers with tightly scoped security groups.
- IAM roles scoped to task execution and monitoring use cases.

### Observability

- KMS-encrypted CloudWatch log groups.
- ECS Container Insights.
- CloudWatch alarms for ALB errors/latency, ECS CPU, and RDS pressure.
- SNS notification integration for team alerts.

### Scalability

- ECS Fargate target-tracking autoscaling.
- Multi-AZ application and database placement.
- ALB-based horizontal request distribution.
- RDS storage autoscaling and Performance Insights.

### Cost

- `dev` can use one NAT gateway to reduce fixed network cost.
- Environment-specific CloudWatch retention periods limit unnecessary log spend.
- Fargate and RDS sizing are right-sized differently across environments.
- The stack uses managed services to reduce operational toil, but production teams should still tune spend after real traffic profiling.

## Documentation

- [docs/architecture.md](docs/architecture.md)
- [docs/security.md](docs/security.md)
- [docs/operations.md](docs/operations.md)

## Portfolio framing

This repository is designed to present the kind of Terraform structure a Senior DevOps or Platform Engineer would own in practice:

- clear module boundaries
- environment-specific composition
- production-aware defaults
- security and observability baked into the stack
- CI gates for formatting, validation, and security scanning

It is intentionally realistic rather than minimal, while still being approachable enough to review in a portfolio context.
