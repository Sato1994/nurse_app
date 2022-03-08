# サービスディスカバリ ###########################################################
resource "aws_service_discovery_private_dns_namespace" "nurse_internal" {
  name = "nurse"
  vpc = aws_vpc.vpc.id
}
##################################################################################

# サービス #######################################################################
resource "aws_service_discovery_service" "sd_api" {
  name = "sd_api"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.nurse_internal.id

    dns_records {
      ttl = 10
      type = "A"
    }
    
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
##################################################################################
