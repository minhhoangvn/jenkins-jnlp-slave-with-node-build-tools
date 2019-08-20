ARG VERSION=3.29-2

FROM jenkins/slave:${VERSION}
ARG NODE_VERSION=10.16.3

ENV NVM_DIR=/usr/local/nvm \
  NODE=$NODE_VERSION

LABEL maintainer="hnminh@outlook.com"
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols with Node.JS build tools" Vendor="Jenkins project" Version="${VERSION}"
USER root
RUN rm /bin/sh && ln -s /bin/bash /bin/sh \
  && mkdir -p $NVM_DIR \
  && apt-get update \
  && apt-get -y upgrade \
  && apt-get -y install \
  build-essential \
  libssl-dev \
  curl \
  && rm -rf /var/lib/apt/lists/*

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
  && source $NVM_DIR/nvm.sh \
  && nvm install $NODE \
  && nvm alias default $NODE \
  && nvm use default 
ENV NODE_PATH=$NVM_DIR/v$NODE/lib/node_modules \
  PATH=$NVM_DIR/versions/node/v$NODE/bin:$PATH

COPY jenkins-slave /usr/local/bin/jenkins-slave
# ENTRYPOINT ["jenkins-slave"]
CMD echo 2 && tail -f /dev/null