resource "aws_vpc" "dev-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    instance_tenancy = "default"
    tags = {
        Name = var.vpcname
    }
}

resource "aws_subnet" "dev-subnet-public-1" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "dev-subnet-public-2" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "dev-sng" {
    name = "dev-sng"
    subnet_ids = [aws_subnet.dev-subnet-public-1.id, aws_subnet.dev-subnet-public-2.id]
}

resource "aws_internet_gateway" "dev-igw" {
    vpc_id = aws_vpc.dev-vpc.id
}

resource "aws_route_table" "dev-public-crt" {
    vpc_id = aws_vpc.dev-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev-igw.id
    }
}

resource "aws_route_table_association" "dev-crta-public-subnet-1" {
    subnet_id = aws_subnet.dev-subnet-public-1.id
    route_table_id = aws_route_table.dev-public-crt.id
}

resource "aws_route_table_association" "dev-crta-public-subnet-2" {
    subnet_id = aws_subnet.dev-subnet-public-2.id
    route_table_id = aws_route_table.dev-public-crt.id
}

resource "aws_security_group" "dev-sg" {
    vpc_id = aws_vpc.dev-vpc.id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "pokemon-sg"
    }
}