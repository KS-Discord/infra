# null_resource를 사용하여 K3s 설치 단계를 정의합니다.
resource "null_resource" "k3s_install" {
  # master_ip가 변경되면 설치 스크립트를 다시 실행하도록 설정 (선택 사항)
  triggers = {
    ip_address = var.master_ip
  }

  # SSH 접속 정보 및 설치 스크립트 실행
provisioner "remote-exec" {
    inline = [
        "echo 'K3s 설치 시작 (공식 스크립트 사용)'",
        "sudo curl -sfL https://get.k3s.io | sh -",
        "echo 'K3s 설치 완료'"
    ]    

    connection {
      type        = "ssh"
      user        = var.server_user
      host        = var.master_ip              # variables.tf에서 받은 IP 사용
      private_key = file(var.ssh_private_key_path)
      timeout     = "5m"
    }
  }
}

# Kubeconfig 파일을 로컬로 복사하는 로직
resource "null_resource" "get_kubeconfig" {
  depends_on = [null_resource.k3s_install] # 설치가 완료된 후 실행

  # 1. 원격에서 k3s.yaml 파일을 읽어 /tmp/kubeconfig로 복사
  provisioner "remote-exec" {
    inline = [
      "sudo cat /etc/rancher/k3s/k3s.yaml > /tmp/kubeconfig_raw",
      "sudo sed -i 's/127.0.0.1/${var.master_ip}/g' /tmp/kubeconfig_raw" # IP 주소를 127.0.0.1에서 실제 외부 IP로 변경
    ]
    connection {
      type        = "ssh"
      user        = var.server_user
      host        = var.master_ip
      private_key = file(var.ssh_private_key_path)
    }
  }

  # 2. 로컬로 파일을 복사 (scp 사용)
  provisioner "local-exec" {
    # ⭐️ 1. mkdir -p 명령을 추가하여 디렉토리가 없으면 생성합니다.
    command = <<EOT
      mkdir -p $(dirname ${var.kubeconfig_output_path})
      scp -i ${var.ssh_private_key_path} -o StrictHostKeyChecking=no ${var.server_user}@${var.master_ip}:/tmp/kubeconfig_raw ${var.kubeconfig_output_path}
    EOT
    interpreter = ["bash", "-c"] # 여러 줄 명령을 실행하기 위해 bash 사용을 명시합니다.
  }
}