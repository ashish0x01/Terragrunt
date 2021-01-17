# Output Section
output "public_subnets_id" {
  value = join(",", aws_subnet.public.*.id)
}

output "private_subnets_id" {
  value = join(",", aws_subnet.private.*.id)
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}