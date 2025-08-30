#!/bin/bash
set -e

echo "Starting development server..."

NODE_VERSION=$(node -v | cut -d. -f1 | sed 's/v//')
echo "Current Node.js version: v$NODE_VERSION"

if [ "$NODE_VERSION" -lt 20 ]; then
    echo "Node.js version is below 20, upgrading to latest..."
    
    # Temporarily store and clear npm prefix (safer approach)
    ORIGINAL_PREFIX=$(npm config get prefix 2>/dev/null || echo "")
    
    # Clear prefix only for NVM installation
    npm config delete prefix 2>/dev/null || true
    
    if ! command -v nvm &> /dev/null; then
        echo "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    else
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
    
    # Install node with NVM
    nvm install node
    nvm use node
    echo "Node.js upgraded to: $(node -v)"
    
    # Note: On ephemeral servers, no need to restore prefix since server restarts anyway
    # But if you wanted to: npm config set prefix "$ORIGINAL_PREFIX" 2>/dev/null || true
    
    # Reinstall dependencies
    echo "Reinstalling dependencies after Node.js upgrade..."
    npm install
else
    if [ ! -d "node_modules" ]; then
        echo "Installing npm dependencies..."
        npm install
    fi
fi

echo "Starting development server on PORT=3000..."
PORT=3000 mastra dev
