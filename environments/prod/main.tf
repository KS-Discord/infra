# k3s 전용 계정 생성
module "k3s_user" {
  source   = "../../modules/linux-user"
  username = var.k3s_user.name
  uid      = var.k3s_user.uid
  gid      = var.k3s_user.gid
  connection = {
    host        = var.target.host
    user        = var.ssh.user
    private_key = file(var.ssh.private_key)
  }
}

# # 1. OS 의존적인 K3s 설치 및 kubeconfig 추출
# module "k3s_installer" {
#   source               = "../../modules/k3s-installer"
#   master_ip            = var.master_ip
#   ssh_private_key_path = var.ssh_private_key_path
#   server_user          = var.server_user
# }

# # 2. 클러스터 코어 설정 (Dashboard, RBAC 등)
# module "k8s_core" {
#   source = "../../modules/k8s-core"
#   # ⭐️ installer 모듈의 출력을 받아와 k8s-core 모듈에 주입
#   kubeconfig_content     = module.k3s_installer.kubeconfig_content
#   kubeconfig_output_path = module.k3s_installer.kubeconfig_output_path

#   # k8s-core는 installer 모듈 완료 후 실행되어야 합니다.
#   depends_on = [module.k3s_installer]
# }

# # ⭐️ 최종 출력도 k8s_core 모듈의 토큰을 참조하도록 수정
# output "dashboard_login_token" {
#   value     = module.k8s_core.dashboard_token
#   sensitive = true
# }
