output "hostname" {
  value = aws_instance.web_server.public_dns
}


output "instance_id" {
  value = aws_instance.web_server.id
}

output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}