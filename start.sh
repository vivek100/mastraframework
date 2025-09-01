#!/bin/bash
set -e

# Check Node version
NODE_VERSION=$(node -v 2>/dev/null || echo "v0.0.0")
REQUIRED_MAJOR=20
CURRENT_MAJOR=$(echo "$NODE_VERSION" | sed 's/v\([0-9]*\).*/\1/')

echo "Current Node version: $NODE_VERSION"

if [ "$CURRENT_MAJOR" -lt "$REQUIRED_MAJOR" ]; then
  echo "Upgrading Node.js to v$REQUIRED_MAJOR+..."
  if command -v nvm &> /dev/null; then
    nvm install $REQUIRED_MAJOR
    nvm use $REQUIRED_MAJOR
  else
    curl -fsSL https://deb.nodesource.com/setup_${REQUIRED_MAJOR}.x | bash -
    apt-get install -y nodejs
  fi
  echo "Installing dependencies..."
  npm install
else
  echo "Node.js already v$REQUIRED_MAJOR+, skipping install"
fi

# Start Mastra dev
echo "Starting Mastra dev on port 3000..."
PORT=3000 npx mastra dev
