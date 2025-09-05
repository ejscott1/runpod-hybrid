# RunPod Hybrid (Minimal): Forge + ComfyUI

Two containers that share one persistent volume mounted at **/workspace**.

## Shared layout (on your RunPod volume)
/workspace/
  models/{checkpoints,lora,vae,controlnet,clip,ipadapter}
  inputs/{persona_refs,base_edits,video_frames}
  outputs/{forge,comfy,postprocessed}
  configs/

## Images (built by GitHub Actions)
- ghcr.io/ejscott1/forge:latest
- ghcr.io/ejscott1/comfyui:latest

## Quick start
1) Push this repo to GitHub (main branch).  
2) GitHub Action builds & pushes both images to GHCR.  
3) In RunPod → Create Template:
   - Forge image: `ghcr.io/ejscott1/forge:latest`, expose **7860**, mount **/workspace**.
   - ComfyUI image: `ghcr.io/ejscott1/comfyui:latest`, expose **8188**, mount **/workspace**.
4) Put models once into `/workspace/models/...` — both apps see them.
