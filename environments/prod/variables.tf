variable "ssh_private_key_path" {
  description = "VM 접속을 위한 SSH Private Key 파일 경로입니다."
  type        = string
  default     = "~/.ssh/prod_id_rsa" # Prod 환경 전용 키를 가정합니다.
}

variable "discord_bot_image_tag" {
  description = "프로덕션에 배포할 디스코드 봇 Docker 이미지의 안정 버전 태그입니다."
  type        = string
}