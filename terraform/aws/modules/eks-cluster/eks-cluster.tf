module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "17.20.0"

    cluster_name = "kme-cluster-3"
    cluster_version = "1.21"
    subnets = var.nodes_subnets

    cluster_create_timeout = "10m"
    cluster_endpoint_private_access = true
    vpc_id = var.vpc_id

    worker_groups = [
        {
            name = "kme-cluster3-worker-group"
            instance_type = "t2.small"
            asg_desired_capacity = 2
            asg_max_size = 2
            additional_security_group_ids = [var.main_sg_id]
        }
    ]
}