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

# ⭐️ Secret을 먼저 생성하고, Service Account에 연결하도록 수정
resource "kubernetes_secret" "admin_user_token" {
  metadata {
    name      = "admin-user-token-secret"
    namespace = "kubernetes-dashboard"
    
    # ✅ 누락된 Annotation 추가: 이 Secret이 어떤 SA에 속하는지 명시합니다.
    annotations = {
      "kubernetes.io/service-account.name" = "admin-user" 
    }
  }
  type = "kubernetes.io/service-account-token"
}

# 2. Service Account 생성 (Secret 연결)
resource "kubernetes_service_account" "admin_user" {
  depends_on = [null_resource.install_dashboard_core]
  metadata {
    name      = "admin-user"
    namespace = "kubernetes-dashboard"
  }
  # ⭐️ 생성한 Secret을 Service Account에 명시적으로 연결
  secret {
    name = kubernetes_secret.admin_user_token.metadata[0].name
  }
}

# 2. ClusterRoleBinding (admin-user에게 cluster-admin 권한 부여)
resource "kubernetes_cluster_role_binding" "admin_user_binding" {
  metadata {
    name = "admin-user-dashboard-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.admin_user.metadata[0].name
    namespace = kubernetes_service_account.admin_user.metadata[0].namespace
  }
}
# Secret에서 토큰 데이터 조회
data "kubernetes_secret" "admin_user_token" {
  depends_on = [
    kubernetes_secret.admin_user_token,
    kubernetes_service_account.admin_user,
    kubernetes_cluster_role_binding.admin_user_binding
  ]

  metadata {
    name      = kubernetes_secret.admin_user_token.metadata[0].name
    namespace = "kubernetes-dashboard"
  }
}