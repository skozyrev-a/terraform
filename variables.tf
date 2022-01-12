variable "do_token" {
  type        = string
  description = "access token digital ocean"
}
variable "my_key" {
  type        = string
  description = "my public ssh_key"
}
variable "aws_a_key" {
  type        = string
  description = "access_key_aws"
}
variable "aws_s_key" {
  type        = string
  description = "secret_key_aws"
}
variable "domain" {
  type        = list(any)
  description = "list of your domain names"
}
