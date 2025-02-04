locals {
    resource_name = "${var.project}-${var.environment}-bastion"
    ami = data.aws_ami.join_devops.id
    public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_id.value)[0] #since we want only list , which we made to stringlist by join fucntion
    frontend_sg = data.aws_ssm_parameter.frontend_sg.value
    bastion_sg = data.aws_ssm_parameter.bastion_sg.value
}