#!/bin/bash
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
systemctl disable --now firewalld
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime
cat > .vimrc << EOF
set paste
EOF
yum install -y wget mysql java-11-openjdk-devel.x86_64
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.13.0.8-1.el7_9.x86_64' >> /etc/profile
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile
source /etc/profile
wget http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.54/bin/apache-tomcat-9.0.54.tar.gz
tar zxvf apache-tomcat-9.0.54.tar.gz
rm -rf apache-tomcat-9.0.54.tar.gz
mv apache-tomcat-9.0.54 /usr/local/tomcat9
sed -i '116 s/<!--/ /g' /usr/local/tomcat9/conf/server.xml
sed -i '118 s/"::1"/"0.0.0.0"/g' /usr/local/tomcat9/conf/server.xml
sed -i '/port="8009"/a secretRequired="false"' /usr/local/tomcat9/conf/server.xml
sed -i '/<\/tomcat-users>/i <role rolename="admin-gui"\/>' /usr/local/tomcat9/conf/tomcat-users.xml
sed -i '/<\/tomcat-users>/i <role rolename="admin-script"\/>' /usr/local/tomcat9/conf/tomcat-users.xml
sed -i '/<\/tomcat-users>/i <role rolename="manager-gui"\/>' /usr/local/tomcat9/conf/tomcat-users.xml
sed -i '/<\/tomcat-users>/i <role rolename="manager-script"\/>' /usr/local/tomcat9/conf/tomcat-users.xml
sed -i '/<\/tomcat-users>/i <role rolename="manager-jmx"\/>' /usr/local/tomcat9/conf/tomcat-users.xml
sed -i '/<\/tomcat-users>/i <role rolename="manager-status"\/>' /usr/local/tomcat9/conf/tomcat-users.xml
sed -i '/<\/tomcat-users>/i <user username="admin" password="admin" roles="admin-gui,admin-script,manager-gui,manager-script,manager-jmx,manager-status" \/>' /usr/local/tomcat9/conf/tomcat-users.xml
sed -i '19 i\<!--' /usr/local/tomcat9/webapps/manager/META-INF/context.xml
sed -i '24 i\-->' /usr/local/tomcat9/webapps/manager/META-INF/context.xml
sed -i '19 i\<!--' /usr/local/tomcat9/webapps/host-manager/META-INF/context.xml
sed -i '24 i\-->' /usr/local/tomcat9/webapps/host-manager/META-INF/context.xml
cd /usr/local/tomcat9/bin
./startup.sh
cd /usr/local
wget http://mirror.apache-kr.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar zxvf apache-maven-3.6.3-bin.tar.gz
rm -rf apache-maven-3.6.3-bin.tar.gz
ln -s apache-maven-3.6.3 maven
vim /etc/profile
echo 'export MAVEN_HOME=/usr/local/maven' >> /etc/profile
echo 'export PATH=$PATH:$HOME/bin:$MAVEN_HOME/bin' >> /etc/profile
source /etc/profile
mvn -v