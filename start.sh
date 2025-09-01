#!/bin/bash
set -e

# Unset npm_config_prefix to avoid NVM issues
unset npm_config_prefix

REQUIRED_MAJOR=20

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

# Check node version
NODE_VERSION=$(node -v 2>/dev/null || echo "v0.0.0")
CURRENT_MAJOR=$(echo "$NODE_VERSION" | sed 's/v\([0-9]*\).*/\1/')

if [ "$CURRENT_MAJOR" -lt "$REQUIRED_MAJOR" ]; then
  echo "Switching to Node.js v$REQUIRED_MAJOR (via NVM)..."
  nvm install $REQUIRED_MAJOR
  nvm use $REQUIRED_MAJOR
  echo "Installing dependencies..."
  npm install
else
  echo "Node.js already v$REQUIRED_MAJOR+, skipping install"
fi

echo "Starting Mastra dev..."
export PORT=3000
npx mastra dev
