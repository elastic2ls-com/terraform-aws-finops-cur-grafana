terraform {
  required_version = ">= 1.4"

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.38.0" # oder aktuelle stabile Version
    }
  }


}
