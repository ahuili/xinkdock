#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#


ARG NODE_VERSION=${NODE_VERSION}

FROM node:${NODE_VERSION}-alpine

LABEL maintainer="Arthur Li <li_ahui@126.com>"

# If you're in China, or you need to change sources, will be set CHANGE_SOURCE to true in .env.

ARG CHANGE_SOURCE=false
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from dl-cdn.alpinelinux.org to aliyun source
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
;fi

RUN apk add --no-cache \
    autoconf \
    automake \
    bash \
    g++ \
    libc6-compat \
    libjpeg-turbo-dev \
    libpng-dev \
    make \
    nasm \
    git

RUN npm config set unsafe-perm true \
    && npm install -g webpack \
    && npm install -g bower \
    && npm install -g cnpm --registry=https://registry.npm.taobao.org \
    && git config --global url.https://github.com/.insteadOf git://github.com/ \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* /usr/share/man

WORKDIR /var/www

CMD [ "node" ]