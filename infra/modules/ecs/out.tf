output "web_endpoint" {
  value       = "http://${aws_lb.hello.dns_name}"
  description = "hit this url to access web server"
}