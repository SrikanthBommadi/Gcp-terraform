variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "srikanth-gcp-470012"
}

variable "project_number" {
  description = "GCP project number"
  type        = string
  default     = "Your-account-number"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "us-central1"
}

variable "subnet_ip_ranges" {
  description = "CIDRs for subnets"
  type = object({
    public     : string
    private_a  : string
    private_b  : string
  })
  default = {
    public    = "10.10.1.0/24"
    private_a = "10.10.2.0/24"
    private_b = "10.10.3.0/24"
  }
}

variable "enable_apis" {
  description = "Enable required APIs"
  type        = bool
  default     = true
}
