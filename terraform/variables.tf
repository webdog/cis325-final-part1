variable "ami_id" {
  default = "ami-0a55d36a05e0942b0"
}

variable "instance_type" {
  default = "t4g.small"
}

variable "ghcr_repo" {
  default = "webdog"
}

variable "ghcr_image" {
    default = "cis325-final-part1"
}

variable "instance_name" {
    default = "web-server"
}