FROM centos:7

#RUN yum groupinstall -y "Console Internet Tools"
#RUN yum groupinstall -y "GNOME Desktop"
#RUN yum groupinstall -y "Graphical Administration Tools"

RUN yum update -y \
    && yum install -y epel-release \
    && yum install -y git \
    && yum install -y git-svn \
    && yum install -y subversion \
    && yum install -y colordiff \
    && yum install -y postfix \
    && yum install -y gzip \
    && yum install -y tar \
    && yum install -y unzip \
    && yum install -y vim \
    && yum install -y tmux \
    && yum install -y lynx \
    && yum install -y xterm \
    && yum install -y tigervnc-server

ENV JAVA_7 1.7.0
ENV JAVA_8 1.8.0
ENV JAVA_HOME_VERSION ${JAVA_7}

RUN yum install -y java-${JAVA_7}-openjdk-devel \
    && yum install -y java-${JAVA_8}-openjdk-devel \
	&& curl -SL http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -o /etc/yum.repos.d/epel-apache-maven.repo \
	&& yum install -y apache-maven

ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_HOME_VERSION}

ENV MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=512m -XX:+CMSClassUnloadingEnabled"

ENV SCALA_VERSION 2.11.6
ENV TYPESAFE_ACTIVATOR_VERSION 1.3.2

RUN curl -SL https://bintray.com/sbt/rpm/rpm -o /etc/yum.repos.d/bintray-sbt-rpm.repo \
	&& yum install -y sbt \
	&& curl -SL http://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.rpm -o scala-${SCALA_VERSION}.rpm \
	&& yum install -y scala-${SCALA_VERSION}.rpm \
	&& curl -SL http://downloads.typesafe.com/typesafe-activator/${TYPESAFE_ACTIVATOR_VERSION}/typesafe-activator-${TYPESAFE_ACTIVATOR_VERSION}-minimal.zip -o typesafe-activator-${TYPESAFE_ACTIVATOR_VERSION}-minimal.zip \
	&& unzip typesafe-activator-${TYPESAFE_ACTIVATOR_VERSION}-minimal.zip -d /usr/local/ \
	&& ln -s /usr/local/activator-${TYPESAFE_ACTIVATOR_VERSION}-minimal /usr/local/typesafe-activator \
	&& ln -s /usr/local/typesafe-activator/activator /usr/local/bin/activator


COPY .gitignore .gitignore
RUN cp .gitignore ~/.gitignore

ENV USER_NAME John Doe
ENV USER_EMAIL jdoe@sunverge.com

RUN git config --global core.editor vim \
    && git config --global core.excludesfile ~/.gitignore \
    && git config --global color.ui true \
    && git config --global user.name "${USER_NAME}" \
    && git config --global user.email ${USER_EMAIL}

#ENV WORK_DIR /opt/dev
#ENV USER_NAME dev
#RUN useradd -ms /bin/bash ${USER_NAME} && echo "${USER_NAME}:${USER_NAME}" | chpasswd && adduser ${USER_NAME} sudo
#USER ${USER_NAME}
#WORKDIR /home/${USER_NAME}

RUN mkdir -p ~/.vnc \
    && echo password | vncpasswd -f > ~/.vnc/passwd \
    && chmod 600 ~/.vnc/passwd

EXPOSE 5901

WORKDIR ~/

CMD vncserver :1 -name vnc -geometry 800x640 && tail -f ~/.vnc/*:1.log

#CMD bash
