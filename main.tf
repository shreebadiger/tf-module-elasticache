resource "aws_elasticache_parameter_group" "main" {
  name   = local.name
  family = var.parameter_group_family
  tags = merge(var.tags, {Name = local.name})

}

resource "aws_elasticache_subnet_group" "main" {
  name       = local.name
  subnet_ids = var.subnets
  tags = merge(var.tags, {Name = local.name})
}

resource "aws_security_group" "main" {
  name        = local.name
  description = local.name
  vpc_id      = var.vpc_id

  ingress {
    description      = "elasticache"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = var.sg_cidrs
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, {Name = local.name})

}


resource "aws_elasticache_cluster" "main" {
  cluster_id           = local.name
  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = aws_elasticache_parameter_group.main.name
  port                 = 6379
  security_group_ids = [aws_security_group.main.id]
  subnet_group_name = aws_elasticache_subnet_group.main.name
  tags = merge(var.tags, {Name = local.name})
}