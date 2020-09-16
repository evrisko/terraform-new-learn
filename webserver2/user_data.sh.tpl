#!/bin/bash
echo "----------START--------------------"
yum update -y
yum install -y httpd

EC2_AVAIL_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PrivateIP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Terraform with external user_data file</h2>
Availability-zone: $EC2_AVAIL_ZONE<br>
Hostname: $(hostname -f)<br>
PrivateIP: $PrivateIP"<br>
<h3>Owner <font color="blue">${first_name} ${last_name}</font></h3>

%{ for x in clubs ~}
The champion ${x} because ${first_name} say<br>
%{ endfor ~}
</html>

EOF
systemctl start httpd.service
systemctl enable httpd.service
echo "----------FINISH-------------------"
