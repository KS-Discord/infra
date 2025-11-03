# modules/k8s-dashboard/outputs.tf

output "dashboard_token" {
  description = "Kubernetes Dashboard에 로그인하기 위한 토큰 (Secret에서 조회)"
  # Secret의 data에서 token 값을 base64 디코딩하여 반환
  value     = data.kubernetes_secret.admin_user_token.data["token"]
  sensitive = true
}