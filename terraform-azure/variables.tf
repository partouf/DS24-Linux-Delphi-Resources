
# https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables

# variable "mssql_db_admin_password" {
#   description = "Database administrator password"
#   type        = string
#   sensitive   = true
# }

variable "syslog_port" {
  description = "Syslog port"
  type        = number
  sensitive   = true
}

# variable "restart-app-id" {
#   description = "ds24restart app-id"
#   type        = string
#   sensitive   = true
# }
