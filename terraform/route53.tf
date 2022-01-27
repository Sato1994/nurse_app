# ホストゾーン###################################################################################
data "aws_route53_zone" "zone" {
  name = "nurse-hop.com"
}
#################################################################################################

# dnsレコード####################################################################################
resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name = data.aws_route53_zone.zone.name
  type = "A"

  alias {
    name = aws_lb.alb.dns_name
    zone_id = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
#################################################################################################

# 検証dnsレコード################################################################################
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }
  name = each.value.name
  records = [each.value.record]
  ttl = 60
  type = each.value.type
  zone_id = data.aws_route53_zone.zone.zone_id
}
#################################################################################################