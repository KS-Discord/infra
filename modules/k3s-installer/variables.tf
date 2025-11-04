# infra/modules/k3s-installer/variables.tf

variable "master_ip" {
  description = "K3s 클러스터 마스터 노드의 공인/사설 IP 주소"
  type        = string
}

variable "ssh_private_key_path" {
  description = "마스터 노드 접속에 사용할 SSH 개인 키 파일 경로"
  type        = string
}

variable "server_user" {
  description = "K3s 설치 및 실행에 사용할 리눅스 사용자 이름"
  type        = string
}