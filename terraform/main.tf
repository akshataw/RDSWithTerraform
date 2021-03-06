provider "aws" {
    region = "us-east-1"
}

resource "aws_rds_cluster" "default" {
    cluster_identifier = "pokemon-database"
    engine = "aurora-mysql"
    engine_mode = "serverless"
    availability_zones = ["us-east-1a", "us-east-1b"]
    database_name = var.name
    master_username = var.user
    master_password = var.password
    backup_retention_period = 1
    enable_http_endpoint = true
    skip_final_snapshot = true
    db_subnet_group_name = aws_db_subnet_group.dev-sng.name
    vpc_security_group_ids = [aws_security_group.dev-sg.id]
}