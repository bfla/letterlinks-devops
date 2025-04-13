# resource "aws_route53_record" "gmail-verification-record" {
#   allow_overwrite = true
#   name            = var.domain
#   records         = [
#     var.gmail_mx_val
#   ]
#   ttl             = "300"
#   type            = "TXT"
#   priority        = "15"
#   zone_id         = aws_route53_zone.domain.zone_id
# }

resource "aws_route53_record" "gmail-mx-records" {
  allow_overwrite = true
  name            = var.domain
  records         = [
    "1 SMTP.GOOGLE.COM.",
    "15 ${var.gmail_mx_val}"
  ]
  ttl             = "300"
  type            = "MX"
  zone_id         = aws_route53_zone.domain.zone_id
}

# resource "aws_route53_record" "gmail-mx-records" {
#   allow_overwrite = true
#   name            = var.domain
#   records         = [
#     "1 ASPMX.L.GOOGLE.COM.",
#     "5 ALT1.ASPMX.L.GOOGLE.COM.",
#     "5 ALT2.ASPMX.L.GOOGLE.COM.",
#     "10 ALT3.ASPMX.L.GOOGLE.COM.",
#     "10 ALT4.ASPMX.L.GOOGLE.COM."
#   ]
#   ttl             = "300"
#   type            = "MX"
#   zone_id         = aws_route53_zone.domain.zone_id
# }

# # https://aws.amazon.com/premiumsupport/knowledge-center/route53-resolve-dkim-text-record-error/
# resource "aws_route53_record" "gmail-dkim-record" {
#   allow_overwrite = true
#   name            = "google._domainkey"
#   # a single record entry has a maximum of 255 characters so we need to create
#   # a record with values
#   records = [
#     # reverse them so that the first value set gets added before the second
#     "${substr(var.gmail_dkim_record, 0, 254)}\" \"${substr(var.gmail_dkim_record, 254, -1)}"
#   ]
#   ttl             = "300"
#   type            = "TXT"
#   zone_id         = aws_route53_zone.domain.zone_id
# }