output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "domain_name" {
  value = aws_route53_record.record.name
}