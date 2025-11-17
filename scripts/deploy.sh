#!/bin/bash
# Wrapper script to deploy Teleport using Ansible
# This script sources .env and runs the Ansible playbook

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_DIR/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file not found at $ENV_FILE"
    echo "Please copy env.example to .env and fill in your values"
    exit 1
fi

# Source the .env file
set -a
source "$ENV_FILE"
set +a

# Generate inventory if it doesn't exist or is outdated
if [ ! -f "$PROJECT_DIR/inventory.ini" ] || [ "$ENV_FILE" -nt "$PROJECT_DIR/inventory.ini" ]; then
    echo "Generating inventory.ini from .env file..."
    "$SCRIPT_DIR/setup_inventory.sh"
fi

# Change to project directory
cd "$PROJECT_DIR"

# Check if ansible-playbook is available
if ! command -v ansible-playbook &> /dev/null; then
    echo "Error: ansible-playbook is not installed"
    echo ""
    echo "Please install Ansible using one of these methods:"
    echo "  1. sudo apt-get install ansible"
    echo "  2. pip3 install --user ansible (requires pip)"
    echo "  3. python3 -m pip install --user ansible (if pip is available)"
    echo ""
    echo "After installation, ensure ~/.local/bin is in your PATH:"
    echo "  export PATH=\$PATH:~/.local/bin"
    exit 1
fi

# Run ansible-playbook with all arguments passed through
ansible-playbook "$@"

