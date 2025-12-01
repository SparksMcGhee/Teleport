# Kirin Developer Setup Guide

**For Human Developers and AI Agents**

This guide explains how to install Teleport CLI, authenticate to the Teleport cluster, and connect to the Kirin-Bot development server for interactive development.

---

## Prerequisites

- Linux, macOS, or Windows with WSL2
- Terminal access
- A Teleport user account with the `kirin-devs` role

---

## Part 1: Install Teleport CLI

### Linux (Debian/Ubuntu)

```bash
# Download the Teleport client
curl -O https://cdn.teleport.dev/teleport-v15.5.4-linux-amd64-bin.tar.gz

# Extract
tar -xzf teleport-v15.5.4-linux-amd64-bin.tar.gz

# Install tsh (Teleport client) to /usr/local/bin
sudo cp teleport/tsh /usr/local/bin/
sudo chmod +x /usr/local/bin/tsh

# Verify installation
tsh version
```

### macOS (using Homebrew)

```bash
# Install via Homebrew
brew install teleport

# Verify installation
tsh version
```

### macOS (manual install)

```bash
# Download the Teleport client
curl -O https://cdn.teleport.dev/teleport-v15.5.4-darwin-arm64-bin.tar.gz

# Extract
tar -xzf teleport-v15.5.4-darwin-arm64-bin.tar.gz

# Install tsh to /usr/local/bin
sudo cp teleport/tsh /usr/local/bin/
sudo chmod +x /usr/local/bin/tsh

# Verify installation
tsh version
```

### Expected Output

```
Teleport v15.5.4 git:v15.5.4 go1.23.10
```

---

## Part 2: Authenticate to Teleport.Sparks.Works

### Initial Login

```bash
# Log in to the Teleport cluster
tsh login --proxy=teleport.sparks.works:443 --user=<your-username>
```

**What happens next:**
1. Your browser will open automatically
2. You'll be prompted to authenticate with your passkey (WebAuthn)
3. After successful authentication, credentials will be saved locally

### Verify Authentication

```bash
# Check your current status
tsh status

# Expected output shows:
# - Cluster: teleport.sparks.works
# - Logged in as: <your-username>
# - Roles: kirin-devs
# - Valid until: <expiry timestamp>
```

### View Available Resources

```bash
# List available SSH nodes
tsh ls

# List available applications
tsh apps ls

# Expected to see:
# - spark-ddb1 (SSH node)
# - kirin-bot (Application)
```

---

## Part 3: Connect to Kirin Development Server via SSH

### Direct SSH Connection

```bash
# Connect to spark-ddb1 as ubuntu user
tsh ssh ubuntu@spark-ddb1
```

### Using Specific Login

```bash
# Connect as root (if needed)
tsh ssh root@spark-ddb1
```

### Non-Interactive Commands

For AI agents or automation, you can run commands without interactive SSH:

```bash
# Run a single command
tsh ssh ubuntu@spark-ddb1 "ls -la /path/to/kirin"

# Check Kirin service status
tsh ssh ubuntu@spark-ddb1 "systemctl status kirin-bot"

# View logs
tsh ssh ubuntu@spark-ddb1 "journalctl -u kirin-bot -n 50"
```

---

## Part 4: AI Agent Development Workflow

### For AI Coding Assistants

When working with an AI agent (like Cursor, GitHub Copilot, or Claude), you can enable the agent to interact with the Kirin server:

#### Option A: Interactive SSH Session

1. Start an SSH session:
   ```bash
   tsh ssh ubuntu@spark-ddb1
   ```

2. Navigate to the Kirin project:
   ```bash
   cd /path/to/kirin-bot
   ```

3. The AI agent can now execute commands in this context

#### Option B: Remote Command Execution

For non-interactive development, use tsh to execute commands remotely:

```bash
# Read a file
tsh ssh ubuntu@spark-ddb1 "cat /path/to/kirin-bot/config.yaml"

# Edit a file (using echo or heredoc)
tsh ssh ubuntu@spark-ddb1 "echo 'new content' > /path/to/file"

# Restart service
tsh ssh ubuntu@spark-ddb1 "sudo systemctl restart kirin-bot"

# Check status
tsh ssh ubuntu@spark-ddb1 "systemctl status kirin-bot"
```

#### Option C: Port Forwarding for Local Development

Forward the Kirin-Bot service port to your local machine:

```bash
# Forward port 666 from spark-ddb1 to local port 8080
tsh ssh -L 8080:localhost:666 ubuntu@spark-ddb1

# Now access http://localhost:8080 in your browser or tools
```

---

## Part 5: Access Kirin-Bot Web Interface

### Via Teleport Application Access

```bash
# Log in to the Kirin-Bot web app
tsh apps login kirin-bot

# This will provide a local proxy URL (typically https://127.0.0.1:<random-port>)
```

### Direct Browser Access

Navigate to: `https://kirin-bot.teleport.sparks.works`

You'll be authenticated automatically via your Teleport session.

---

## Part 6: File Transfer

### Copy Files TO the Server

```bash
# Upload a file
tsh scp myfile.txt ubuntu@spark-ddb1:/home/ubuntu/

# Upload a directory
tsh scp -r ./my-directory ubuntu@spark-ddb1:/home/ubuntu/
```

### Copy Files FROM the Server

```bash
# Download a file
tsh scp ubuntu@spark-ddb1:/home/ubuntu/logfile.txt ./

# Download a directory
tsh scp -r ubuntu@spark-ddb1:/home/ubuntu/kirin-logs ./
```

---

## Part 7: Session Management

### Check Active Sessions

```bash
# List your active sessions
tsh sessions ls
```

### Re-authenticate

Sessions expire after 12 hours. When expired:

```bash
# Log in again
tsh login --proxy=teleport.sparks.works:443
```

### Logout

```bash
# Log out from all clusters
tsh logout
```

---

## Troubleshooting

### "Access Denied" Errors

If you get access denied errors, verify you have the `kirin-devs` role:

```bash
tsh status
```

Contact your Teleport administrator if the role is missing.

### Certificate Expired

```bash
# Check certificate expiry
tsh status

# If expired, re-authenticate
tsh login --proxy=teleport.sparks.works:443
```

### Connection Timeouts

```bash
# Test connectivity to the proxy
curl -v https://teleport.sparks.works:443

# Verify you can reach the cluster
tsh status
```

### SSH Key Issues

Teleport manages SSH keys automatically. If you encounter key issues:

```bash
# Remove cached credentials and re-login
rm -rf ~/.tsh/keys/teleport.sparks.works
tsh login --proxy=teleport.sparks.works:443
```

---

## Example: Complete AI Agent Workflow

Here's a complete example workflow for an AI agent working on Kirin:

```bash
# 1. Verify authentication
tsh status

# 2. Check if Kirin service is running
tsh ssh ubuntu@spark-ddb1 "systemctl is-active kirin-bot"

# 3. Read current configuration
tsh ssh ubuntu@spark-ddb1 "cat /etc/kirin-bot/config.yaml"

# 4. View recent logs
tsh ssh ubuntu@spark-ddb1 "journalctl -u kirin-bot -n 100 --no-pager"

# 5. Make changes to a file (example)
tsh ssh ubuntu@spark-ddb1 "echo 'new setting: value' >> /etc/kirin-bot/config.yaml"

# 6. Restart the service
tsh ssh ubuntu@spark-ddb1 "sudo systemctl restart kirin-bot"

# 7. Verify the service started successfully
tsh ssh ubuntu@spark-ddb1 "systemctl status kirin-bot"

# 8. Watch logs in real-time (if needed)
tsh ssh ubuntu@spark-ddb1 "journalctl -u kirin-bot -f"
```

---

## Quick Reference Card

```bash
# Authentication
tsh login --proxy=teleport.sparks.works:443
tsh status
tsh logout

# SSH Access
tsh ssh ubuntu@spark-ddb1
tsh ssh ubuntu@spark-ddb1 "command"

# File Transfer
tsh scp file.txt ubuntu@spark-ddb1:/path/
tsh scp ubuntu@spark-ddb1:/path/file.txt ./

# Application Access
tsh apps login kirin-bot
tsh apps logout kirin-bot

# Port Forwarding
tsh ssh -L 8080:localhost:666 ubuntu@spark-ddb1

# List Resources
tsh ls                  # SSH nodes
tsh apps ls            # Applications
```

---

## Security Best Practices

1. **Never share your credentials** - Each developer should have their own Teleport account
2. **Use passkeys** - More secure than passwords
3. **Keep sessions short** - Log out when done
4. **Audit your sessions** - Check `tsh sessions ls` regularly
5. **Report suspicious activity** - Contact your security team if you notice unauthorized access

---

## Additional Resources

- **Teleport Documentation**: https://goteleport.com/docs/
- **Teleport CLI Reference**: https://goteleport.com/docs/reference/cli/tsh/
- **Kirin-Bot Source**: Contact your team lead for repository access
- **Support**: Contact your Teleport administrator

---

## For AI Agents: Key Capabilities

AI coding assistants working with this setup can:

- ✅ Execute commands on `spark-ddb1` via `tsh ssh`
- ✅ Read and write files via `tsh scp` or remote commands
- ✅ Restart services and view logs
- ✅ Access the Kirin-Bot web interface for testing
- ✅ Use port forwarding for local development/debugging
- ✅ Operate non-interactively using command execution patterns

**Important**: Always verify commands before execution, especially those with `sudo` or that modify system files.

---

**Last Updated**: December 1, 2025  
**Teleport Version**: 15.5.4  
**Maintained By**: Teleport Administrator

