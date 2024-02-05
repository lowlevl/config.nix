data "kubectl_path_documents" "documents" {
  provider         = kubectl.local
  pattern          = "${path.module}/manifests/*.yaml"
  disable_template = true
}

resource "kubectl_manifest" "manifests" {
  provider = kubectl.local
  for_each = data.kubectl_path_documents.documents.manifests

  server_side_apply = true
  yaml_body         = each.value
  force_new         = true
  wait              = true
}
