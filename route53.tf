module "acm_load" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = "${var.load_test_domain}"
  zone_id      = var.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "${var.load_test_domain}",
  ]

  wait_for_validation = true

  tags = {
    Name = "${var.load_test_domain}"
  }
}

resource "aws_route53_record" "api" {
  zone_id = var.zone_id
  name    = "${var.domain_name}"
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = module.global_accelerator.dns_name
    zone_id                = module.global_accelerator.hosted_zone_id
  }

}

resource "aws_route53_record" "load" {
  zone_id = var.zone_id
  name    = "${var.load_test_domain}"
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = module.alb_load.dns_name
    zone_id                = module.alb_load.zone_id
  }

}