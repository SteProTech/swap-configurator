# Best Practices

## Swap Sizing Recommendations
| RAM Size  | Swap Size |
|-----------|-----------|
| <2GB      | 2x RAM    |
| 2-8GB     | = RAM     |
| >8GB      | 0.5x RAM  |

## Monitoring Swap Usage
```bash
# Real-time monitoring
watch -n1 'free -h; swapon --show; grep -i swappiness /etc/sysctl.conf'

## Performance Tuning
```bash
# Cache pressure adjustment
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf



