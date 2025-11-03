# environments/dev/providers.tf

provider "kubernetes" {
  config_path = module.k3s_cluster.kubeconfig_path
  
  # ✅ K3s 클러스터 모듈의 설치 단계가 완료될 때까지 기다리도록 명시적인 의존성을 추가합니다.
  #    k3s_cluster 모듈 내부의 'null_resource.get_kubeconfig'가 완료된 후에 Provider를 설정합니다.
  #    이는 terraform apply 시에만 유효합니다.
  # 
  #   ⚠️ 이 방법이 작동하려면 k3s_cluster 모듈의 output에 해당 리소스를 연결해야 합니다.
  #      가장 간단한 방법은 아래 `depends_on`을 사용하는 것입니다.
}

# 🛠️ environments/dev/main.tf 에 이 의존성을 걸어주는 것이 더 확실합니다.
#    아래 main.tf 섹션을 참고해 주세요.