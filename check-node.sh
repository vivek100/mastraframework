#!/bin/bash
set -e

REQUIRED_MAJOR=20

# Check node version first
NODE_VERSION=$(node -v 2>/dev/null || echo "v0.0.0")
CURRENT_MAJOR=$(echo "$NODE_VERSION" | sed 's/v\([0-9]*\).*/\1/')

if [ "$CURRENT_MAJOR" -ge "$REQUIRED_MAJOR" ]; then
  echo "Node.js already v$REQUIRED_MAJOR+, skipping NVM setup"
  exit 0
fi

# Unset npm_config_prefix to avoid NVM issues
unset npm_config_prefix

# Ensure NVM is properly loaded
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Check if NVM is available, if not install it
if ! command -v nvm &> /dev/null; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  
  # Verify NVM is working
  if ! command -v nvm &> /dev/null; then
    echo "NVM installation failed. Please install NVM manually."
    exit 1
  fi
fi

# Switch to required Node.js version
echo "Switching to Node.js v$REQUIRED_MAJOR (via NVM)..."
nvm install $REQUIRED_MAJOR
nvm use $REQUIRED_MAJOR