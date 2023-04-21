terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


# creating vpc

resource "aws_vpc" "my_vpc_ca3" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-new-vpc"
  }
}

# creating subnet 

resource "aws_subnet" "my_subnet_ca3" {
  vpc_id     = aws_vpc.my_vpc_ca3.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "my-new-subnet"
  }
}


# creating route_table

resource "aws_route_table" "my_route_table_ca3" {
  vpc_id = aws_vpc.my_vpc_ca3.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-0260bf2043fb8bd79"
  }
  tags = {
    Name = "my-new-route-table"
  }
}



# creating ec2 instance

resource "aws_instance" "my_instance_ca3" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet_ca3.id
  tags = {
    Name = "my-new-instance"
  }
}


# default subnet for alb

data "aws_subnets" "default" {
  filter {
    name = "default-for-az"
    values = ["true"]
  }
  
}

# creating load_balancer

# resource "aws_alb" "sample" {
#   name            = "navin-alb"
#   internal        = false
#   security_groups = ["sg-017cf8164440e38a9"]
#   subnets         = data.aws_subnets.default.ids

#   idle_timeout               = 60
#   enable_deletion_protection = false

#   tags = {
#     Name = "navin-alb"
#   }
# }




# resource "aws_alb_target_group" "sample" {
#   name     = "sample-target-group"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.my_vpc_ca3.id

#   health_check {
#     path                = "/health"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
# }



# resource "aws_alb_listener" "sample" {
#   load_balancer_arn = aws_alb.sample.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "forward"

#     target_group_arn = aws_alb_target_group.sample.arn
#   }
# }

