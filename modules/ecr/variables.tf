variable "region" {
  type = string
  default = "us-east-1"
}

variable "repos" {
  type = list(string)
  default = [
    "letterlinks-graphql"
  ]
}
