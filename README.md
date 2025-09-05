# RunPod Hybrid (Minimal): Forge + ComfyUI

Two containers that share one persistent volume mounted at **/workspace**.

## Shared layout (on your RunPod volume)
/workspace/
  models/{checkpoints,lora,vae,controlnet,clip,ipadapter}
  inputs/{persona_refs,base_edits,video_frames}
  outputs/{forge,comfy,postprocessed}
  configs/

## Images (built by GitHub Actions)
- ghcr.io/<your-username>/forge:latest
- ghcr.io/<your-username>/comfyui:latest# runpod-hybrid
