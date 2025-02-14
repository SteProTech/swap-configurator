#!/bin/bash

# Enable strict error checking and safety features
set -euo pipefail

# Color definitions for user feedback
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Configuration - Edit these values if needed
SWAP_FILE="/swapfile"
FSTAB="/etc/sysctl.conf"
DESIRED_SWAPPINESS=10
MIN_SWAP_SIZE=1
MAX_SWAP_SIZE=128

# Function for error handling
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Cleanup function for interrupted operations
cleanup() {
    echo -e "\n${RED}Script interrupted. Performing cleanup...${NC}"
    [ -f "${SWAP_FILE}" ] && rm -f "${SWAP_FILE}"
    exit 1
}
trap cleanup SIGINT SIGTERM

# Root privileges check
[ "$(id -u)" -ne 0 ] && error_exit "This script must be run as root. Use sudo or switch to root user."

# Display current memory status
echo -e "\n${YELLOW}Current memory status:${NC}"
free -h

# Existing swap handling
existing_swap=$(swapon --show=name --noheadings)
if [ -f "${SWAP_FILE}" ] || echo "${existing_swap}" | grep -q "^${SWAP_FILE}$"; then
    echo -e "\n${YELLOW}Found existing swap configuration:${NC}"
    swapon --show
    
    read -rp "A swap file already exists at ${SWAP_FILE}. Remove it? (y/N) " choice
    if [[ "${choice}" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Removing existing swap...${NC}"
        swapoff "${SWAP_FILE}" 2>/dev/null || true
        rm -f "${SWAP_FILE}"
        sed -i "\|^${SWAP_FILE}[[:space:]]|d" "/etc/fstab"
        echo -e "${GREEN}Existing swap file removed successfully.${NC}"
    else
        echo -e "${RED}Operation canceled. Existing swap file remains.${NC}"
        exit 0
    fi
fi

# Swap size configuration
while true; do
    read -rp "Enter swap size in GB (${MIN_SWAP_SIZE}-${MAX_SWAP_SIZE}): " swap_size
    [[ "${swap_size}" =~ ^[0-9]+$ ]] || { echo -e "${RED}Please enter a valid number${NC}"; continue; }
    (( swap_size >= MIN_SWAP_SIZE && swap_size <= MAX_SWAP_SIZE )) && break || \
        echo -e "${RED}Size must be between ${MIN_SWAP_SIZE} and ${MAX_SWAP_SIZE} GB${NC}"
done

# Disk space verification
swap_dir=$(dirname "${SWAP_FILE}")
[ -z "${swap_dir}" ] && swap_dir="/"
available_space=$(df --output=avail -BG "${swap_dir}" | tail -1 | tr -d 'G')
(( swap_size > available_space )) && error_exit "Insufficient disk space. Available: ${available_space}G, Requested: ${swap_size}G"

# Swap file creation
echo -e "\n${YELLOW}Creating ${swap_size}GB swap file...${NC}"
if ! dd if=/dev/zero of="${SWAP_FILE}" bs=1M count=$((swap_size * 1024)) status=progress; then
    error_exit "Swap file creation failed. Check disk space and permissions."
fi
chmod 600 "${SWAP_FILE}"

# Enable swap
mkswap "${SWAP_FILE}" >/dev/null || error_exit "Failed to format swap file"
swapon "${SWAP_FILE}" || error_exit "Failed to activate swap"

# Persistence configuration
if ! grep -q "^${SWAP_FILE}[[:space:]]" "/etc/fstab"; then
    echo "${SWAP_FILE} none swap sw 0 0" >> "/etc/fstab"
    echo -e "${GREEN}Swap added to /etc/fstab for persistence${NC}"
fi

# Swappiness optimization
echo -e "\n${YELLOW}Configuring swappiness...${NC}"
current_swappiness=$(cat /proc/sys/vm/swappiness)
if [ "${current_swappiness}" -gt "${DESIRED_SWAPPINESS}" ]; then
    echo "vm.swappiness=${DESIRED_SWAPPINESS}" | tee -a "/etc/sysctl.conf" >/dev/null
    sysctl -p >/dev/null
    echo -e "${GREEN}Swappiness optimized: ${current_swappiness} → ${DESIRED_SWAPPINESS}${NC}"
else
    echo -e "${YELLOW}Swappiness already optimal: ${current_swappiness}${NC}"
fi

# Final verification
echo -e "\n${GREEN}Swap configuration successful! Final status:${NC}"
swapon --show
echo -e "\n${YELLOW}Recommended monitoring commands:"
echo -e "  free -h     # Show memory/swap usage"
echo -e "  swapon -s    # Detailed swap information"
echo -e "  htop        # Interactive system monitor${NC}"
