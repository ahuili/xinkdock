#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#


ARG NODE_VERSION=${NODE_VERSION}

FROM node:${NODE_VERSION}

LABEL maintainer="Arthur Li <li_ahui@126.com>"

# RUN apk add --no-cache git \
#     && npm config set unsafe-perm true \
#     && npm install -g webpack \
#     && npm install -g bower \
#     && npm install -g cnpm --registry=https://registry.npm.taobao.org \
#     && rm -rf /var/cache/apk/* \
#     && rm -rf /tmp/* /usr/share/man


RUN apt-get update && apt-get install -y git \
    && npm install -g webpack \
    && npm install -g bower \
    && npm install -g cnpm --registry=https://registry.npm.taobao.org \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www

CMD [ "node" ]