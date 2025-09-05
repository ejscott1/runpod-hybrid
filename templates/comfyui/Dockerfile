FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_PREFER_BINARY=1 \
    COMFY_ROOT=/opt/ComfyUI \
    ROOT=/workspace

# System deps (similar set for reliability)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git git-lfs curl wget unzip ca-certificates \
    python3 python3-pip \
    build-essential pkg-config \
    ffmpeg libgl1 libglib2.0-0 \
    libjpeg-turbo8-dev zlib1g-dev libpng-dev \
 && rm -rf /var/lib/apt/lists/* && git lfs install

# ComfyUI core
RUN git clone --depth=1 https://github.com/comfyanonymous/ComfyUI.git ${COMFY_ROOT}

# Python deps:
# 1) Preinstall Torch CUDA 12.1 wheels
# 2) Strip any torch pins from Comfy requirements (rare, but safe)
# 3) Install remaining requirements
RUN pip install --no-cache-dir --upgrade pip wheel setuptools && \
    pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cu121 \
        torch torchvision torchaudio && \
    sed -i '/^torch/d;/^torchvision/d;/^torchaudio/d' ${COMFY_ROOT}/requirements.txt || true && \
    pip install --no-cache-dir -r ${COMFY_ROOT}/requirements.txt

# Link shared models on container start
COPY --chmod=755 scripts/link-models.sh /usr/local/bin/link-models.sh

# Start script
COPY --chmod=755 templates/comfyui/start.sh /start.sh

EXPOSE 8188
WORKDIR ${COMFY_ROOT}
ENV COMFY_ARGS="--listen 0.0.0.0 --port 8188 --enable-cors-header"
ENTRYPOINT ["/start.sh"]
