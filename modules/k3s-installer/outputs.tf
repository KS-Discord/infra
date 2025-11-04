# # infra/modules/k3s-installer/outputs.tf

# output "kubeconfig_content" {
#   description = "K3s 클러스터 접속을 위한 kubeconfig 파일 내용"
#   # data.remote_file의 내용(content)을 그대로 반환합니다.
#   value       = data.remote_file.k3s_kubeconfig.content
#   sensitive   = true # 보안상 민감 정보로 설정
# }