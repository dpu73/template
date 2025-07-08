#!/bin/bash
set -eo pipefail

echo "🛠️ Starting full provisioning script for Flux Kontext + ComfyUI"

# Activate Python virtual environment
source /venv/main/bin/activate

# Set HuggingFace token (readonly)
HF_TOKEN="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"

# Paths
ROOT="/workspace/ComfyUI"
MODELS="$ROOT/models"
CUSTOM="$ROOT/custom_nodes"

mkdir -p "$MODELS/diffusion_models" "$MODELS/vae" "$MODELS/clip" "$MODELS/lora" "$CUSTOM"

### MODEL DOWNLOADS

echo "📥 Downloading Flux Kontext model..."
curl -L -H "Authorization: Bearer $HF_TOKEN" \
  https://huggingface.co/FluxML/flux-1-kontext-dev/resolve/main/flux-1-kontext-dev.safetensors \
  -o "$MODELS/diffusion_models/flux-1-kontext-dev.safetensors"

echo "📥 Downloading VAE..."
curl -L https://huggingface.co/madebyollin/vae-ft-mse-840000-ema-pruned/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors \
  -o "$MODELS/vae/vae-ft-mse-840000-ema-pruned.safetensors"

echo "📥 Downloading CLIP and OpenCLIP encoders..."
curl -L https://huggingface.co/openai/clip-vit-large-patch14/resolve/main/model.safetensors \
  -o "$MODELS/clip/clip-vit-large-patch14.safetensors"
curl -L https://huggingface.co/stabilityai/clip-vit-large-patch14/resolve/main/model.safetensors \
  -o "$MODELS/clip/openclip-vit-large-patch14.safetensors"

echo "📥 Downloading JD3 Nudify LoRA..."
curl -L -H "Authorization: Bearer $HF_TOKEN" \
  https://huggingface.co/JD3GEN/JD3_Nudify_Kontext_LoRa/resolve/main/JD3s_Nudify_Kontext.safetensors \
  -o "$MODELS/lora/JD3s_Nudify_Kontext.safetensors"

### CUSTOM NODE INSTALLS

cd "$CUSTOM"

echo "🔌 Installing comfyui-flux-lora-loader..."
git clone https://huggingface.co/FluxML/comfyui-flux-lora-loader || echo "Already exists."

echo "🔌 Installing comfyui-controlnet-aux..."
git clone https://github.com/Fannovel16/comfyui_controlnet_aux || echo "Already exists."

echo "🔌 Installing comfyui-segment-anything..."
git clone https://github.com/ltdrdata/ComfyUI-Segment-Anything || echo "Already exists."

echo "🔌 Installing comfyui-clipseg..."
git clone https://github.com/toriato/ComfyUI-CLIPSeg || echo "Already exists."

echo "🔌 Installing comfyui-tea-seg..."
git clone https://github.com/VerisimilitudeX/ComfyUI-TeaSeg || echo "Already exists."

echo "🔌 Installing Crystal Tools..."
git clone https://github.com/crystian/ComfyUI-Crystal-Tools || echo "Already exists."

echo "🔌 Installing RG3Comfy..."
git clone https://github.com/rgthree/rgthree-comfy || echo "Already exists."

### PYTHON DEPENDENCIES

echo "🐍 Installing xformers and SageAttention..."
pip install --no-cache-dir xformers
pip install --no-cache-dir git+https://github.com/THU-ML/SageAttention.git

echo "✅ All models, nodes, and tools installed. Boot complete."
