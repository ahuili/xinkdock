#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#


ARG PYTHON_VERSION=${PYTHON_VERSION}

FROM python:${PYTHON_VERSION}

LABEL maintainer="Arthur Li <li_ahui@126.com>"

COPY ./requirements.txt .

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt \
    && rm -rf requirements.txt \
    && rm -rf /var/lib/apt/lists/*

COPY ./start.sh /root/start.sh

# RUN usermod -u 1000 www-data

WORKDIR /var/www

EXPOSE 9090

CMD ["python3"]