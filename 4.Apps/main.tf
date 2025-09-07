module "mysql" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami                    = local.ami
  instance_type          = "t2.micro"
  subnet_id              = local.private_subnet_id
  vpc_security_group_ids = [local.mysql_sg]
  name                   = "${local.resource_name}-mysql"

  tags = { #here tags is not an argument , its a variable 
    Terraform   = "true"
    Environment = "dev"
  }
}

module "backend" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami                    = local.ami
  instance_type          = "t2.micro"
  subnet_id              = local.private_subnet_id
  vpc_security_group_ids = [local.backend_sg]
  name                   = "${local.resource_name}-backend"

  tags = { #here tags is not an argument , its a variable 
    Terraform   = "true"
    Environment = "dev"
  }
}


module "frontend" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami                    = local.ami
  instance_type          = "t2.micro"
  subnet_id              = local.public_subnet_id
  vpc_security_group_ids = [local.frontend_sg]
  name                   = "${local.resource_name}-frontend"

  tags = { #here tags is not an argument , its a variable 
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ansible" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami                    = local.ami
  instance_type          = "t2.micro"
  subnet_id              = local.public_subnet_id
  vpc_security_group_ids = [local.ansible_sg]
  name                   = "${local.resource_name}-ansible"

  user_data = file("expense.sh")

  tags = { #here tags is not an argument , its a variable 
    Terraform   = "true"
    Environment = "dev"
  }
}

# route53 module

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "" # since we mentioned zone-name , frontend will be automatically assigned to rohanandlife.site
      type    = "A"
      ttl     = 1
      records = [module.frontend.public_ip]
    },
 {
      name    = "frontend" 
      type    = "A"
      ttl     = 1
      records = [module.frontend.public_ip]
    },


    {
      name    = "backend" #it will come as backend.rohanandlife.site
      type    = "A"
      ttl     = 1
      records = [module.backend.private_ip]
    },

    {
      name    = "database" #it will come as database.rohanandlife.site
      type    = "A"
      ttl     = 1
      records = [module.mysql.private_ip]
    },


  ]
}





    