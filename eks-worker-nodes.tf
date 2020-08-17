#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "worker-node" {
  name = "terraform-eks-worker-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "worker-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker-node.name
}

resource "aws_iam_role_policy_attachment" "worker-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker-node.name
}

resource "aws_iam_role_policy_attachment" "worker-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker-node.name
}

resource "aws_eks_node_group" "terraform-node-group" {
  cluster_name    = aws_eks_cluster.terraform-cluster.name
  node_group_name = "terraform-${terraform.workspace}"
  node_role_arn   = aws_iam_role.worker-node.arn
  subnet_ids      = aws_subnet.subnet-public[*].id
  instance_types = ["${var.aws_instance_types[terraform.workspace]}"]

  scaling_config {
    min_size     = var.eks_scaling_min[terraform.workspace]
    max_size     = var.eks_scaling_max[terraform.workspace]
    desired_size = var.eks_scaling_desired[terraform.workspace]
  }

  tags = map(
    "Name", "${var.aws_eks_cluster_name}-${terraform.workspace}-worker",
    "envinronment", "${terraform.workspace}",
  )

  depends_on = [
    aws_iam_role_policy_attachment.worker-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.worker-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.worker-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
