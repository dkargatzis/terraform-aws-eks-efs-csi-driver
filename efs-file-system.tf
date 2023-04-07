resource "aws_efs_file_system" "efs" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "${var.cluster_name}-fs"
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "${var.cluster_name}-efs-sg"
  description = "Cluster communication with EFS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-efs-sg"
  }
}

resource "aws_security_group_rule" "efs_inbound" {
  description       = "Allow inbound NFS traffic from the CIDR of the cluster VPC"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 2049
  to_port           = 2049
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.efs_sg.id
}

resource "aws_efs_mount_target" "efs_mount_targets" {
  count           = length(var.vpc_subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.vpc_subnet_ids[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}
