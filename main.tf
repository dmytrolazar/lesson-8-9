terraform {
 backend "s3" {
  bucket = "mlops-tfstate-dmytrolazar"
  key   = "argocd/terraform.tfstate"
  region = "eu-central-1"
 }
}

resource "kubernetes_namespace" "argo" {
  metadata {
    name = var.argocd_namespace
  }
}

# Встановлення Argo CD через офіційний Helm-чарт
resource "helm_release" "argo" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argo.metadata[0].name


  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version


  recreate_pods = true
  replace       = true


  values = [file("${path.module}/values/argocd-values.yaml")]
}

# Патерн "App of Apps": Кореневий додаток, який деплоїть інші додатки з папки
resource "kubernetes_manifest" "root_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "root-apps"
      namespace = var.argocd_namespace
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.app_repo_url
        targetRevision = var.app_repo_branch
        path           = "argocd/applications" # 👈 Вказуємо твою реальну папку
        directory = {
          recurse = true # Читати всі файли всередині
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = var.argocd_namespace # Child-додатки реєструються в infra-tools
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
  depends_on = [helm_release.argo]
}