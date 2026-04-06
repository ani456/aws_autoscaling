#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y \
  git \
  cmake \
  golang-go \
  rustc \
  cargo \
  pkg-config \
  libssl-dev \
  binutils \
  nfs-common \
  stunnel4

  echo "Go version: $(go version)"
echo "Rust version: $(rustc --version)"
echo "CMake version: $(cmake --version | head -1)"

echo "[3/7] Cloning amazon-efs-utils..."
cd ~
if [ -d "efs-utils" ]; then
  echo "Directory exists, cleaning previous failed build..."
  rm -rf ~/efs-utils/build/
  cd efs-utils
  git pull
else
  git clone https://github.com/aws/efs-utils
  cd efs-utils
fi

echo "[4/7] Building .deb package (this may take a few minutes)..."
./build-deb.sh

ls -lh build/amazon-efs-utils*.deb

sudo dpkg -i build/amazon-efs-utils*.deb || true

sudo apt-get install -f -y

echo "Installation status:"
dpkg -l amazon-efs-utils


echo "[6/7] Creating EFS mount point at /mnt/efs..."
sudo mkdir -p /mnt/efs

echo "[7/7] Mounting EFS..."

# ---- EDIT THIS ----
EFS_ID="fs-00d2aad9ea6cb4c25"        # <-- Replace with your EFS File System ID
AWS_REGION="us-east-1"      # <-- Replace with your AWS region


if [ "$EFS_ID" = "fs-00d2aad9ea6cb4c25" ]; then
  echo ""
  echo "⚠️  Please set your EFS_ID in the script and re-run Step 7."
  echo "    Find it at: AWS Console → EFS → your file system"
  echo ""
  echo "    Then run:"
  echo "    sudo mount -t efs \$EFS_ID:/ /mnt/efs"
  exit 0
fi

# Mount with TLS
sudo mount -t efs -o tls ${EFS_ID}:/ /mnt/efs


echo ""
echo "✅ EFS mounted successfully:"
df -h | grep efs

# ── Step 8: Configure auto-mount on reboot ────────────────────────
echo ""
echo "Adding fstab entry for auto-mount on reboot..."

FSTAB_ENTRY="${EFS_ID}:/ /mnt/efs efs tls,_netdev 0 0"

# Avoid duplicate entries
if grep -q "$EFS_ID" /etc/fstab; then
  echo "fstab entry already exists, skipping."
else
  echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab
  echo "fstab entry added."
fi

     
