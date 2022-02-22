
FROM node:16.10.0-alpine3.14

RUN \
  apk add \
    tidyhtml \
    tidyhtml-dev \
  && \
  npm config set prefix ~/.local && \
  npm config set unsafe-perm true && \
  npm install -g npm@latest

ENV HOME=/root
ENV PATH=$HOME/.local/bin:$PATH

ARG PACKAGE_DIR=/opt/site

WORKDIR $PACKAGE_DIR

COPY eleventy.sh package.json package-lock.json ./

RUN \
  chmod a+rx eleventy.sh && \
  npm install && \
  npm link

WORKDIR /app
