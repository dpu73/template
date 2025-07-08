
# Diff Models
cd /workspace/ComfyUI/models/diffusion_models/

wget --header="Authorization: Bearer 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" \
https://huggingface.co/black-forest-labs/FLUX.1-Kontext-dev/resolve/main/flux1-kontext-dev.safetensors 


wget --header="Authorization: Bearer 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" \
https://huggingface.co/black-forest-labs/FLUX.1-Kontext-dev/resolve/main/flux1-dev-kontext_fp8_scaled.safetensors


# Loras
cd /workspace/ComfyUI/models/loras/

wget --header="Authorization: Bearer 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" \
https://huggingface.co/JD3GEN/JD3_Nudify_Kontext_LoRa/resolve/main/JD3s_Nudify_Kontext.safetensors

# Custom Nodes

cd /workspace/ComfyUI/custom_nodes

git clone https://github.com/crystian/ComfyUI-Crystools.git

git clone https://github.com/rgthree/rgthree-comfy.git

# VAE

wget --header="Authorization: Bearer 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" \

https://huggingface.co/black-forest-labs/FLUX.1-Kontext-dev/resolve/main/ae.safetensors \
-O /workspace/ComfyUI/models/vae/ae.safetensors

