FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_PREFER_BINARY=1 \
    A1111_DATA=/opt/webui \
    ROOT=/workspace

# System deps (add build tools for some pip wheels)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git git-lfs curl wget unzip ca-certificates \
    python3 python3-pip \
    build-essential pkg-config \
    ffmpeg libgl1 libglib2.0-0 \
    libjpeg-turbo8-dev zlib1g-dev libpng-dev \
 && rm -rf /var/lib/apt/lists/* && git lfs install

# Clone Stable Diffusion Forge
RUN git clone --depth=1 https://github.com/lllyasviel/stable-diffusion-webui-forge.git ${A1111_DATA}

# Python deps:
# 1) Preinstall Torch CUDA 12.1 wheels
# 2) Strip any torch/torchvision/torchaudio pins from Forge requirements
# 3) Install everything else
RUN pip install --no-cache-dir --upgrade pip wheel setuptools && \
    pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cu121 \
        torch torchvision torchaudio && \
    sed -i '/^torch/d;/^torchvision/d;/^torchaudio/d' ${A1111_DATA}/requirements_versions.txt || true && \
    sed -i '/^torch/d;/^torchvision/d;/^torchaudio/d' ${A1111_DATA}/requirements.txt || true && \
    (pip install --no-cache-dir -r ${A1111_DATA}/requirements_versions.txt || true) && \
    pip install --no-cache-dir -r ${A1111_DATA}/requirements.txt

# Optional: xformers often lacks ready wheels for some CUDA/Python combos; keep best-effort
RUN (pip install --no-cache-dir xformers || true)

# Link shared models on container start
COPY --chmod=755 scripts/link-models.sh /usr/local/bin/link-models.sh

# Start script
COPY --chmod=755 templates/forge/start.sh /start.sh

EXPOSE 7860
WORKDIR ${A1111_DATA}
ENV WEBUI_ARGS="--listen --api --enable-insecure-extension-access --no-half-vae"
ENTRYPOINT ["/start.sh"]
