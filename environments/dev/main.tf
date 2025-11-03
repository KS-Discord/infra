# environments/dev/main.tf

module "k3s_cluster" {
  source = "../../modules/k3s-cluster"
  server_user = var.server_user # <- 루트 모듈의 변수를 전달하는 경우
  master_ip              = var.master_ip
  ssh_private_key_path   = var.ssh_private_key_path
  kubeconfig_output_path = "~/.kube/ks-discord-dev.yaml"
}

module "k8s_dashboard" {
  source = "../../modules/k8s-dashboard"

  depends_on = [module.k3s_cluster] # K3s 설치 완료 후 실행
}

# 2. Music Bot 배포 모듈 호출
module "music_bot_dev_deployment" {
  source = "../../modules/music-bot" 
  
  depends_on = [module.k3s_cluster] # K3s 설치 완료 후 실행

  bot_name         = "dev-music-bot" # 개발용 봇 이름
  image_repository = "your-docker-registry/music-bot"
  image_tag        = "dev-latest" # 개발용 이미지 태그
  discord_token    = var.dev_music_bot_token
}

output "dashboard_login_token" {
  description = "Kubernetes Dashboard에 로그인하는 데 사용할 토큰입니다."
  # ⭐️ 이 모듈 이름이 main.tf에 선언된 이름과 일치해야 합니다.
  value     = module.k8s_dashboard.dashboard_token 
  sensitive = true
}