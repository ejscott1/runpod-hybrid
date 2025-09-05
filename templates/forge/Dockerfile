FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_PREFER_BINARY=1 \
    A1111_DATA=/opt/webui \
    ROOT=/workspace

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    git git-lfs curl wget unzip ca-certificates \
    python3 python3-pip \
    build-essential pkg-config \
    ffmpeg libgl1 libglib2.0-0 \
    libjpeg-turbo8-dev zlib1g-dev libpng-dev \
 && rm -rf /var/lib/apt/lists/* && git lfs install

# Clone Stable Diffusion Forge
RUN git clone --depth=1 https://github.com/lllyasviel/stable-diffusion-webui-forge.git ${A1111_DATA}

# Python deps
RUN pip install --no-cache-dir --upgrade pip wheel setuptools && \
    pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cu121 \
        torch torchvision torchaudio

# Strip torch pins from Forge’s requirements (in case they exist)
RUN sed -i '/^torch/d;/^torchvision/d;/^torchaudio/d' ${A1111_DATA}/requirements_versions.txt || true && \
    sed -i '/^torch/d;/^torchvision/d;/^torchaudio/d' ${A1111_DATA}/requirements.txt || true

# Install dependencies in two stages:
# 1) Try to install version-pinned requirements (best effort).
# 2) Then install main requirements, ignoring failures (so build doesn’t crash).
RUN (pip install --no-cache-dir -r ${A1111_DATA}/requirements_versions.txt || true) && \
    (pip install --no-cache-dir -r ${A1111_DATA}/requirements.txt || true)

# Add optional extras separately (don’t fail build if unavailable)
RUN pip install --no-cache-dir --upgrade gradio accelerate transformers safetensors || true
RUN pip install --no-cache-dir xformers==0.0.22.post7 || true

# Link shared models on container start
COPY --chmod=755 scripts/link-models.sh /usr/local/bin/link-models.sh

# Start script
COPY --chmod=755 templates/forge/start.sh /start.sh

EXPOSE 7860
WORKDIR ${A1111_DATA}
ENV WEBUI_ARGS="--listen --api --enable-insecure-extension-access --no-half-vae"
ENTRYPOINT ["/start.sh"]
