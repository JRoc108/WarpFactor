#!/bin/bash
# WarpFactor - System optimization utilities for the Warp terminal application
# Copyright (c) 2025 To Tech and Back, LTD.
# Jared Churchman, Chief Engineer and sole owner
# MIT License with Churchman Rider I

DecreaseWarpFactor() {
  # Store current values before making changes (for reporting)
  CURRENT_MAXPROC=$(sysctl -n kern.maxproc)
  CURRENT_MAXPROCPERUID=$(sysctl -n kern.maxprocperuid)
  CURRENT_SHMMAX=$(sysctl -n kern.sysv.shmmax)
  CURRENT_SHMALL=$(sysctl -n kern.sysv.shmall)
  
  # Standard values to restore to
  # Note: These values are known defaults, but could be adjusted if needed
  TARGET_MAXPROC=4000
  TARGET_MAXPROCPERUID=2666
  TARGET_SHMMAX=4194304
  TARGET_SHMALL=1024
  
  # Restore system settings to their original values
  echo "Restoring system settings..."
  sudo sysctl -w kern.maxproc=$TARGET_MAXPROC
  sudo sysctl -w kern.maxprocperuid=$TARGET_MAXPROCPERUID
  sudo sysctl -w kern.sysv.shmmax=$TARGET_SHMMAX
  sudo sysctl -w kern.sysv.shmall=$TARGET_SHMALL
  
  # Find and kill any caffeinate processes
  echo "Checking for caffeinate processes..."
  CAFFEINATE_PIDS=$(ps aux | grep caffeinate | grep -v grep | awk '{print $2}')
  if [ -n "$CAFFEINATE_PIDS" ]; then
    echo "Terminating caffeinate processes: $CAFFEINATE_PIDS"
    kill $CAFFEINATE_PIDS 2>/dev/null
  else
    echo "No caffeinate processes found"
  fi
  
  # Clean up Chromium processes from cache directory
  echo "Checking for Playwright Chromium processes..."
  CHROMIUM_PIDS=$(ps aux | grep -i "Library/Caches/ms-playwright/chromium" | grep -v grep | awk '{print $2}')
  if [ -n "$CHROMIUM_PIDS" ]; then
    echo "Terminating Chromium processes: $CHROMIUM_PIDS"
    kill $CHROMIUM_PIDS 2>/dev/null
  else
    echo "No Playwright Chromium processes found"
  fi
  
  # Reset nice values for any Warp processes
  echo "Resetting process priorities for Warp processes..."
  WARP_PIDS=$(ps aux | grep -i "/Applications/Warp.app" | grep -v grep | awk '{print $2}')
  if [ -n "$WARP_PIDS" ]; then
    for pid in $WARP_PIDS; do
      sudo renice 0 $pid 2>/dev/null
    done
    echo "Reset priorities for Warp processes: $WARP_PIDS"
  else
    echo "No Warp processes found to reset"
  fi
  
  # Print confirmation with before/after values
  echo "╔════════════════════════════════════════════════════╗"
  echo "║            🚀 Warp engines disengaged! 🚀           ║"
  echo "╠════════════════════════════════════════════════════╣"
  echo "║ System settings restored:                          ║"
  echo "║ • kern.maxproc:        $CURRENT_MAXPROC → $TARGET_MAXPROC"
  echo "║ • kern.maxprocperuid:  $CURRENT_MAXPROCPERUID → $TARGET_MAXPROCPERUID"
  echo "║ • kern.sysv.shmmax:    $CURRENT_SHMMAX → $TARGET_SHMMAX"
  echo "║ • kern.sysv.shmall:    $CURRENT_SHMALL → $TARGET_SHMALL"
  echo "╚════════════════════════════════════════════════════╝"
}

IncreaseWarpFactor() {
  # Store current values before making changes (for reporting)
  CURRENT_MAXPROC=$(sysctl -n kern.maxproc)
  CURRENT_MAXPROCPERUID=$(sysctl -n kern.maxprocperuid)
  CURRENT_SHMMAX=$(sysctl -n kern.sysv.shmmax)
  CURRENT_SHMALL=$(sysctl -n kern.sysv.shmall)
  
  # Performance values to apply
  # Note: These values are optimized for performance
  TARGET_MAXPROC=2500
  TARGET_MAXPROCPERUID=2000
  TARGET_SHMMAX=16777216
  TARGET_SHMALL=65536
  
  # Apply performance-optimized system settings
  echo "Applying performance settings..."
  sudo sysctl -w kern.maxproc=$TARGET_MAXPROC
  sudo sysctl -w kern.maxprocperuid=$TARGET_MAXPROCPERUID
  sudo sysctl -w kern.sysv.shmmax=$TARGET_SHMMAX
  sudo sysctl -w kern.sysv.shmall=$TARGET_SHMALL
  sudo launchctl limit maxfiles 4096 unlimited
  
  # Start caffeinate to prevent system sleep
  echo "Starting caffeinate to prevent system sleep..."
  caffeinate -d -i -m -s &>/dev/null & disown
  
  # Optimize nice values for Warp processes
  echo "Optimizing process priorities for Warp processes..."
  WARP_PIDS=$(ps aux | grep -i "/Applications/Warp.app" | grep -v grep | awk '{print $2}')
  if [ -n "$WARP_PIDS" ]; then
    for pid in $WARP_PIDS; do
      sudo renice -10 $pid 2>/dev/null
    done
    echo "Optimized priorities for Warp processes: $WARP_PIDS"
  else
    echo "No Warp processes found to optimize"
  fi
  
  # Print confirmation with before/after values
  echo "╔════════════════════════════════════════════════════╗"
  echo "║            🚀 Warp engines engaged! 🚀            ║"
  echo "╠════════════════════════════════════════════════════╣"
  echo "║ System settings optimized:                         ║"
  echo "║ • kern.maxproc:        $CURRENT_MAXPROC → $TARGET_MAXPROC"
  echo "║ • kern.maxprocperuid:  $CURRENT_MAXPROCPERUID → $TARGET_MAXPROCPERUID"
  echo "║ • kern.sysv.shmmax:    $CURRENT_SHMMAX → $TARGET_SHMMAX"
  echo "║ • kern.sysv.shmall:    $CURRENT_SHMALL → $TARGET_SHMALL"
  echo "║ • maxfiles:            set to 4096/unlimited        ║"
  echo "╚════════════════════════════════════════════════════╝"
}

# Check if the script is being sourced or executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Direct execution
    if [[ "$1" == "increase" ]]; then
        IncreaseWarpFactor
    elif [[ "$1" == "decrease" ]]; then
        DecreaseWarpFactor
    else
        echo "Usage: ./warpfactor.sh [increase|decrease]"
        echo "  increase - Apply optimized settings for Warp terminal"
        echo "  decrease - Restore default system settings"
        exit 1
    fi
fi

