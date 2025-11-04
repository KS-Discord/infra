
# ⭐️ Secret을 먼저 생성하고, Service Account에 연결하도록 수정
resource "kubernetes_secret" "admin_user_token" {
  metadata {
    name      = "admin-user-token-secret"

    # ✅ 누락된 Annotation 추가: 이 Secret이 어떤 SA에 속하는지 명시합니다.
    annotations = {
      "kubernetes.io/service-account.name" = "admin-user"
    }
  }
  type = "kubernetes.io/service-account-token"
}

# 2. Service Account 생성 (Secret 연결)
resource "kubernetes_service_account" "admin_user" {
  depends_on = [kubernetes_secret.admin_user_token]
  metadata {
    name      = "admin-user"
  }
  # ⭐️ 생성한 Secret을 Service Account에 명시적으로 연결
  secret {
    name = kubernetes_secret.admin_user_token.metadata[0].name
  }
}

# 2. ClusterRoleBinding (admin-user에게 cluster-admin 권한 부여)
resource "kubernetes_cluster_role_binding" "admin_user_binding" {
  depends_on = [kubernetes_service_account.admin_user]

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
  depends_on = [kubernetes_cluster_role_binding.admin_user_binding]

  metadata {
    name      = kubernetes_secret.admin_user_token.metadata[0].name
    namespace = "kubernetes-dashboard"
  }
}
