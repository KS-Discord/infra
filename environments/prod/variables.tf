variable "target" {
  description = "K3s 설치 대상 서버"
  type = object({
    host = string
  })
}

variable "ssh" {
  description = "SSH 접속 설정 (관리자 계정)"
  type = object({
    user        = string
    private_key = string
  })
  default = {
    user        = "admin"
    private_key = "~/.ssh/id_rsa"
  }
}

variable "k3s_user" {
  description = "K3s 운영 전용 계정"
  type = object({
    name = string
    uid  = number
    gid  = number
  })
  default = {
    name = "k3s"
    uid  = 2000
    gid  = 2000
  }
}