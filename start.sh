#!/bin/bash
set -e

REQUIRED_MAJOR=20

# Load NVM if available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! command -v nvm &> /dev/null; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
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
PORT=3000 npx mastra dev
