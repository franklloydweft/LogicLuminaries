FROM node:20-bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-venv python3-dev build-essential default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt /app/requirements.txt
RUN python3 -m venv /opt/venv \
    && pip install --no-cache-dir -r /app/requirements.txt
WORKDIR /app/frontend
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci
WORKDIR /app
COPY local-ci.sh /usr/local/bin/local-ci
RUN chmod +x /usr/local/bin/local-ci
WORKDIR /app
ENTRYPOINT ["local-ci"]
