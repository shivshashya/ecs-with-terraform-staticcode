# Create a public hosted zone or use the existing one
# data "aws_route_zone" "primary" {
#     name = var.ecr_app_values["domain_name"]
#     private_zone = false
# }


# Create a record set for the ALB in the hosted zone
# resource "aws_route53_record" "august_alb" {
#     zone_id = data.aws_route53_zone.primary.zone_id
#     name    = "${var.environment}.${var.ecr_app_values["subdomain_name"]}.${data.aws_route53_zone.primary.name}"
#     type    = "A"  #Public or private ip
#     alias {   #Alias record to point to ALB
#         name = aws_lb.alb.dns_name
#         zone_id = aws_lb.alb.zone_id
#         evaluate_target_health = true
#     }
# }

# ACM certificate for the domain (ap-south-1 region)
# resource "aws_acm_certificate" "cert" {
#     #"devaugust.shivshashya.shop"
#     domain_name = "${var.environment}.${var.ecr_app_values["subdomain_name"]}.${data.aws_route53_zone.primary.name}"
#     validation_method = "DNS"
# }

# # Route53 record for ACM validation It does the validation every 60 days
# resource "aws_route53_record" "cert_validation" {
#     for_each = {
#      for dvo in aws_acm_certification.cert.domain_validation_options : dvo.domain_name => {
#         name = dv0.resource_record_name
#         type = dvo.resource_record_type
#         record = dvo.resource_record_value
#      }
#     }
#     zone_id = data.aws_route53_zone.primary.zone_id
#     name = each.value.name
#     type = each.value.type
#     ttl = 60
#     records = [each.value.record]
# }

# # ACM Cert validation using DNS
# resource "aws_acm_certification" "cert_validation" {
#   certificate_arn = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
# }
