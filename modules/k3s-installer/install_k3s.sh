#!/bin/bash

# Terraform 변수 사용을 위해 쉘 변수로 설정
SERVER_USER="$1"

echo "K3s 설치 준비 및 사용자 확인"

# 1. 사용자 생성: 사용자가 없다면 비밀번호 없이 사용자 생성
if ! id -u ${SERVER_USER} > /dev/null 2>&1; then 
    sudo useradd -m ${SERVER_USER}
    echo "사용자 ${SERVER_USER} 생성 완료"
fi

# 2. K3s 설치 시작 (비루트 실행 사용자 설정)
echo "K3s 설치 시작"

# K3S_SERVICE_USER 환경 변수를 전달하여 서비스 실행 계정 지정
# 설치는 sudo로 진행되나, 서비스는 ${SERVER_USER}로 실행됨.
sudo K3S_SERVICE_USER=${SERVER_USER} curl -sfL https://get.k3s.io | sh -

echo "K3s 설치 완료"