# ----------------------------------------------------
# 1. Dashboard 핵심 컴포넌트 설치 (kubectl apply 자동화)
# ----------------------------------------------------
resource "null_resource" "install_dashboard_core" {
  # 이 모듈을 호출하는 environments/dev/main.tf에서
  # K3s 클러스터 모듈에 대한 depends_on을 설정해야 합니다.

  # Windows/WSL2 환경에서 kubectl이 설정되어 있음을 가정하고 로컬에서 실행
  provisioner "local-exec" {
    # Kubernetes Dashboard의 공식 recommended YAML을 다운로드 없이 직접 적용
    command = "kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml" # <--- 이 부분 수정
    # 이 명령은 설치되어 있지 않을 때만 설치하고, 이미 설치되어 있으면 아무 작업도 하지 않아 안전합니다.
  }
}
