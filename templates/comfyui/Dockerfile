FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive PYTHONUNBUFFERED=1 PIP_PREFER_BINARY=1 \
    COMFY_ROOT=/opt/ComfyUI ROOT=/workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    git wget curl unzip ca-certificates python3 python3-venv python3-pip ffmpeg libglib2.0-0 libgl1 \
 && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/comfyanonymous/ComfyUI.git ${COMFY_ROOT}

RUN python3 -m venv ${COMFY_ROOT}/venv && \
    . ${COMFY_ROOT}/venv/bin/activate && \
    pip install --upgrade pip wheel setuptools && \
    pip install -r ${COMFY_ROOT}/requirements.txt

COPY --chmod=755 ../../scripts/link-models.sh /usr/local/bin/link-models.sh
COPY --chmod=755 ./start.sh /start.sh

EXPOSE 8188
WORKDIR ${COMFY_ROOT}
ENV COMFY_ARGS="--listen 0.0.0.0 --port 8188 --enable-cors-header"
ENTRYPOINT ["/start.sh"]
