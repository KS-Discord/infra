# # 1. 봇 토큰과 추가 Secret을 저장하는 Secret 생성
# resource "kubernetes_secret" "music_bot_secret" {
#   metadata {
#     name = "${var.bot_name}-secret" # 봇 이름으로 Secret 이름 지정
#   }
#   data = {
#     "DISCORD_TOKEN" = base64encode(var.discord_token)
#   }
#   type = "Opaque" # 일반적인 key-value Secret
# }

# # 2. 뮤직 봇 Deployment 생성
# resource "kubernetes_deployment" "music_bot_deployment" {
#   metadata {
#     name = var.bot_name
#     labels = {
#       app = var.bot_name
#     }
#   }
#   spec {
#     selector {
#       match_labels = {
#         app = var.bot_name
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = var.bot_name
#         }
#       }
#       spec {
#         container {
#           name  = var.bot_name
#           image = "${var.image_repository}:${var.image_tag}"
          
#           # Secret에서 토큰을 환경 변수로 주입
#           env {
#             name = "DISCORD_TOKEN"
#             value_from {
#               secret_key_ref {
#                 name = kubernetes_secret.music_bot_secret.metadata[0].name
#                 key  = "DISCORD_TOKEN"
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

# # (선택 사항) 만약 봇이 외부에서 접근해야 하는 HTTP/WebSocket 서비스라면 Service를 추가
# # resource "kubernetes_service" "music_bot_service" {
# #   metadata {
# #     name = "${var.bot_name}-service"
# #   }
# #   spec {
# #     selector = {
# #       app = var.bot_name
# #     }
# #     port {
# #       protocol = "TCP"
# #       port     = 80
# #       target_port = 8080 # 봇 컨테이너의 포트
# #     }
# #     type = "ClusterIP" # 외부 노출 필요 없으면 ClusterIP
# #   }
# # }