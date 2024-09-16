variable "company_name" {
  type        = string
  description = "used in resource naming"
}
variable "app_name" {
  type = string
}
variable "environment" {
  type        = string
  description = "used in resource naming and namespacing"
}
variable "region" {
  type        = string
  description = "aws region to deploy into"
}
variable "tags" {
  type = object({
    Environment       = string
    Company           = string
    Deployment_Method = string
  })
}
variable "kms_grantees" {
  type = list(string)
}
variable "app_vpc_cidr" {
  type        = string
  description = "desired value for the VPC CIDR if create_vpc is true. If create_vpc is false, then the CIDR of the VPC being used in vpc_id."
}
variable "snapshot_identifier" {
  type    = string
  default = ""
}
variable "initial_database" {
  type = string
}
variable "master_db_username" {
  type = string
}
variable "master_db_password" {
  type = string
}
variable "ecs_domain_names" {
  type        = list(string)
  description = "Domain names, which when combined with var.web_subdomains and var.api_subdomains, create the domains that your ECS services will listen on. If var.deploy_route53_resources is set to true, subdomains will also be created in the Route 53 hosted zones for these domain names."
}
variable "extra_domain_names" {
  type        = list(string)
  default     = []
  description = "If var.deploy_route53_resources is set to true, subdomains will be created in the Route 53 hosted zones for these optional extra domain names. This is only offered to create extra Route 53 entries and can be left empty at any time."
}
variable "grafana_auth" {
  type    = string
  default = ""
}
variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}
variable "grafana_email_recipients" {
  type    = string
  default = ""
}
variable "desired_task_count_api" {
  type    = number
  default = 3
}
variable "desired_task_count_web" {
  type    = number
  default = 2
}
variable "minimum_host_count" {
  type    = number
  default = 1
}
variable "maximum_host_count" {
  type    = number
  default = 10
}
variable "deploy_grafana_resources" {
  type    = bool
  default = "false"
}
variable "bastion_ami" {
  type    = string
  default = ""
}
variable "ecs_host_ami" {
  type    = string
  default = ""
}
variable "certificate_arn" {
  type = string
}
variable "ecs_alarms_email_recipients" {
  type    = list(string)
  default = []
}
variable "server_iam_role_policy_statements" {
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
  default = []
  // Alternate default is commented out, it's just here as a reference for how to use this
  //  default = [
  //    {
  //    effect: "Allow",
  //    actions = ["ses:SendRawEmail"]
  //    resources: ["*"]
  //    }
  //  ]
}
variable "skip_final_snapshot" {
  type    = bool
  default = false
}
variable "database_security_group_additional_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
  }))
  default = []
}
variable "services_to_grant_kms_access_to" {
  type    = list(string)
  default = []
}
variable "iam_arns_to_grant_sns_kms_access_to" {
  type    = list(string)
  default = []
}
variable "api_task_memory" {
  type    = number
  default = 31000
}
variable "api_task_vcpu" {
  type    = number
  default = 7800
}
variable "deploy_route53_resources" {
  type    = bool
  default = true
}
variable "elb_idle_timeout" {
  type    = number
  default = 60
}
variable "host_instance_type" {
  type    = string
  default = "t3.xlarge"
}
variable "bastion_instance_type" {
  type    = string
  default = "t3.small"
}
variable "database_instance_type" {
  type    = string
  default = "db.t3.xlarge"
}
variable "api_subdomains" {
  type = list(string)
}
variable "web_subdomains" {
  type = list(string)
}
variable "redis_node_type" {
  type    = string
  default = "cache.m4.xlarge"
}
variable "use_variable_scripts" {
  type        = bool
  default     = false
  description = "if true, null_resource resources will be used to run scripts that generate var files for kubernetes/aws/shieldrule"
}
variable "api_unhealthy_threshold" {
  type    = number
  default = 2
}
variable "api_health_check_interval" {
  type    = number
  default = 60
}
variable "api_health_check_timeout" {
  type    = number
  default = 10
}
variable "api_healthy_threshold" {
  type    = number
  default = 2
}
variable "domains_to_redirect" {
  type = list(object({
    from = string
    to   = string
  }))
  default = []
}
variable "deploy_eks" {
  type        = bool
  default     = false
  description = "if true, a new EKS cluster and surrounding resources are created"
}
variable "deploy_ecs" {
  type        = bool
  default     = true
  description = "if true, a new ECS cluster and surrounding resources are created"
}
variable "upload_env_file" {
  type        = bool
  default     = false
  description = "if true, an env file is uploaded automatically to S3 for use with ECS API containers"
}
variable "web_eks_port" {
  type        = number
  default     = 31255
  description = "optional. used in helm to expose the web service through security group rules. Only required here if use_variable_scripts is true"
}
variable "docs_eks_port" {
  type        = number
  default     = 31256
  description = "optional. used in helm to expose the docs service through security group rules. Only required here if use_variable_scripts is true"
}
variable "api_eks_port" {
  type        = number
  default     = 31257
  description = "optional. used in helm to expose the API service through security group rules. Only required here if use_variable_scripts is true"
}
variable "deploy_read_replica" {
  type = bool
  default = false
  description = "Whether to add a read replica"
}
variable "use_only_private_subnets" {
  type    = bool
  default = false
  description = "If true, will use only private subnets to provision all network-dependant resources"
}
variable "reader_instance_type" {
  type    = string
  default = "db.t3.xlarge"
}