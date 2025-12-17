#!/bin/bash

# 1. 패키지 리포지토리 업데이트 (권장)
dnf update -y

# 2. Apache 설치
dnf install -y httpd

# 3. HTML 파일 생성
# (폴더가 없을 경우를 대비해 -p 옵션 사용 권장, 보통은 이미 있음)
mkdir -p /var/www/html
cat <<EOF > /var/www/html/index.html
<h1>db IP: ${dbaddress}</h1>
<h1>db Port: ${dbport}</h1>
<h1>db Name: ${dbname}</h1>
EOF

# 4. 서비스 시작 및 활성화
systemctl start httpd
systemctl enable httpd