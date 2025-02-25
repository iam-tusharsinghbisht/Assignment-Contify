output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subenta_id" {
  value = aws_subnet.public_subnet_a.id
}

output "public_subentb_id" {
  value = aws_subnet.public_subnet_b.id
}

output "private_subenta_id" {
  value = aws_subnet.private_subnet_a.id
}

output "private_subentb_id" {
  value = aws_subnet.private_subnet_b.id
}