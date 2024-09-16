module "rds_instance" {
  source                   = "../src/modules/simple/rds"
  environment              = var.environment
  company_name             = var.company_name
  region                   = var.region
  cluster_name             = "services"
  availability_zone        = module.shared_vpc.az_1
  role_arn                 = module.rds_role.role_arn
  security_group           = module.rds_security_group.security_group_id
  private_subnets          = module.shared_vpc.private_subnet_ids
  public_subnets           = module.shared_vpc.public_subnet_ids
  tags                     = var.tags
  kms_key_arn              = module.rds_key.key_arn
  initial_database         = var.initial_database
  master_password          = var.master_db_password
  master_username          = var.master_db_username
  snapshot_identifier      = var.snapshot_identifier != "" ? var.snapshot_identifier : ""
  skip_final_snapshot      = var.skip_final_snapshot
  instance_type            = var.database_instance_type
  sns_arn                  = aws_sns_topic.alarms.arn
  deploy_read_replica      = var.deploy_read_replica
  use_only_private_subnets = var.use_only_private_subnets
  reader_instance_type     = var.reader_instance_type
}
