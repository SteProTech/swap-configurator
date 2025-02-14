# Troubleshooting Guide

## Common Issues
1. **Insufficient Disk Space**:
   - Check available space: `df -h`
   - Reduce swap size or free up disk space.

2. **Permission Denied**:
   - Ensure you're running the script as root: `sudo ./swap-manager.sh`

3. **Swap File Already Exists**:
   - Remove existing swap: `sudo swapoff /swapfile && sudo rm /swapfile`

4. **Script Fails on dd Command**:
   - Use smaller block size: Edit `dd` command in the script to use `bs=1M`.
