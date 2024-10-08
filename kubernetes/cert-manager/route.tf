resource "time_sleep" "wait_for_kubernetes" {

    depends_on = [
        data.aws_eks_cluster.sock-cluster
    ]

    create_duration = "20s"
}

data "local_file" "lb_hostname"{
    filename = "${path.module}/lb_hostname.txt"
     depends_on = [
      time_sleep.wait_for_kubernetes
    ]
}

resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
  tags = {
    Environment = "dev"
  }
}

locals {
  instances = {
    namea = "sock-shop.${var.domain_name}"
    nameb = "grafana.${var.domain_name}"
  }
}

resource "aws_route53_record" "C-record" {
  for_each        = local.instances
  allow_overwrite = true
  zone_id         = aws_route53_zone.hosted_zone.zone_id
  name            = each.value
  ttl             = 300
  type            = "CNAME"
  records          = [data.local_file.lb_hostname.content]

  depends_on = [
    data.local_file.lb_hostname
  ]

}



# Path: route53.tf
# request public certificates from the amazon certificate manager.
resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = [var.alt_domain_name]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# get details about a route 53 hosted zone
/* data "aws_route53_zone" "route53_zone" {
  name         = var.domain_name
  private_zone = false
} */

# create a record set in route 53 for domain validatation
resource "aws_route53_record" "route53_record" {
    depends_on = [
      aws_route53_record.C-record
    ]

  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.hosted_zone.zone_id
}

# validate acm certificates
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_record : record.fqdn]
}

