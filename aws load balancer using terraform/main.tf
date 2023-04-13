terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "default-for-az"
    values = ["true"]
  }
  
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_alb" "sample" {
  name            = "navin-alb"
  internal        = false
  security_groups = ["sg-017cf8164440e38a9"]
  subnets         = data.aws_subnets.default.ids

  idle_timeout               = 60
  enable_deletion_protection = false

  tags = {
    Name = "navin-alb"
  }
}


resource "aws_alb_listener" "sample" {
  load_balancer_arn = aws_alb.sample.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_alb_target_group.sample.arn
  }
}

resource "aws_alb_target_group" "sample" {
  name     = "sample-target-group"
  port     = 80
  protocol = "HTTP"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}