# Teleport How-To Guides

This directory contains practical guides for working with the Teleport deployment.

## Available Guides

### [Kirin Developer Setup Guide](./KIRIN_DEV_SETUP.md)

**Audience**: New Kirin developers and their AI coding assistants

**Topics Covered**:
- Installing Teleport CLI (`tsh`)
- Authenticating to `teleport.sparks.works`
- SSH access to the Kirin development server (`spark-ddb1`)
- Application access to Kirin-Bot web interface
- File transfer operations
- AI agent development workflows
- Port forwarding for local development
- Troubleshooting common issues

**Quick Start**:
```bash
# Install tsh
curl -O https://cdn.teleport.dev/teleport-v15.5.4-linux-amd64-bin.tar.gz
tar -xzf teleport-v15.5.4-linux-amd64-bin.tar.gz
sudo cp teleport/tsh /usr/local/bin/

# Authenticate
tsh login --proxy=teleport.sparks.works:443 --user=<your-username>

# Connect to Kirin server
tsh ssh ubuntu@spark-ddb1
```

---

## Contributing

To add a new how-to guide:

1. Create a new markdown file in this directory
2. Use a descriptive filename (e.g., `DATABASE_BACKUP_HOWTO.md`)
3. Update this README with a link and description
4. Follow the existing format:
   - Clear prerequisites
   - Step-by-step instructions
   - Code examples
   - Troubleshooting section
   - Last updated date

---

## Guide Template

```markdown
# [Task Name] How-To Guide

**Audience**: [Who this guide is for]

**Prerequisites**:
- List requirements here

---

## Overview

Brief description of what this guide covers.

---

## Step 1: [First Step]

Instructions...

## Step 2: [Second Step]

Instructions...

---

## Troubleshooting

Common issues and solutions...

---

**Last Updated**: [Date]
```

---

**Maintained By**: Teleport Administrator  
**Last Updated**: December 1, 2025

