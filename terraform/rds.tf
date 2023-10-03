resource "aws_db_subnet_group" "demo_subnet" {
  name       = "demo-db"
  subnet_ids = [aws_subnet.subnet.id, aws_subnet.subnet2.id]

  tags = {
    Name = "Demo subnet group"
  }
}

resource "aws_db_parameter_group" "demo_parameter" {
  name   = "demo-aws-parameter-group"
  family = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}


resource "aws_db_instance" "demo_db_instance" {
  identifier                    = "instance"
  instance_class                = "db.t3.micro"
  allocated_storage             = 5
  engine                        = "postgres"
  engine_version                = "15.3"
  username                      = "demo"
  manage_master_user_password   = true
  master_user_secret_kms_key_id = aws_kms_key.example.key_id
  db_subnet_group_name          = aws_db_subnet_group.demo_subnet.name
  vpc_security_group_ids        = [aws_security_group.security_group.id]
  parameter_group_name          = aws_db_parameter_group.demo_parameter.name
  publicly_accessible           = true
  skip_final_snapshot           = true
}

resource "aws_kms_key" "example" {
  description = "KMS Key"
}
