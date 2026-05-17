#!/bin/bash

# Output colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}--- Ubuntu 26.04 CUDA Installer ---${NC}"

# Check for NVIDIA GPU
echo -e "${YELLOW}Checking for NVIDIA GPU...${NC}"
if lspci | grep -i nvidia > /dev/null; then
    echo -e "${GREEN}NVIDIA GPU detected.${NC}"
else
    echo -e "${RED}No NVIDIA GPU found on this system. Cannot install CUDA drivers.${NC}"
    exit 1
fi

# Ask for confirmation
read -p "This will update your package list and install NVIDIA drivers and CUDA toolkit. Proceed? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo -e "${YELLOW}Installation aborted by user.${NC}"
    exit 0
fi

echo -e "${YELLOW}Updating package repositories...${NC}"
sudo apt update

echo -e "${YELLOW}Auto-installing recommended NVIDIA drivers...${NC}"
sudo ubuntu-drivers autoinstall

echo -e "${YELLOW}Installing NVIDIA CUDA Toolkit...${NC}"
sudo apt install -y nvidia-cuda-toolkit

echo -e "${GREEN}Installation complete!${NC}"
echo -e "${YELLOW}It is highly recommended to reboot your system to apply the new drivers.${NC}"
