provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-epam"
    key    = "main5.tfstate"
    region = "eu-central-1"
  }
}

terraform {
  required_version = ">= v0.14.4"
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "alb-test"

  load_balancer_type = "application"

  vpc_id             = var.vpc_id
  subnets            = [var.subnets.suba, var.subnets.subb, var.subnets.subc]
  security_groups    = [module.lb_sg.security_group_id]


  target_groups = [
    {
      name             = var.target_name
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = var.target_type
      targets = [
        {
          target_id = aws_instance.task5.id
          port = 8080
        }
      ]
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.certificate_arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
}
data "aws_instance" "task3" {
    instance_id = var.data_instance
}

resource "aws_instance" "task5" {
    ami                                  = data.aws_instance.task3.ami
    availability_zone                    = var.availability_zone
    instance_type                        = var.instance_type
    
    key_name                             = var.key_name
    vpc_security_group_ids               = [
        module.ec2_sg.security_group_id,
    ]

}

module "lb_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = var.sgname
  vpc_id      = var.vpc_id

  ingress_rules       = ["https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["http-80-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = var.sgname
  vpc_id      = var.vpc_id


  ingress_rules       = ["http-8080-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

