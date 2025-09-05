#!/usr/bin/env bash
set -euo pipefail
ROOT="/workspace"
mkdir -p "$ROOT/models"/{checkpoints,lora,vae,controlnet,clip,ipadapter} \
         "$ROOT/inputs"/{persona_refs,base_edits,video_frames} \
         "$ROOT/outputs"/{forge,comfy,postprocessed} \
         "$ROOT/configs"

# Forge paths
A1111_DATA="${A1111_DATA:-/opt/webui}"
mkdir -p "$A1111_DATA/models"
ln -sf "$ROOT/models/checkpoints"  "$A1111_DATA/models/Stable-diffusion"
ln -sf "$ROOT/models/lora"         "$A1111_DATA/models/Lora"
ln -sf "$ROOT/models/vae"          "$A1111_DATA/models/VAE"
ln -sf "$ROOT/models/controlnet"   "$A1111_DATA/models/ControlNet"
ln -sf "$ROOT/models/clip"         "$A1111_DATA/models/CLIP"
ln -sf "$ROOT/models/ipadapter"    "$A1111_DATA/models/IPAdapter"

# Comfy paths
COMFY_ROOT="${COMFY_ROOT:-/opt/ComfyUI}"
mkdir -p "$COMFY_ROOT/models"
ln -sf "$ROOT/models/checkpoints"  "$COMFY_ROOT/models/checkpoints"
ln -sf "$ROOT/models/lora"         "$COMFY_ROOT/models/loras"
ln -sf "$ROOT/models/vae"          "$COMFY_ROOT/models/vae"
ln -sf "$ROOT/models/controlnet"   "$COMFY_ROOT/models/controlnet"
ln -sf "$ROOT/models/clip"         "$COMFY_ROOT/models/clip"
ln -sf "$ROOT/models/ipadapter"    "$COMFY_ROOT/models/ipadapter"

# Convenience
ln -sf "$ROOT/outputs" /outputs || true
