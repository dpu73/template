#!/bin/bash
set -eo pipefail
exec > >(tee -a /workspace/provision_log.txt) 2>&1
set -x

# Activate environment
source /venv/main/bin/activate

# Set paths
COMFY_DIR="/workspace/ComfyUI"
MODELS_DIR="$COMFY_DIR/models"
DIFFUSION_DIR="$MODELS_DIR/diffusion_models"
LORAS_DIR="$MODELS_DIR/loras"
CUSTOM_DIR="$COMFY_DIR/custom_nodes"

# Set HuggingFace token (update if needed)
export HF_TOKEN="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"

# Make sure all directories exist
mkdir -p "$DIFFUSION_DIR" "$LORAS_DIR" "$CUSTOM_DIR"

##########################
# DOWNLOAD MODELS
##########################

echo "📥 Downloading FLUX.1 Kontext model..."
curl -L --fail -H "Authorization: Bearer $HF_TOKEN" \
  -o "$DIFFUSION_DIR/flux1-kontext-dev.safetensors" \
  https://huggingface.co/black-forest-labs/FLUX.1-Kontext-dev/resolve/main/flux1-kontext-dev.safetensors

echo "📥 Downloading JD3 Nudify Kontext LoRA..."
curl -L --fail -H "Authorization: Bearer $HF_TOKEN" \
  -O "$LORAS_DIR/JD3s_Nudify_Kontext.safetensors" \
  https://huggingface.co/JD3GEN/JD3_Nudify_Kontext_LoRa/resolve/main/JD3s_Nudify_Kontext.safetensors

##########################
# INSTALL CUSTOM NODES
##########################

echo "🔌 Installing Crystools..."
git clone https://github.com/crystian/ComfyUI-Crystools "$CUSTOM_DIR/ComfyUI-Crystools"

echo "🔌 Installing RGThree tools..."
git clone https://github.com/rgthree/rgthree-comfy "$CUSTOM_DIR/rgthree-comfy"

echo "✅ Done provisioning Flux+Kontext environment."
