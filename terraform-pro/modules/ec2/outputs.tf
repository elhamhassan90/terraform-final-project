output "public_instance_map" {
  value = {
    "public1" = aws_instance.public[0].id
    "public2" = aws_instance.public[1].id
  }
}

output "private_instance_map" {
  value = {
    "private1" = aws_instance.private[0].id
    "private2" = aws_instance.private[1].id
  }
}

