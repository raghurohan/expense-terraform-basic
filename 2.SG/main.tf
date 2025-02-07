# security groups required for the project

module "mysql_sg" {
    source = "git::https://github.com/raghuatharva/terraform-aws-security-group.git?ref=main"
    vpc_id = local.vpc_id
    sg_name = "mysql"
    project_name = var.project
    environment = var.environment
 
}

module "backend_sg" {
    source = "git::https://github.com/raghuatharva/terraform-aws-security-group.git?ref=main"
    vpc_id = local.vpc_id
    sg_name = "backend"
    project_name = var.project
    environment = var.environment
    
}

module "frontend_sg" {
    source = "git::https://github.com/raghuatharva/terraform-aws-security-group.git?ref=main"
    vpc_id = local.vpc_id
    sg_name = "frontend"
    project_name = var.project
    environment = var.environment
   
}

module "bastion_sg" {
    source = "git::https://github.com/raghuatharva/terraform-aws-security-group.git?ref=main"
    vpc_id = local.vpc_id
    sg_name = "bastion"
    project_name = var.project
    environment = var.environment
   
}

module "ansible_sg" {
    source = "git::https://github.com/raghuatharva/terraform-aws-security-group.git?ref=main"
    vpc_id = local.vpc_id
    sg_name = "ansible"
    project_name = var.project
    environment = var.environment
   
}
# RDS SECURITY GROUP
module "rds_sg" {
    source = "git::https://github.com/raghuatharva/terraform-aws-security-group.git?ref=main"
    vpc_id = local.vpc_id
    sg_name = "rds"
    project_name = var.project
    environment = var.environment
}

#ingress rules for security groups
resource "aws_security_group_rule" "mysql_ingress" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_group_id = module.mysql_sg.id
    source_security_group_id = module.backend_sg.id
}

resource "aws_security_group_rule" "backend_ingress" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_group_id = module.backend_sg.id
    source_security_group_id = module.frontend_sg.id
}

resource "aws_security_group_rule" "frontend_ingress" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.frontend_sg.id
    cidr_blocks = ["0.0.0.0/0"]
}

#bastion security group rules
resource "aws_security_group_rule" "bastion_db" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.mysql_sg.id
    source_security_group_id = module.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_backend" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.backend_sg.id
    source_security_group_id = module.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_frontend" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.frontend_sg.id
    source_security_group_id = module.bastion_sg.id
}
#you also want to login to bastion from my ip or any ip , so 
resource "aws_security_group_rule" "bastion_ingress" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.bastion_sg.id
    cidr_blocks = ["0.0.0.0/0"]
}

#ansible security group rules . You are  allowing to app servers from ansible server
resource "aws_security_group_rule" "ansible_db" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.mysql_sg.id
    source_security_group_id = module.ansible_sg.id
}

resource "aws_security_group_rule" "ansible_backend" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.backend_sg.id
    source_security_group_id = module.ansible_sg.id
}

resource "aws_security_group_rule" "ansible_frontend" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.frontend_sg.id
    source_security_group_id = module.ansible_sg.id
}

#you also want to login to ansible from my ip or any ip , so

resource "aws_security_group_rule" "ansible_public" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.ansible_sg.id
    cidr_blocks = ["0.0.0.0/0"]
}

