#!/bin/bash
set -e

echo "Starting development server..."

NODE_VERSION=$(node -v | cut -d. -f1 | sed 's/v//')
echo "Current Node.js version: v$NODE_VERSION"

NEED_REINSTALL=false

if [ "$NODE_VERSION" -lt 20 ]; then
    echo "Node.js version is below 20, upgrading to latest..."
    NEED_REINSTALL=true
    
    if ! command -v nvm &> /dev/null; then
        echo "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    else
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
    
    echo "Installing latest Node.js..."
    nvm install node
    nvm use node
    echo "Node.js upgraded to: $(node -v)"
fi

# Always reinstall if Node was upgraded OR if node_modules doesn't exist
if [ "$NEED_REINSTALL" = true ] || [ ! -d "node_modules" ]; then
    echo "Installing/reinstalling npm dependencies..."
    
    # Clean install to avoid conflicts
    if [ -d "node_modules" ]; then
        echo "Removing existing node_modules..."
        rm -rf node_modules
    fi
    
    if [ -f "package-lock.json" ]; then
        echo "Removing package-lock.json to avoid conflicts..."
        rm package-lock.json
    fi
    
    npm install
    echo "Dependencies installed successfully"
else
    echo "Dependencies already installed, skipping..."
fi

echo "Starting development server on PORT=3000..."
PORT=3000 mastra dev
