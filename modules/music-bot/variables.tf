variable "bot_name" {
  description = "뮤직 봇의 이름 (Deployment, Service 이름 등)"
  type        = string
}

variable "image_repository" {
  description = "뮤직 봇 Docker 이미지의 저장소 경로 (예: your-docker-registry/music-bot)"
  type        = string
}

variable "image_tag" {
  description = "뮤직 봇 Docker 이미지의 태그"
  type        = string
}

variable "discord_token" {
  description = "뮤직 봇 토큰"
  type        = string
  sensitive   = true
}
