# Latest Amazon Linux 2023 AMI (comes with the SSM agent preinstalled).
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# ---------------------------------------------------------------------------
# Security groups
# ---------------------------------------------------------------------------
resource "aws_security_group" "bastion" {
  name        = "${var.name}-bastion-sg"
  description = "Bastion host in the public subnet"
  vpc_id      = var.vpc_id
  tags        = { Name = "${var.name}-bastion-sg" }
}

# SSH only from the CIDRs you list (e.g. your home IP). Empty list = no SSH;
# use SSM Session Manager instead.
resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  for_each = toset(var.ssh_allowed_cidrs)

  security_group_id = aws_security_group.bastion.id
  description       = "SSH from ${each.value}"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_egress_rule" "bastion_all" {
  security_group_id = aws_security_group.bastion.id
  description       = "All outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "app" {
  name        = "${var.name}-app-sg"
  description = "App instance in the private subnet"
  vpc_id      = var.vpc_id
  tags        = { Name = "${var.name}-app-sg" }
}

# Private instance accepts SSH and ping only from the bastion's security group.
resource "aws_vpc_security_group_ingress_rule" "app_ssh_from_bastion" {
  security_group_id            = aws_security_group.app.id
  description                  = "SSH from bastion"
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = aws_security_group.bastion.id
}

resource "aws_vpc_security_group_ingress_rule" "app_icmp_from_bastion" {
  security_group_id            = aws_security_group.app.id
  description                  = "Ping from bastion"
  ip_protocol                  = "icmp"
  from_port                    = -1
  to_port                      = -1
  referenced_security_group_id = aws_security_group.bastion.id
}

resource "aws_vpc_security_group_egress_rule" "app_all" {
  security_group_id = aws_security_group.app.id
  description       = "All outbound (through NAT)"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# ---------------------------------------------------------------------------
# IAM role so both instances can be reached with SSM Session Manager
# ---------------------------------------------------------------------------
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ssm" {
  name               = "${var.name}-ec2-ssm"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm" {
  name = "${var.name}-ec2-ssm"
  role = aws_iam_role.ssm.name
}

# ---------------------------------------------------------------------------
# Instances
# ---------------------------------------------------------------------------
resource "aws_instance" "bastion" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm.name
  key_name               = var.key_name

  metadata_options {
    http_tokens = "required" # IMDSv2 only
  }

  root_block_device {
    encrypted = true
  }

  tags = { Name = "${var.name}-bastion" }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm.name
  key_name               = var.key_name

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = { Name = "${var.name}-app" }
}
