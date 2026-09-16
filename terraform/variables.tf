variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "region_code" {
  description = "Short code for the Azure region"
  type        = string
}