FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive PYTHONUNBUFFERED=1 PIP_PREFER_BINARY=1 \
    A1111_DATA=/opt/webui ROOT=/workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    git wget curl unzip ca-certificates python3 python3-venv python3-pip ffmpeg libglib2.0-0 libgl1 \
 && rm -rf /var/lib/apt/lists/*

# Stable Diffusion Forge
RUN git clone --depth=1 https://github.com/lllyasviel/stable-diffusion-webui-forge.git ${A1111_DATA}

# Python venv + deps
RUN python3 -m venv ${A1111_DATA}/venv && \
    . ${A1111_DATA}/venv/bin/activate && \
    pip install --upgrade pip wheel setuptools && \
    (pip install -r ${A1111_DATA}/requirements_versions.txt || true) && \
    pip install -r ${A1111_DATA}/requirements.txt

# Link shared models on container start (from repo root via build context '.')
COPY --chmod=755 scripts/link-models.sh /usr/local/bin/link-models.sh

# Start script
COPY --chmod=755 templates/forge/start.sh /start.sh

EXPOSE 7860
WORKDIR ${A1111_DATA}
ENV WEBUI_ARGS="--listen --api --xformers --enable-insecure-extension-access --no-half-vae"
ENTRYPOINT ["/start.sh"]
