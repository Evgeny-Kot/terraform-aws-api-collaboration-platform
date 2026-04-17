# Operations Guide

## Deployment workflow

1. Bootstrap remote state with the example in `examples/backend/`.
2. Copy `terraform.tfvars.example` in the target environment to a real `.tfvars` file.
3. Populate Route 53 zone IDs, image references, and alert endpoints.
4. Run `terraform init -backend-config=backend.hcl` in the chosen environment.
5. Run `terraform plan` and `terraform apply`.

## Observability

- ECS application logs stream into a KMS-encrypted CloudWatch log group.
- ECS Container Insights is enabled at the cluster level.
- Alarms cover ALB 5XXs, ALB latency, ECS CPU saturation, RDS CPU saturation, and low free storage.
- SNS acts as the notification fan-out layer for on-call or team alerts.

## Scaling considerations

- ECS target tracking policies scale on CPU and memory utilization.
- RDS storage autoscaling increases capacity without immediate manual intervention.
- Production defaults use three AZs to improve failure tolerance and spread.

## Cost considerations

- NAT gateways are one of the largest fixed network costs; `dev` can collapse to a single NAT gateway.
- Fargate sizing should be tuned from real application telemetry, not just defaults.
- RDS instance class and storage retention should be right-sized after load testing.
- CloudWatch retention is environment-specific to balance forensic value and spend.
