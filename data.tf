data "aws_caller_identity" "current" {}

data "aws_vpc" "ciss" {
  filter {
    name   = "owner-id"
    values = ["086523049501"]
  }
}

data "aws_subnets" "ciss_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.ciss.id]
  }
  filter {
    name   = "tag:Name"
    values = ["public"]
  }
}

data "aws_subnet" "ciss_public" {
  for_each = toset(data.aws_subnets.ciss_public.ids)
  id       = each.value
}

data "aws_subnets" "ciss_internal" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.ciss.id]
  }
  filter {
    name   = "tag:Name"
    values = ["internal"]
  }
}

data "aws_subnet" "ciss_internal" {
  for_each = toset(data.aws_subnets.ciss_internal.ids)
  id       = each.value
}

data "aws_subnets" "ciss_isolated" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.ciss.id]
  }
  filter {
    name   = "tag:Name"
    values = ["isolated"]
  }
}

data "aws_subnet" "ciss_isolated" {
  for_each = toset(data.aws_subnets.ciss_isolated.ids)
  id       = each.value
}