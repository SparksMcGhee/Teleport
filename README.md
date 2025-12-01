# Teleport Deployment

Ansible-based deployment for a Teleport cluster with a public-facing proxy node and a private NATed proxy node, enabling secure access to home lab infrastructure.

## Architecture

- **Public Node**: Digital Ocean droplet serving as the Teleport auth and proxy node with ACME certificate management
- **Private Node**: Home network VM serving as a proxy node connected via reverse tunnel

The private node connects to the public node via outbound reverse tunnel, eliminating the need for port forwarding in the NAT environment.

## Prerequisites

- Ansible 2.9 or later
- SSH access to both nodes
- DNS record pointing to the public node's IP address
- `.env` file configured with node information

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd Teleport
   ```

2. **Configure environment variables:**
   ```bash
   cp env.example .env
   # Edit .env with your actual values
   ```

3. **Generate inventory file:**
   ```bash
   ./scripts/setup_inventory.sh
   ```

4. **Deploy the public node first:**
   ```bash
   ./scripts/deploy.sh playbooks/deploy.yml --limit public_node
   ```

5. **Add the generated auth token to .env:**
   After the public node deployment completes, copy the displayed token to your `.env` file as `Teleport_Auth_Token=...`

6. **Deploy the private node:**
   ```bash
   ./scripts/deploy.sh playbooks/deploy.yml --limit private_node
   ```

## Configuration

### Environment Variables (.env)

Required variables:
- `Teleport_Public_Name`: DNS name for the public node (e.g., `teleport.example.com`)
- `Teleport_Version`: Teleport version to install (default: `15.0.0`)
- `Public_Node_IP`: IP address of the public node
- `Public_Node_User`: SSH user for the public node
- `Public_Node_SSH_Key`: Path to SSH private key for public node
- `Public_Node_SSH_Cert`: (Optional) Path to SSH certificate for public node
- `Private_Node_IP`: IP address of the private node
- `Private_Node_User`: SSH user for the private node
- `Private_Node_SSH_Key`: Path to SSH private key for private node
- `Private_Node_SSH_Cert`: (Optional) Path to SSH certificate for private node
- `Teleport_Auth_Token`: Join token for private node (generated during public node deployment)
- `ACME_Email`: Email address for Let's Encrypt certificate registration

### Authentication

The deployment configures Teleport with passwordless (passkey) authentication. After deployment, users can authenticate using WebAuthn-compatible devices.

To add a user:
```bash
ssh root@<public_node_ip>
tctl users add <username> --roles=access,editor,audit --auth=passwordless
```

## Project Structure

```
Teleport/
├── roles/
│   ├── Public_Node/          # Public node role (auth + proxy)
│   └── Private_Node/          # Private node role (app service)
├── playbooks/
│   └── deploy.yml            # Main deployment playbook
├── scripts/
│   └── setup_inventory.sh    # Inventory generation script
├── howtos/                   # How-to guides and documentation
│   ├── README.md             # Guide index
│   └── KIRIN_DEV_SETUP.md    # Developer setup guide
├── ansible.cfg               # Ansible configuration
├── inventory.ini             # Generated inventory file
├── env.example               # Environment variable template
└── .env                      # Your configuration (not in git)
```

## Features

- ✅ Automated Teleport installation and configuration
- ✅ ACME certificate management via Let's Encrypt
- ✅ Reverse tunnel setup for NATed private node
- ✅ Passwordless (passkey) authentication
- ✅ Application access service (Kirin-Bot, ComfyUI, Home Assistant)
- ✅ Role-based access control (RBAC)
- ✅ Systemd service integration
- ✅ Fail-fast error handling

## End User Documentation

For developers and users accessing resources through this Teleport cluster:

- **[Kirin Developer Setup Guide](./howtos/KIRIN_DEV_SETUP.md)** - Complete guide for installing Teleport CLI, authenticating, and accessing development resources

## Troubleshooting

### Public node deployment fails
- Verify DNS record points to the public node IP
- Check SSH access to the public node
- Ensure ports 3080, 3024, and 3025 are accessible

### Private node cannot connect
- Verify `Teleport_Auth_Token` is set in `.env`
- Check that the private node can reach the public node on port 3025
- Review Teleport logs: `journalctl -u teleport -f`

### Certificate issues
- Ensure DNS record is properly configured
- Check ACME email is valid
- Verify port 443 is accessible from the internet

## Development

This project follows the "fail fast" principle - errors halt execution rather than attempting automatic recovery. This ensures issues are immediately visible and require explicit resolution.

## License

See LICENSE file for details.
