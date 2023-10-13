variable "prefix" {}
variable "region" {}
variable "iam_role" {}

variable "subnet_ids" {}
variable "security_group_ids" {}


terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "~> 5.0"
		}
	}
}

provider "aws" {
	region = var.region
}


resource "aws_ecs_cluster" "cluster" {
  name = "${var.prefix}-cluster"

  setting {
    name = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.prefix}-cluster"
    LeJ = "cestleS"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_cp" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base = 1
    weight = 100
    capacity_provider = "FARGATE"
  }

}

resource "aws_ecs_task_definition" "task" {
  family = "${var.prefix}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 512
  memory = 1024
  task_role_arn = "arn:aws:iam::268849317545:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name = "lefootcestrince"
      image = "public.ecr.aws/g7l4n5q7/lefootcestrince:v1"
      cpu = 512
      memory = 1024
      essential = true
      portMappings = [
        {
          name = "nginx-http"
          protocol = "tcp"
          appProtocol = "http"
          containerPort = 80
          hostPort = 80
        }
      ]
    }
  ])

  tags = {
    Name = "${var.prefix}-task"
  }
}

resource "aws_ecs_service" "service" {
  name = "${var.prefix}-svc"
  cluster = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    subnets = [for k,v in var.subnet_ids : v]
    security_groups = [for k,v in var.security_group_ids : v]
    assign_public_ip = true
  }
}


output "dep_output" {
  value = "ok"
}
