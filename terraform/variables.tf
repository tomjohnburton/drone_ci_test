variable "drone_server_url" {
  type = string
  default = "drone.company.com"
  description = "URL for drone UI and webhook config"
}

variable "zone_name" {
  type = string
  default = "company.com"
  description = "Hosted zone for your company"
}

variable "aws_config" {
  type = object({
    region: string,
    profile: string
  })
  description = "AWS config for you local machine"
  default = {
    region = "eu-central-1"
    profile = "default"
  }
}

variable "key_name" {
  type = string
  description = "File location of your local ssh key"
  default = "default-key"
}

