variable "location" {
  type    = string
  default = "eastus"
}

variable "prefix" {
    type    = string
    default = "new-infra-demo"
}

# CLI: terraform apply -var="django_server_worker_count=3"
variable "django_server_worker_count" {
    type    = string
    default = "2"
}