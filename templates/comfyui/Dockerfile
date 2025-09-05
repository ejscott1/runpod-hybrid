FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_PREFER_BINARY=1 \
    COMFY_ROOT=/opt/ComfyUI \
    ROOT=/workspace

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    git wget curl unzip ca-certificates python3 python3-pip ffmpeg libglib2.0-0 libgl1 \
 && rm -rf /var/lib/apt/lists/*

# ComfyUI core
RUN git clone --depth=1 https://github.com/comfyanonymous/ComfyUI.git ${COMFY_ROOT}

# Python deps (system Python; pin torch to CUDA 12.1 wheels)
RUN pip install --upgrade pip wheel setuptools && \
    pip install --index-url https://download.pytorch.org/whl/cu121 \
        torch torchvision torchaudio && \
    pip install -r ${COMFY_ROOT}/requirements.txt

# Link shared models on container start (comes from repo root because build context is '.')
COPY --chmod=755 scripts/link-models.sh /usr/local/bin/link-models.sh

# Start script
COPY --chmod=755 templates/comfyui/start.sh /start.sh

EXPOSE 8188
WORKDIR ${COMFY_ROOT}
ENV COMFY_ARGS="--listen 0.0.0.0 --port 8188 --enable-cors-header"
ENTRYPOINT ["/start.sh"]
