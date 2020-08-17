#
#    EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_iam_role" "terraform-cluster" {
  name = "terraform-eks-cluster-${terraform.workspace}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "terraform-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.terraform-cluster.name
}

resource "aws_iam_role_policy_attachment" "terraform-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.terraform-cluster.name
}

resource "aws_security_group" "terraform-cluster" {
  name        = "terraform-eks-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.vpc-terraform.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.aws_eks_cluster_name}-${terraform.workspace}",
    environment = "${terraform.workspace}"
  }
}

resource "aws_security_group_rule" "sgr-terraform-cluster-ingress-https" {
  cidr_blocks       = var.outgoing_ip
  description       = "Allow external access to the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.terraform-cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "terraform-cluster" {
  name     = var.aws_eks_cluster_name
  role_arn = aws_iam_role.terraform-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.terraform-cluster.id]
    subnet_ids         = aws_subnet.subnet-public[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.terraform-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.terraform-cluster-AmazonEKSServicePolicy,
  ]

  tags = map(
    "Name", "${var.aws_eks_cluster_name}-${terraform.workspace}",
    "envinronment", "${terraform.workspace}",
  )
}
