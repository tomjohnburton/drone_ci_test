provider "aws" {
  region = var.aws_config.region
  profile = var.aws_config.profile
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
