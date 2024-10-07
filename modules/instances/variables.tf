variable "region" {
  description = "The region in which resources will be created."
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "The zone in which resources will be created."
  type        = string
  default     = "us-west1-a"
}

variable "project_id" {
  description = "The Google Cloud project ID to deploy resources."
  type        = string
  default     = "Your_Project_ID_here" # Change to your project ID
}

variable "subnet_01_self_link" {
  description = "Self link for subnet-01"
  type        = string
}

variable "subnet_02_self_link" {
  description = "Self link for subnet-02"
  type        = string
}
