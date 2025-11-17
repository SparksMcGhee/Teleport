📋 **Next Steps:**
1. Install Ansible:
   sudo apt-get install ansible
   
2. Deploy public node:
   ./scripts/deploy.sh playbooks/deploy.yml --limit public_node
   
3. Add generated token to .env file
   
4. Deploy private node:
   ./scripts/deploy.sh playbooks/deploy.yml --limit private_node

🔍 **Validation:**
Run ./scripts/validate_setup.sh to check configuration

