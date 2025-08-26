FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    AIOHTTP_NO_EXTENSIONS=1 \
    DOCKER=true \
    GIT_PYTHON_REFRESH=quiet

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        build-essential \
        curl \
        ffmpeg \
        gcc \
        git \
        libavcodec-dev \
        libavdevice-dev \
        libavformat-dev \
        libavutil-dev \
        libcairo2 \
        libmagic1 \
        libswscale-dev \
        openssl \
        openssh-server && \
    curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/ /tmp/*

WORKDIR /data/Hikka

COPY . /data/Hikka

RUN pip install --no-warn-script-location --no-cache-dir -U -r requirements.txt
RUN pip install --no-cache-dir .

EXPOSE 8080
CMD ["python", "-m", "hikka"]
