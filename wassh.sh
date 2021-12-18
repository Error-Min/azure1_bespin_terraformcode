#! /bin/bash
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
systemctl disable --now firewalld
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime
cat > .vimrc << EOF
set paste
EOF
yum install -y wget mysql java-11-openjdk-devel.x86_64
cat >> /etc/profile << \END_HELP
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.13.0.8-1.el7_9.x86_64
export PATH=$PATH:$JAVA_HOME/bin
END_HELP
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
cat >> /etc/profile << \END_HELP
export MAVEN_HOME=/usr/local/maven
export PATH=$PATH:$HOME/bin:$MAVEN_HOME/bin
export TOMCAT_HOME=/usr/local/tomcat9
export RESOURCEGROUP_NAME=azure1-3tier-terraform
export MYSQL_SERVER_NAME=smterrordb
export MYSQL_SERVER_FULL_NAME=${MYSQL_SERVER_NAME}.mysql.database.azure.com
export MYSQL_SERVER_ADMIN_LOGIN_NAME=azureuser
export MYSQL_SERVER_ADMIN_PASSWORD=!Rlflqhdl21
export MYSQL_DATABASE_NAME=petclinic
export DOLLAR=\$
END_HELP
source /etc/profile
yum install -y git
cd /usr/local
git clone https://github.com/spring-petclinic/spring-framework-petclinic.git
cd spring-framework-petclinic
mvn package
cat > cargo.xml << \END_HELP
<plugin>
<groupId>org.codehaus.cargo</groupId>
<artifactId>cargo-maven3-plugin</artifactId>
<version>1.9.8</version>
<configuration>
<container>
<containerId>tomcat9x</containerId>
<type>installed</type>
<home>${TOMCAT_HOME}</home>
</container>
<configuration>
<type>existing</type>
<home>${TOMCAT_HOME}</home>
</configuration>
<deployables>
<deployable>
<groupId>${project.groupId}</groupId>
<artifactId>${project.artifactId}</artifactId>
<type>war</type>
<properties>
<context>/</context>
</properties>
</deployable>
</deployables>
</configuration>
</plugin>
END_HELP
sed -i '461r cargo.xml' pom.xml
rm -rf cargo.xml
mvn cargo:deploy
cd target
cp petclinic /usr/local/tomcat9/webapps/
cp petclinic.war /usr/local/tomcat9/webapps/
${TOMCAT_HOME}/bin/shutdown.sh
${TOMCAT_HOME}/bin/startup.sh