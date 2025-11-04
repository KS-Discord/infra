# 유저 생성
resource "null_resource" "create_user" {
  triggers = {
    username = var.username
    uid      = var.uid
    gid      = var.gid
  }

  connection {
    type        = "ssh"
    host        = var.connection.host
    user        = var.connection.user
    private_key = var.connection.private_key
  }

  provisioner "remote-exec" {
    inline = [
      # 그룹 생성 (이미 있으면 무시)
      "sudo groupadd -g ${var.gid} ${var.username} 2>/dev/null || true",
      # 유저 생성 (이미 있으면 무시)
      "sudo useradd -u ${var.uid} -g ${var.gid} -m -s /bin/bash ${var.username} 2>/dev/null || true",
      # 생성 여부 확인 (uid/gid 검증)
      "id -u ${var.username} | grep -q '^${var.uid}$' || (echo 'User creation failed: UID mismatch' && exit 1)",
      "id -g ${var.username} | grep -q '^${var.gid}$' || (echo 'User creation failed: GID mismatch' && exit 1)",
      "echo 'User ${var.username} (${var.uid}:${var.gid}) verified successfully'"
    ]
  }
}
