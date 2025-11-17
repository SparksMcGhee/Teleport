#!/bin/bash
# Script to validate the deployment setup before running Ansible

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_DIR/.env"

echo "Validating Teleport deployment setup..."
echo ""

# Check if .env exists
if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Error: .env file not found at $ENV_FILE"
    exit 1
fi
echo "✅ .env file exists"

# Source .env
set -a
source "$ENV_FILE"
set +a

# Check required variables
MISSING_VARS=0

check_var() {
    local var_name=$1
    local var_value="${!var_name}"
    if [ -z "$var_value" ]; then
        echo "❌ Missing: $var_name"
        MISSING_VARS=$((MISSING_VARS + 1))
    else
        echo "✅ $var_name is set"
    fi
}

echo ""
echo "Checking required variables:"
check_var "Teleport_Public_Name"
check_var "Teleport_Version"
check_var "ACME_Email"
check_var "Public_Node_Public_IP"
check_var "Public_Node_RootUser"
check_var "Public_Node_MgmtCert"
check_var "Private_Node_IP"
check_var "Private_Node_RootUser"
check_var "Private_Node_MgmtCert"

# Check SSH keys exist
echo ""
echo "Checking SSH keys:"
if [ -f "$HOME/${Public_Node_MgmtCert}" ]; then
    echo "✅ Public node SSH key exists: $HOME/${Public_Node_MgmtCert}"
else
    echo "❌ Public node SSH key not found: $HOME/${Public_Node_MgmtCert}"
    MISSING_VARS=$((MISSING_VARS + 1))
fi

if [ -f "$HOME/${Private_Node_MgmtCert}" ]; then
    echo "✅ Private node SSH key exists: $HOME/${Private_Node_MgmtCert}"
else
    echo "❌ Private node SSH key not found: $HOME/${Private_Node_MgmtCert}"
    MISSING_VARS=$((MISSING_VARS + 1))
fi

# Check Ansible
echo ""
echo "Checking Ansible:"
if command -v ansible-playbook &> /dev/null; then
    echo "✅ Ansible is installed: $(which ansible-playbook)"
    ansible-playbook --version | head -1
else
    echo "❌ Ansible is not installed"
    echo "   Install with: sudo apt-get install ansible"
    echo "   Or: pip3 install --user ansible"
    MISSING_VARS=$((MISSING_VARS + 1))
fi

# Test SSH connectivity (optional)
echo ""
echo "Testing SSH connectivity (optional):"
if command -v ssh &> /dev/null; then
    SSH_KEY="$HOME/${Public_Node_MgmtCert}"
    if [ -f "$SSH_KEY" ]; then
        echo "Testing connection to public node..."
        if ssh -i "$SSH_KEY" -o ConnectTimeout=5 -o StrictHostKeyChecking=no "${Public_Node_RootUser}@${Public_Node_Public_IP}" "echo 'Connection successful'" 2>/dev/null; then
            echo "✅ Can connect to public node"
        else
            echo "⚠️  Cannot connect to public node (may need manual verification)"
        fi
    fi
fi

echo ""
if [ $MISSING_VARS -eq 0 ]; then
    echo "✅ All checks passed! Ready to deploy."
    exit 0
else
    echo "❌ Found $MISSING_VARS issue(s). Please fix before deploying."
    exit 1
fi

