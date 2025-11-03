# Kubernetes Provider 설정
provider "kubernetes" {
  # k3s 모듈의 출력을 참조하여, 설치가 완료된 K3s 클러스터에 연결하도록 설정합니다.
  config_path = module.k3s_cluster.kubeconfig_path
}