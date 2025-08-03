  #!/bin/bash
  # AWACS Platform Monitoring Script
  while true; do
      clear
      echo "=== AWACS Platform Status ==="
      echo "Time: $(date)"
      echo ""
      
      echo "=== System Resources ==="
      echo "CPU Usage:"
      top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//'
      echo "Memory Usage:"
      free -h | grep "Mem:" | awk '{print "Used: " $3 "/" $2 " (" $3/$2*100 "%)"}'
      echo "Disk Usage:"
      df -h / | tail -1 | awk '{print "Used: " $3 "/" $2 " (" $5 ")"}'
      echo ""
      
      echo "=== USB Devices ==="
      lsusb | grep -E "(RTL|HackRF|Ubertooth|Prolific)"
      echo ""
      
      echo "=== Network Interfaces ==="
      ip addr show | grep -E "(wlan|eth)" | head -5
      echo ""
      
      echo "=== Active Processes ==="
      ps aux | grep -E "(kismet|gpsd|rtl_|hackrf)" | grep -v grep
      echo ""
      
      echo "Press Ctrl+C to exit..."
      sleep 5
  done