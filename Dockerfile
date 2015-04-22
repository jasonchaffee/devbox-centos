FROM centos:7

MAINTAINER Jason Chaffee <jasonchaffee@gmail.com>

RUN yum update -y \
    && yum clean all \
    && yum install -y epel-release deltarpm \
    && yum install -y git git-svn subversion \
    && yum install -y colordiff postfix \
    && yum install -y gzip tar unzip \
    && yum install -y vim tumx xterm lynx \
    && yum install -y tigervnc-server

ENV JAVA_7 1.7.0
ENV JAVA_8 1.8.0
ENV JAVA_HOME_VERSION ${JAVA_7}
ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_HOME_VERSION}
ENV MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=512m -XX:+CMSClassUnloadingEnabled"
ENV SCALA_VERSION 2.11.6
ENV TYPESAFE_ACTIVATOR_VERSION 1.3.2
ENV USER_NAME John Doe
ENV USER_EMAIL jdoe@mycompany.com

RUN yum install -y java-${JAVA_7}-openjdk-devel \
    && yum install -y java-${JAVA_8}-openjdk-devel \
	&& curl -SL http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -o /etc/yum.repos.d/epel-apache-maven.repo \
	&& yum install -y apache-maven

RUN curl -SL https://bintray.com/sbt/rpm/rpm -o /etc/yum.repos.d/bintray-sbt-rpm.repo \
	&& yum install -y sbt \
	&& curl -SL http://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.rpm -o scala-${SCALA_VERSION}.rpm \
	&& yum install -y scala-${SCALA_VERSION}.rpm \
	&& curl -SL http://downloads.typesafe.com/typesafe-activator/${TYPESAFE_ACTIVATOR_VERSION}/typesafe-activator-${TYPESAFE_ACTIVATOR_VERSION}-minimal.zip -o typesafe-activator-${TYPESAFE_ACTIVATOR_VERSION}-minimal.zip \
	&& unzip typesafe-activator-${TYPESAFE_ACTIVATOR_VERSION}-minimal.zip -d /usr/local/ \
	&& ln -s /usr/local/activator-${TYPESAFE_ACTIVATOR_VERSION}-minimal /usr/local/typesafe-activator \
	&& ln -s /usr/local/typesafe-activator/activator /usr/local/bin/activator

COPY gitignore .gitignore
RUN mv .gitignore ~/.gitignore

COPY git-setup.sh git-setup.sh
RUN chmod a+x git-setup.sh

RUN mkdir -p ~/.vnc \
    && echo password | vncpasswd -f > ~/.vnc/passwd \
    && chmod 600 ~/.vnc/passwd

EXPOSE 5901

WORKDIR ~/

CMD /git-setup.sh && vncserver :1 -name vnc -geometry 800x640 && tail -f ~/.vnc/*:1.log
