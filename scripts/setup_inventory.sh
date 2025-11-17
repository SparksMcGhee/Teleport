#!/bin/bash
# Script to generate inventory.ini from .env file

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_DIR/.env"
INVENTORY_FILE="$PROJECT_DIR/inventory.ini"

if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file not found at $ENV_FILE"
    echo "Please copy env.example to .env and fill in your values"
    exit 1
fi

# Source the .env file
set -a
source "$ENV_FILE"
set +a

# Map .env variables to expected names (support both formats)
PUBLIC_IP="${Public_Node_Public_IP:-${Public_Node_IP}}"
PUBLIC_USER="${Public_Node_RootUser:-${Public_Node_User}}"
# Prefer Tailscale alias for private node if available, otherwise use IP
PRIVATE_IP="${Private_Node_Tailscale_Alias:-${Private_Node_IP}}"
PRIVATE_USER="${Private_Node_RootUser:-${Private_Node_User}}"

# Validate required variables
if [ -z "$PUBLIC_IP" ] || [ -z "$PUBLIC_USER" ]; then
    echo "Error: Public node IP and user must be set in .env"
    echo "Expected: Public_Node_IP or Public_Node_Public_IP"
    echo "Expected: Public_Node_User or Public_Node_RootUser"
    exit 1
fi

if [ -z "$PRIVATE_IP" ] || [ -z "$PRIVATE_USER" ]; then
    echo "Error: Private node IP and user must be set in .env"
    echo "Expected: Private_Node_IP"
    echo "Expected: Private_Node_User or Private_Node_RootUser"
    exit 1
fi

# Generate inventory.ini
cat > "$INVENTORY_FILE" <<EOF
[public_node]
public ansible_host=${PUBLIC_IP} ansible_user=${PUBLIC_USER}

[private_node]
private ansible_host=${PRIVATE_IP} ansible_user=${PRIVATE_USER}

[teleport:children]
public_node
private_node
EOF

echo "Generated inventory.ini from .env file"
echo "Public Node: ${PUBLIC_IP} (user: ${PUBLIC_USER})"
echo "Private Node: ${PRIVATE_IP} (user: ${PRIVATE_USER})"

