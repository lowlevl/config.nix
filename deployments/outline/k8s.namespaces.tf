resource "kubernetes_namespace_v1" "self" {
  metadata {
    name = "outline"
  }
}
