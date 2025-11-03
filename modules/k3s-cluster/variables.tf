variable "master_ip" {
  description = "K3s 마스터 노드가 될 대상 서버의 IP 주소입니다."
  type        = string
}

variable "server_user" {
  description = "VM에 SSH 접속할 때 사용할 사용자 이름입니다. (예: ubuntu)"
  type        = string
}

variable "ssh_private_key_path" {
  description = "VM 접속을 위한 SSH Private Key 파일 경로입니다."
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "kubeconfig_output_path" {
  description = "Kubeconfig 파일을 저장할 로컬 경로입니다."
  type        = string
  default     = "~/.kube/k3s-config.yaml"
}
