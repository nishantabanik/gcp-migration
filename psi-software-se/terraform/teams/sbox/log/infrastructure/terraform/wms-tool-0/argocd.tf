resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "7.6.8"
  create_namespace = true

  values = [
    file("${path.module}/argocd/values.yaml")
  ]

  set {
    name  = "server.ingress.hostname"
    value = trim(google_dns_record_set.argocd.name, ".")
  }
}

resource "kubernetes_manifest" "argocd_repositories" {
  for_each = fileset("${path.module}/argocd/repositories", "*.yaml")
  manifest = yamldecode(file("${path.module}/argocd/repositories/${each.value}"))

  depends_on = [helm_release.argocd, helm_release.sealed_secrets]
}

resource "kubernetes_manifest" "argocd_apps" {
  manifest = yamldecode(file("${path.module}/argocd/apps/applicationset.yaml"))

  depends_on = [helm_release.argocd, helm_release.sealed_secrets]
}