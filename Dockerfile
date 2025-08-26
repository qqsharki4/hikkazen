FROM python:3.10-slim

ENV DOCKER=true \
    SHARKHOST=true \
    GIT_PYTHON_REFRESH=quiet \
    PIP_NO_CACHE_DIR=1

RUN apt update && \
    apt install -y --no-install-recommends \
        curl libcairo2 git ffmpeg \
        libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libavdevice-dev \
        gcc python3-dev gnupg2 ca-certificates

RUN curl -fsSL https://repo.nloveuser.ru/debian/repo.key | gpg --dearmor -o /usr/share/keyrings/nloveuser-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nloveuser-archive-keyring.gpg] https://repo.nloveuser.ru/debian trixie main" \
        > /etc/apt/sources.list.d/nloveuser.list && apt update && apt install fastfetch -y
        
RUN mkdir /deb && cd /deb && curl -LO https://repo.nloveuser.ru/debian/pool/main/n/neofetch/neofetch-dev-amd64.deb && dpkg -i *.deb && apt install -f -y && apt update -y

RUN rm -rf /deb

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

RUN rm -rf /var/lib/apt/lists /var/cache/apt/archives /tmp/*

RUN git clone https://github.com/qqsharki4/Hikka /Hikka

WORKDIR /Hikka

RUN pip install --no-warn-script-location --no-cache-dir -r requirements.txt

EXPOSE 8080

RUN mkdir /data

CMD ["python3", "-m", "hikka"]
