#!/bin/bash

dnf update -y

dnf install -y httpd git nodejs npm amazon-ssm-agent

systemctl enable httpd
systemctl start httpd

systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/instance-id)

AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/placement/availability-zone)

PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/local-ipv4)

git clone https://github.com/osamah-devops/project01-multi-cloud-cicd-pipeline.git /opt/app

cd /opt/app
rm -rf /backend
rm -rf /infra
cd /opt/app/frontend

npm install

npm run build

rm -rf /var/www/html/*

cp -r dist/frontend/browser/* /var/www/html/

systemctl restart httpd

