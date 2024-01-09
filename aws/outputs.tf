output "website" {
  value       = "http://${aws_instance.test.public_ip}"
  description = "Website URL"
}

output "ssh" {
  description = "ssh command to connect the EC2 instance"
  value       = "ssh -i ./${local_file.private_ssh_key.filename} ubuntu@${aws_instance.test.public_ip}"
}
