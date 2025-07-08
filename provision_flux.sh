#!/bin/bash
set -eo pipefail
exec > >(tee -a /workspace/provision_log.txt) 2>&1

echo "🛠️ Starting full provisioning script for Flux Kontext + ComfyUI"

source /venv/main/bin/activate

HF_TOKEN="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"
ROOT="/workspace/ComfyUI"
MODELS="$ROOT/models"
CUSTOM="$ROOT/custom_nodes"

mkdir -p "$MODELS/diffusion_models" "$MODELS/vae" "$MODELS/clip" "$MODELS/loras" "$CUSTOM"

echo "📥 Downloading Flux Kontext model..."
curl --fail -L -H "Authorization: Bearer $HF_TOKEN" \
  https://huggingface.co/FluxML/flux-1-kontext-dev/resolve/main/flux-1-kontext-dev.safetensors \
  -o "$MODELS/diffusion_models/flux-1-kontext-dev.safetensors"
du -h "$MODELS/diffusion_models/flux-1-kontext-dev.safetensors"

echo "📥 Downloading VAE..."
curl --fail -L \
  https://huggingface.co/madebyollin/vae-ft-mse-840000-ema-pruned/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors \
  -o "$MODELS/vae/vae-ft-mse-840000-ema-pruned.safetensors"
du -h "$MODELS/vae/vae-ft-mse-840000-ema-pruned.safetensors"

echo "📥 Downloading CLIP encoders..."
curl --fail -L https://huggingface.co/openai/clip-vit-large-patch14/resolve/main/model.safetensors \
  -o "$MODELS/clip/clip-vit-large-patch14.safetensors"
du -h "$MODELS/clip/clip-vit-large-patch14.safetensors"

curl --fail -L https://huggingface.co/stabilityai/clip-vit-large-patch14/resolve/main/model.safetensors \
  -o "$MODELS/clip/openclip-vit-large-patch14.safetensors"
du -h "$MODELS/clip/openclip-vit-large-patch14.safetensors"

echo "📥 Downloading JD3 Nudify LoRA..."
curl --fail -L -H "Authorization: Bearer $HF_TOKEN" \
  https://huggingface.co/JD3GEN/JD3_Nudify_Kontext_LoRa/resolve/main/JD3s_Nudify_Kontext.safetensors \
  -o "$MODELS/loras/JD3s_Nudify_Kontext.safetensors"
du -h "$MODELS/loras/JD3s_Nudify_Kontext.safetensors"

### Custom Nodes
cd "$CUSTOM"

declare -A NODES=(
  ["comfyui-flux-lora-loader"]="https://huggingface.co/FluxML/comfyui-flux-lora-loader"
  ["comfyui-controlnet-aux"]="https://github.com/Fannovel16/comfyui_controlnet_aux"
  ["comfyui-segment-anything"]="https://github.com/ltdrdata/ComfyUI-Segment-Anything"
  ["comfyui-clipseg"]="https://github.com/toriato/ComfyUI-CLIPSeg"
  ["comfyui-tea-seg"]="https://github.com/VerisimilitudeX/ComfyUI-TeaSeg"
  ["comfyui-crystools"]="https://github.com/crystian/ComfyUI-Crystal-Tools"
  ["rg3comfy"]="https://github.com/rgthree/rgthree-comfy"
)

for name in "${!NODES[@]}"; do
  if [ ! -d "$name" ]; then
    echo "🔌 Cloning $name..."
    git clone "${NODES[$name]}" "$name"
  else
    echo "✅ $name already installed."
  fi
done

### Python packages
echo "🐍 Installing xformers and SageAttention..."
pip install --no-cache-dir xformers
pip install --no-cache-dir git+https://github.com/THU-ML/SageAttention.git

echo "✅ Provisioning complete."
