terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "webapp_server" {
  ami           = "ami-0742b4e673072066f"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  iam_instance_profile = "inspec-demo-instance-profile"
  vpc_security_group_ids = [ aws_security_group.web.id ]
  key_name = "inspecdemo"

  tags = {
    Name = "inspec-demo-ec2-webapp-test"
  }
}

resource "aws_security_group" "web" {
  name        = "inspec-demo-web-security-group-test"
  description = "Allow HTTP/HTTPS and SSH inbound and outbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "inspec-demo-web-security-group-test"
  }
}

resource "aws_eip" "webapp" {
  instance = aws_instance.webapp_server.id
  vpc      = true
  tags = {
    Name = "inspec-demo-eip-test"
  }
}

resource "aws_db_instance" "database" {
  vpc_security_group_ids = [ aws_security_group.database.id ]
  allocated_storage = 5
  instance_class = "db.t2.small"
  engine = "postgres"
  username = "inspecdemo"
  password = "Inspecdem0"
  skip_final_snapshot = "true"
  tags = {
    Name = "inspec-demo-rds-test"
  }
}

resource "aws_security_group" "database" {
  name        = "inspec-demo-db-security-group-test"
  description = "Allow postgres inbound traffic"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "inspec-demo-db-security-group-test"
  }
}
