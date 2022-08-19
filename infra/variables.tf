variable "project" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "availability_zones_count" {
  type    = number
  default = 3
}