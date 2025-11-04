# infra/modules/k3s-installer/main.tf

# 1. K3s 설치 및 사용자 생성 (스크립트 실행)
resource "null_resource" "k3s_install" {
  triggers = {
    ip_address = var.master_ip
  }

  provisioner "remote-exec" {
    # 외부 설치 스크립트 파일 경로를 지정하고, 사용자 이름을 인수로 전달
    script = "${path.module}/install_k3s.sh"
    connection {
      type        = "ssh"
      user        = var.server_user
      host        = var.master_ip
      private_key = file(var.ssh_private_key_path)
      timeout     = "5m"
    }
  }
}

# 2. 설치 완료 후 kubeconfig 파일 가져오기
# K3s는 kubeconfig 파일을 /etc/rancher/k3s/k3s.yaml에 root 권한으로 생성합니다.
data "remote_file" "k3s_kubeconfig" {
  depends_on = [null_resource.k3s_install]

  connection {
    type        = "ssh"
    user        = var.server_user
    host        = var.master_ip
    private_key = file(var.ssh_private_key_path)
    timeout     = "30s"
  }

  # kubeconfig 파일을 획득하는 쉘 명령을 실행하고 그 결과를 읽어옵니다.
  # sudo cat으로 파일을 읽어와 표준 출력으로 내보냅니다.
  command = "sudo cat /etc/rancher/k3s/k3s.yaml"
}
