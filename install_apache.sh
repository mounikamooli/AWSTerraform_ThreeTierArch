#! /bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "hello world from $(hostname -f)" | tee /var/www/html/index.html