locals {
  zone_id = module.route53_zones.route53_zone_zone_id["beansnet.net"]
}

module "route53_zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "2.10.2"

  zones = {
    "beansnet.net" = {
      tags = {
        Name = "beansnet.net"
      }
    }
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

module "records" {
  zone_id    = local.zone_id
  depends_on = [module.route53_zones]
  source     = "terraform-aws-modules/route53/aws//modules/records"

  records = [
    # {  # to be managed via "dynamicdns"
    #   name = ""
    #   type = "A"
    #   ttl  = 3600
    #   records = [
    #     "10.10.10.10",
    #   ]
    # },
    {
      name           = "*"
      type           = "CNAME"
      ttl            = 300
      records        = ["beansnet.net."]
    },
    {
      name           = "argocd"
      type           = "CNAME"
      ttl            = 300
      records        = ["beansnet.net."]
    },
    {
      name           = "smbshare"
      type           = "CNAME"
      ttl            = 300
      records        = ["lab.beansnet.net."]
    },
    {
      name           = "timemachine"
      type           = "CNAME"
      ttl            = 300
      records        = ["lab.beansnet.net."]
    },
    {
      name           = "lab"
      type           = "A"
      ttl            = 300
      records        = ["192.168.1.10"]
    },
    {
      name           = "printer"
      type           = "A"
      ttl            = 300
      records        = ["192.168.1.2"]
    },
  ]
}
