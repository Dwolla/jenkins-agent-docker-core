#!/bin/bash
# SDKMAN initialization wrapper script
# This script is designed to be used as BASH_ENV to automatically configure
# SDKMAN when .sdkmanrc files are present in the workspace.
#
# When BASH_ENV is set to this script, it will be sourced by every non-interactive
# bash shell, ensuring SDKMAN is configured before any commands run.

# Source SDKMAN initialization if it exists
if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
  # SDKMAN requires errexit to be disabled during initialization
  set +o errexit +o xtrace
  
  # Source SDKMAN initialization
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  
  # Check if .sdkmanrc exists in the current working directory or workspace
  # Jenkins workspace is typically in $WORKSPACE or current directory
  SDKMANRC_PATH=""
  if [ -f ".sdkmanrc" ]; then
    SDKMANRC_PATH=".sdkmanrc"
  elif [ -n "${WORKSPACE:-}" ] && [ -f "${WORKSPACE}/.sdkmanrc" ]; then
    SDKMANRC_PATH="${WORKSPACE}/.sdkmanrc"
  fi
  
  if [ -n "$SDKMANRC_PATH" ]; then
    # Change to the directory containing .sdkmanrc for sdk env install
    SDKMANRC_DIR=$(dirname "$SDKMANRC_PATH")
    if [ "$SDKMANRC_DIR" != "." ]; then
      cd "$SDKMANRC_DIR" || true
    fi
    # Install Java version specified in .sdkmanrc
    sdk env install || true
    # Re-source to ensure the new Java is on PATH
    source "$HOME/.sdkman/bin/sdkman-init.sh"
  fi
  
  # Re-enable errexit and xtrace
  set -o errexit -o xtrace
fi

