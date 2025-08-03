#!/bin/bash
  # AWACS Platform Startup Script
  echo "Starting AWACS Platform services..."
  # Start GPS daemon
  sudo systemctl start gpsd
  sleep 2
  # Test RTL-SDR devices
  #echo "Testing RTL-SDR devices..."
  #rtl_test -t 2>/dev/null | head -10
  # Test HackRF
  #echo "Testing HackRF..."
  #hackrf_info 2>/dev/null || echo "HackRF not detected"
  # Start Kismet (will run in background)
  echo "Starting Kismet..."
  sudo systemctl start kismet
  # Show status
  echo "Services status:"
  systemctl status gpsd --no-pager
  systemctl status kismet --no-pager
  echo ""
  echo "AWACS Platform started!"
  echo "Kismet web interface: http://$(hostname -I | cut -d' ' -f1):2501"
  echo "SSH access: ssh $(whoami)@$(hostname -I | cut -d' ' -f1)"