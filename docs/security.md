# Security Notes

## Implemented controls

- Private ECS tasks and private RDS subnets with no direct public ingress.
- ALB is the only internet-facing entry point.
- TLS enforced with ACM and HTTP to HTTPS redirect.
- Customer-managed KMS key encrypts RDS, ECS logs, Secrets Manager secrets, and secure SSM parameters.
- Database security group only allows PostgreSQL from the ECS service security group.
- ECS execution role only gets the managed execution policy plus scoped access to referenced secret and parameter ARNs.
- RDS parameter group enforces `rds.force_ssl = 1`.
- Route 53 alias records avoid hardcoded endpoints and support controlled DNS cutovers.

## Recommended hardening next

- Add AWS WAF in front of the ALB for rate limiting and managed rules.
- Replace email SNS subscriptions with ChatOps or incident tooling integrations.
- Use GitHub OIDC with environment-specific roles and IAM condition keys.
- Add AWS Config, Security Hub, GuardDuty, and Detective for continuous security visibility.
- Add secret rotation Lambda workflows for app credentials or external integrations.
