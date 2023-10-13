locals {
  prefix = "iunuah"
  region = "eu-west-1"

  subnets = {
    subnet1 = {
      cidr_block = "10.0.1.0/24"
      availability_zone = "eu-west-1a"
      map_public_ip_on_launch = true
    }

    subnet2 = {
      cidr_block = "10.0.2.0/24"
      availability_zone = "eu-west-1b"
      map_public_ip_on_launch = true
    }
  }

  security_groups = {
    useraccess = {
      ingress = {
        http = {
          from_port = 80
          to_port = 80
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }

      egress = {
        all = {
          from_port = 0
          to_port = 0
          protocol = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }

  container = {
    name = "lefootcestrince"
    image = "public.ecr.aws/g7l4n5q7/lefootcestrince:v1"
  }

  iam_role = "ECS_Students"
}
