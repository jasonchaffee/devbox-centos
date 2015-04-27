FROM centos:7

MAINTAINER Jason Chaffee <jasonchaffee@gmail.com>

RUN yum update -y \
    && yum clean all \
    && yum install -y epel-release deltarpm \
    && yum clean all \
    && yum install -y git git-svn subversion colordiff gzip tar unzip vim tumx xterm zsh firefox lynx wget tigervnc-server \
    && yum clean all

ENV DOCKER_VERSION 1.6.0
ENV DOCKER_COMPOSE_VERSION 1.2.0
ENV DOCKER_MACHINE_VERSION v0.2.0

ENV JAVA_7 1.7.0
ENV JAVA_8 1.8.0
ENV JAVA_HOME_VERSION ${JAVA_7}

ENV SCALA_VERSION 2.11.6
ENV TYPESAFE_ACTIVATOR_VERSION 1.3.2

ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_HOME_VERSION}

ENV MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=512m -XX:+CMSClassUnloadingEnabled"
ENV SBT_OPTS="-Xmx512m -XX:+CMSClassUnloadingEnabled -Dsbt.override.build.repos=false -Dsbt.jse.engineType=Node"

RUN curl -SL http://cbs.centos.org/kojifiles/packages/docker/${DOCKER_VERSION}/0.3.rc7.el7/x86_64/docker-${DOCKER_VERSION}-0.3.rc7.el7.x86_64.rpm -o docker-${DOCKER_VERSION}-0.3.rc7.el7.x86_64.rpm \
    && yum localinstall -y docker-${DOCKER_VERSION}-0.3.rc7.el7.x86_64.rpm \
    && yum upgrade -y device-mapper-event-libs \
    && yum clean all \
    && rm docker-${DOCKER_VERSION}-0.3.rc7.el7.x86_64.rpm

RUN curl -SL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && curl -SL https://raw.githubusercontent.com/docker/compose/${DOCKER_COMPOSE_VERSION}/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

RUN curl -SL https://github.com/docker/machine/releases/download/${DOCKER_MACHINE_VERSION}/docker-machine_linux-amd64 -o /usr/local/bin/docker-machine \
    && chmod +x /usr/local/bin/docker-machine

RUN yum install -y java-${JAVA_7}-openjdk-devel \
    && yum install -y java-${JAVA_8}-openjdk-devel \
	&& curl -SL http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -o /etc/yum.repos.d/epel-apache-maven.repo \
	&& yum install -y apache-maven \
	&& yum clean all

RUN curl -SL https://bintray.com/sbt/rpm/rpm -o /etc/yum.repos.d/bintray-sbt-rpm.repo \
	&& yum install -y sbt \
	&& curl -SL http://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.rpm -o scala-${SCALA_VERSION}.rpm \
	&& yum install -y scala-${SCALA_VERSION}.rpm \
	&& yum clean all \
	&& curl -SL http://downloads.typesafe.com/typesafe-activator/${TYPESAFE_ACTIVATOR_VERSION}/typesafe-activator-${TYPESAFE_ACTIVATOR_VERSION}-minimal.zip -o typesafe-activator-${TYPESAFE_ACTIVATOR_VERSION}-minimal.zip \
	&& unzip typesafe-activator-${TYPESAFE_ACTIVATOR_VERSION}-minimal.zip -d /usr/local/ \
	&& ln -s /usr/local/activator-${TYPESAFE_ACTIVATOR_VERSION}-minimal /usr/local/typesafe-activator \
	&& ln -s /usr/local/typesafe-activator/activator /usr/local/bin/activator

RUN git clone https://github.com/jasonchaffee/devbox-config.git .devbox-config

RUN .devbox-config/config install

RUN chsh -s $(which zsh)

COPY gitignore .gitignore
RUN mv .gitignore ~/.gitignore

COPY setup.sh setup.sh
RUN chmod +x setup.sh

COPY xstartup xstartup
RUN chmod +x xstartup

RUN mkdir -p ~/.vnc \
    && mv xstartup ~/.vnc/xstartup \
    && echo password | vncpasswd -f > ~/.vnc/passwd \
    && chmod 600 ~/.vnc/passwd

EXPOSE 5901

CMD /setup.sh && vncserver :1 -name vnc && tail -f ~/.vnc/*:1.log
