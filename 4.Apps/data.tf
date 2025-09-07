
data "aws_ami" "join_devops" {
  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"] #this is case sensitive , so use it properly as is
  }
}

data "aws_ssm_parameter" "public_subnet_id" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "frontend_sg" {
  name = "/${var.project}/${var.environment}/frontend_sg_id"
}

data "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "backend_sg" {
  name = "/${var.project}/${var.environment}/backend_sg_id"
}



data "aws_ssm_parameter" "mysql_sg" {
  name = "/${var.project}/${var.environment}/mysql_sg_id"
}

data "aws_ssm_parameter" "ansible_sg" {
  name = "/${var.project}/${var.environment}/ansible_sg_id"
}
