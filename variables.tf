variable "aws_profile" {
 description = "AWS CLI profile"
 type    = string
 default   = "default"
}

variable "aws_region" {
 description = "AWS region for AWS provider (має відповідати регіону EKS)"
 type    = string
 default   = "eu-central-1"
}

variable "eks_state_bucket" {
 description = "S3 bucket з remote state EKS"
 type    = string
 default   = "mlops-tfstate-dmytrolazar"
}

variable "eks_state_key" {
 description = "S3 key для remote state EKS"
 type    = string
 default   = "eks/terraform.tfstate"
}

variable "eks_state_region" {
 description = "Регіон бакета з remote state EKS"
 type    = string
 default   = "eu-central-1"
}

variable "argocd_namespace" {
 description = "Namespace для Argo CD"
 type    = string
 default   = "infra-tools"
}

variable "argocd_chart_version" {
 description = "Версія Helm-чарту Argo CD"
 type    = string
 default   = "v7.7.5"
}

variable "app_repo_url" {
 description = "Публічний Git-репозиторій з маніфестами"
 type    = string
 default   = "https://github.com/dmytrolazar/mlops-experiments.git"
}

variable "app_repo_branch" {
 description = "Гілка"
 type    = string
 default   = "main"
}