locals {
  name_prefix = "${var.project_name}-${var.environment}"

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
    Repository  = "terraform-aws-api-collaboration-platform"
    Workload    = "api-collaboration-platform"
  }
}

resource "aws_sns_topic" "alerts" {
  name              = "${local.name_prefix}-alerts"
  kms_master_key_id = "alias/aws/sns"

  tags = local.tags
}

resource "aws_sns_topic_subscription" "email" {
  count     = length(var.alarm_email_endpoints)
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alarm_email_endpoints[count.index]
}

resource "random_password" "app_signing_secret" {
  length  = 40
  special = false
}

resource "aws_ssm_parameter" "app_environment" {
  name        = "/${local.name_prefix}/app/environment"
  description = "Runtime environment name for the API collaboration application"
  type        = "String"
  value       = var.environment
  tier        = "Standard"

  tags = local.tags
}

resource "aws_ssm_parameter" "app_signing_secret" {
  name        = "/${local.name_prefix}/app/signing-secret"
  description = "Application signing secret injected into ECS at runtime"
  type        = "SecureString"
  value       = random_password.app_signing_secret.result
  key_id      = module.kms.key_id
  tier        = "Standard"

  tags = local.tags
}

resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "Ingress for ECS tasks from the ALB only"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [module.alb.alb_security_group_id]
    description     = "Application traffic from the ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

module "network" {
  source = "../../modules/network"

  name                     = local.name_prefix
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  single_nat_gateway       = var.single_nat_gateway
  tags                     = local.tags
}

module "kms" {
  source = "../../modules/kms"

  name        = local.name_prefix
  description = "Customer managed KMS key for ${local.name_prefix}"
  tags        = local.tags
}

module "acm" {
  source = "../../modules/acm"

  domain_name               = var.domain_name
  hosted_zone_id            = var.hosted_zone_id
  subject_alternative_names = []
  tags                      = local.tags
}

module "alb" {
  source = "../../modules/alb"

  name              = local.name_prefix
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.public_subnet_ids
  certificate_arn   = module.acm.certificate_arn
  health_check_path = var.health_check_path
  tags              = local.tags
}

module "ecs_service" {
  source = "../../modules/ecs_service"

  name                      = local.name_prefix
  subnet_ids                = module.network.private_app_subnet_ids
  service_security_group_id = aws_security_group.app.id
  target_group_arn          = module.alb.target_group_arn
  container_image           = var.container_image
  cpu                       = var.app_cpu
  memory                    = var.app_memory
  desired_count             = var.desired_count
  min_capacity              = var.min_capacity
  max_capacity              = var.max_capacity
  kms_key_arn               = module.kms.key_arn
  log_retention_in_days     = var.log_retention_in_days

  environment_variables = {
    APP_NAME    = "api-collaboration-platform"
    AWS_REGION  = var.aws_region
    LOG_LEVEL   = "info"
    PORT        = "8080"
    HEALTH_PATH = var.health_check_path
  }

  secret_arns = {
    DATABASE_SECRET_JSON = module.rds.secret_arn
    APP_SIGNING_SECRET   = aws_ssm_parameter.app_signing_secret.arn
  }

  tags = local.tags
}

module "rds" {
  source = "../../modules/rds_postgres"

  name                         = local.name_prefix
  vpc_id                       = module.network.vpc_id
  subnet_ids                   = module.network.private_db_subnet_ids
  app_security_group_id        = aws_security_group.app.id
  db_name                      = var.db_name
  username                     = var.db_username
  instance_class               = var.db_instance_class
  allocated_storage            = var.db_allocated_storage
  max_allocated_storage        = var.db_max_allocated_storage
  kms_key_arn                  = module.kms.key_arn
  performance_insights_enabled = true
  multi_az                     = true
  backup_retention_period      = 7
  deletion_protection          = false
  skip_final_snapshot          = true
  tags                         = local.tags
}

module "dns" {
  source = "../../modules/route53_records"

  hosted_zone_id = var.hosted_zone_id
  record_name    = var.domain_name
  alb_dns_name   = module.alb.alb_dns_name
  alb_zone_id    = module.alb.alb_zone_id
}

module "monitoring" {
  source = "../../modules/monitoring"

  name                    = local.name_prefix
  alb_arn_suffix          = module.alb.alb_arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix
  ecs_cluster_name        = module.ecs_service.cluster_name
  ecs_service_name        = module.ecs_service.service_name
  db_instance_identifier  = module.rds.db_instance_identifier
  alarm_actions           = [aws_sns_topic.alerts.arn]
  tags                    = local.tags
}
