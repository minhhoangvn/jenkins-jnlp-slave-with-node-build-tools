ARG VERSION=3.29-2

FROM jenkins/slave:${VERSION}
ARG NODE_VERSION=10.16.3

ENV NVM_DIR=/home/jenkins/nvm \
  NODE=$NODE_VERSION

LABEL maintainer="hnminh@outlook.com"
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols with Node.JS build tools" Vendor="Jenkins project" Version="${VERSION}"
USER root
COPY jenkins-slave /usr/local/bin/jenkins-slave
RUN rm /bin/sh && ln -s /bin/bash /bin/sh \
  && apt-get update \
  && apt-get -y upgrade \
  && apt-get -y install \
  build-essential \
  libssl-dev \
  curl \
  && rm -rf /var/lib/apt/lists/* \
  && chmod +x /usr/local/bin/jenkins-slave

USER jenkins
RUN mkdir -p $NVM_DIR  \
  && curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
  && source $NVM_DIR/nvm.sh \
  && nvm install $NODE \
  && nvm alias default $NODE \
  && nvm use default 
ENV NODE_PATH=$NVM_DIR/v$NODE/lib/node_modules \
  PATH=$NVM_DIR/versions/node/v$NODE/bin:$PATH

ENTRYPOINT ["jenkins-slave"]