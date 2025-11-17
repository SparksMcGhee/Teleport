# This page lists instructions for AI agents making contributions to this repository

# High-level description
This repository is to be in the form of a set of custom Ansible roles which would build an open-source Teleport deployment which will meet the project goals (listed below)

# Development approach
- Agents may connect directly to both Public and Private nodes in .env and make changes as deemed necessary, provided all changes are reflected in the Ansible codebase
- Agents may NOT make changes to the host machine being developed from outside of altering files in this repository 

# Critical requirements 
- Secrets and IPs must be declared in the project's .env file and then referenced as variables to ensure the resulting codebase can be readily re-used by others and can be safely checked into Github
- Agents should not make changes to #AgentInstructions.md, but may suggest changes 

# Key limitations 
- The private side of this Teleport deployment is fully NATed with no option to forward ports. In other words all connections from the private to public side must be outbound. 
    - It is acceptable to set up a Wiregaurd tunnel between the two nodes as part of this deployment if required, but it should be set up along with the other configurations

# Project Goals 
- The goal is to create a Teleport (as in goTeleport.com) deployment to enable secure access from the interent into my home lab and home network 
- This Teleport deployment should consist of two nodes: 
    - Public Node: 
        - A Digital Ocean droplet with a public IP which will serve as the publicly-facing Teleport proxy node as well as hosting the Auth service
        - This project's .env file has IP information as well as paths to mangement certs (all variables starting with `Public_Node`)
        - The node's public IP has a DNS listing ($ENV:Teleport_Public_Name) so it can request publically-trusted certificates via ACME
    - Private Node: 
        - A dedicated VM within my home network to host things like the Teleport application access services
        - This project's .env file has IP information as well as paths to mangement certs (all variables starting with `Private_Node`)
        - The private node can make outbound web connections 
- Both VMs are currently on the same Tailscale Tailnet, but it is hoped this will not be required for the operation of the deployment long-term. 
- This projectis to be deployable via Ansible, meaning the code should be constructed as Ansible roles for Public_Node and Private_Node
- The Teleport service itself should be set up to authenticate users via passkey (IE passwordless) 

# Style Guide 
- Less is more: Simpler code with fewer branches is strongly preferred 
- Fail fast: Code should halt when it encounters unexpected situations rather then attempting to fix or route around issues