data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  tags = {
    private = "True"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  tags = {
    private = "False"
  }
}

# Place a security group around the service
resource "aws_security_group" "service" {
  vpc_id = var.vpc_id

  # Allow the load balancer to forward traffic to the service
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    # security_groups = [aws_security_group.lb.id] # FIXME
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "graphql-service"
    Application = "graphql"
  }
}

resource "aws_security_group" "docdb" {
  vpc_id      = var.vpc_id
  name_prefix = "${var.stage}-docdb"
  tags = {
    stage = var.stage
  }
}

# Allow the service to connect to the RDS Database
resource "aws_vpc_security_group_ingress_rule" "docdb" {
  security_group_id = aws_security_group.docdb.id
  description      = "Connection from backend API"
  from_port        = 0
  to_port          = var.mongo_port
  ip_protocol      = "tcp"
  referenced_security_group_id = aws_security_group.service.id
  depends_on = [
    aws_security_group.docdb,
    aws_security_group.service,
    aws_docdb_cluster.cluster,
  ]
}

resource "aws_docdb_subnet_group" "docdb" { 
  name = local.subnet_name
  # subnet_ids = data.aws_subnet_ids.private_subnets
  subnet_ids = data.aws_subnets.private.ids
  # tags = {
    # stage = var.stage
  # }
}

# Place the internet-facing load balancer into a security group
resource "aws_security_group" "lb" {
  vpc_id = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "alb"
    Application = "graphql"
  }
}

# Setup a load balancer to forward public traffic to the service
resource "aws_alb" "this" {
  name               = "graphql-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.public.ids
  security_groups    = [aws_security_group.lb.id]

  tags = {
    Name        = "graphql-lb"
    Application = "graphql"
  }
}

resource "aws_lb_target_group" "this" {
  name        = "graphql-target"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200-299,301"
    timeout             = "10"
    path                = "/api/health/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "graphql-target"
    Application = "graphql"
  }
}

# Redirect any HTTP traffic to HTTPS
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_alb.this.id
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_alb.this.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-1-2021-06"
  certificate_arn   = var.acm_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.id
  }
}