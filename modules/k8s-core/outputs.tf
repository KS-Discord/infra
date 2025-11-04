output "dashboard_token" {
  description = "Kubernetes Dashboard에 로그인하기 위한 토큰"
  value       = data.kubernetes_secret.admin_user_token.data["token"] 
  sensitive   = true
}