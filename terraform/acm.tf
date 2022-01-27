# ssl証明書##############################################################################
resource "aws_acm_certificate" "certificate" {
  domain_name = aws_route53_record.record.name
  subject_alternative_names = []
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
#########################################################################################

# 証明書検証まで待機#####################################################################
resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
#########################################################################################
