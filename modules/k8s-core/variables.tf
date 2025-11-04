variable "kubeconfig_content" {
  description = "클러스터 접속을 위한 kubeconfig 파일 내용"
  type        = string
  sensitive   = true
}