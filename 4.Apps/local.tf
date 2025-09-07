locals {
  resource_name     = "${var.project}-${var.environment}"
  ami               = data.aws_ami.join_devops.id
  public_subnet_id  = split(",", data.aws_ssm_parameter.public_subnet_id.value)[0]
  private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_id.value)[0]
  frontend_sg       = data.aws_ssm_parameter.frontend_sg.value
  backend_sg        = data.aws_ssm_parameter.backend_sg.value
  mysql_sg          = data.aws_ssm_parameter.mysql_sg.value
  ansible_sg        = data.aws_ssm_parameter.ansible_sg.value

}