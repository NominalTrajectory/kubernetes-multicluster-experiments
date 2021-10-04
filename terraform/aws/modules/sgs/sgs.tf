# AWS SECURITY GROUPS

resource "aws_security_group" "kme-cluster3-main-sg" {
    name_prefix = "kme-cluster3-main-sg"
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"

        cidr_blocks = [var.cidr_blocks]
    }
}