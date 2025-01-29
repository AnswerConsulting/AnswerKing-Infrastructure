data "cloudflare_zones" "lookup" {
  for_each = toset(var.create_zone ? [] : [var.domain])
  name     = each.value
  account  = {
    id = var.account_id
  }
}

resource "cloudflare_zone" "dns" {
  for_each = toset(var.create_zone ? [var.domain] : [])
  name     = each.value
  account  = {
    id = var.account_id
  }
}

resource "cloudflare_dns_record" "dns" {
  for_each = var.records

  zone_id  = local.zone_id
  name     = each.value.name
  ttl      = each.value.ttl != null ? each.value.ttl : var.default_ttl
  type     = each.value.type
  content  = each.value.content
  priority = each.value.priority
  proxied  = each.value.proxied
}

resource "cloudflare_dns_record" "apex_txt" {
  for_each = toset(concat(var.apex_txt, [
    format("security_contact=mailto:%s", local.security_contact),
    replace("v=spf1 ${join(" ", var.spf)} -all", "  ", " ")
  ]))

  zone_id = local.zone_id
  name    = "@"
  ttl     = var.default_ttl
  type    = "TXT"
  content = each.value
  proxied = false
}

resource "cloudflare_dns_record" "caa" {
  for_each = toset(var.caa_issuers)
  zone_id  = local.zone_id
  name     = "@"
  ttl      = var.default_ttl
  type     = "CAA"

  data = {
    flags = "0"
    tag   = "issue"
    value = each.value
  }
}
