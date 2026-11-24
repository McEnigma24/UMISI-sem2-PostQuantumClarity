# syntax=docker/dockerfile:1
#
# Obraz = SageMath 10.8 (Python 3.12) + uv. Pakiety Jupyter = uv w /workspace/build/.
# Cały repo: bind-mount .:/workspace
#
# Build:  docker compose --env-file _config_/config.env build
# Sync:    ./scripts/drun sync
# Shell:   ./shell.sh

FROM ghcr.io/astral-sh/uv:0.6.14 AS uv-bin

FROM sagemath/sagemath:10.8

ARG DEBIAN_FRONTEND=noninteractive

USER root

ENV SAGE_VENV=/home/sage/sage/local/var/lib/sage/venv-python3.12.5 \
    JUPYTER_PATH=/home/sage/sage/local/var/lib/sage/venv-python3.12.5/share/jupyter \
    TZ=Europe/Warsaw

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/workspace/src \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=automatic \
    UV_CACHE_DIR=/workspace/build/uv-cache \
    UV_PYTHON_INSTALL_DIR=/workspace/build/python \
    UV_PROJECT_ENVIRONMENT=/workspace/build/venv \
    PATH="/workspace/bin:/workspace/build/venv/bin:${SAGE_VENV}/bin:/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Narzędzia dev (Sage jest już w obrazie bazowym)
RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    xauth \
    xvfb \
    openssh-client \
    vim \
    less \
    htop \
 && ln -snf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime \
 && echo "Europe/Warsaw" > /etc/timezone \
 && rm -rf /var/lib/apt/lists/*

COPY --from=uv-bin /uv /usr/local/bin/uv

WORKDIR /workspace

CMD ["bash"]
