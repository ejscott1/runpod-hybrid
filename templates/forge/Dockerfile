FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_PREFER_BINARY=1 \
    A1111_DATA=/opt/webui \
    ROOT=/workspace

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    git wget curl unzip ca-certificates python3 python3-pip ffmpeg libglib2.0-0 libgl1 \
 && rm -rf /var/lib/apt/lists/*

# Clone Stable Diffusion Forge
RUN git clone --depth=1 https://github.com/lllyasviel/stable-diffusion-webui-forge.git ${A1111_DATA}

# Python deps (system Python). Install Torch first with CUDA 12.1 wheels.
RUN pip install --upgrade pip wheel setuptools && \
    pip install --index-url https://download.pytorch.org/whl/cu121 \
        torch torchvision torchaudio

# Install the rest of Forge’s requirements, but ignore torch if it appears
RUN sed -i '/torch/d' ${A1111_DATA}/requirements_versions.txt || true && \
    sed -i '/torch/d' ${A1111_DATA}/requirements.txt || true && \
    (pip install -r ${A1111_DATA}/requirements_versions.txt || true) && \
    pip install -r ${A1111_DATA}/requirements.txt && \
    (pip install xformers || true)

# Link shared models on container start
COPY --chmod=755 scripts/link-models.sh /usr/local/bin/link-models.sh

# Start script
COPY --chmod=755 templates/forge/start.sh /start.sh

EXPOSE 7860
WORKDIR ${A1111_DATA}
ENV WEBUI_ARGS="--listen --api --xformers --enable-insecure-extension-access --no-half-vae"
ENTRYPOINT ["/start.sh"]
