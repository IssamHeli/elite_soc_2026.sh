# elite_soc_2026.sh
This script is designed for Ubuntu 24.04 LTS. It installs the "Golden Stack": Wazuh (SIEM), Shuffle (SOAR), and MISP (Threat Intel), while configuring the kernel for high-performance security indexing.



The Elite 2026 Master Setup Script

Create the script: nano elite_soc_2026.sh

Paste the code below:

Bash
#!/bin/bash

# --- COLORING FOR OUTPUT ---
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] Starting Elite SOC 2026 Deployment...${NC}"

# --- 1. OS HARDENING & OPTIMIZATION ---
echo -e "${GREEN}[*] Hardening Ubuntu 24.04 Kernel...${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git docker.io docker-compose-v2 jq

# OpenSearch (Wazuh) requires high memory map counts
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf

# --- 2. WAZUH SIEM (The Commander) ---
echo -e "${GREEN}[*] Installing Wazuh 4.9+ (All-in-One)...${NC}"
curl -sO https://packages.wazuh.com/4.9/wazuh-install.sh
sudo bash wazuh-install.sh -a -i

# --- 3. SHUFFLE SOAR (The Automator) ---
echo -e "${GREEN}[*] Deploying Shuffle SOAR (Docker)...${NC}"
mkdir -p ~/shuffle && cd ~/shuffle
git clone https://github.com/Shuffle/Shuffle.git .
# Fix permissions for the database volume
mkdir -p shuffle-database && sudo chown -R 1000:1000 shuffle-database
sudo docker compose up -d

# --- 4. MISP THREAT INTEL (The Intelligence) ---
echo -e "${GREEN}[*] Deploying MISP via Docker for Threat Ingestion...${NC}"
cd ~
git clone https://github.com/coolacid/docker-misp.git
cd docker-misp
# Copy template and start (standard for 2026 local labs)
cp template.env .env
sudo docker compose up -d

# --- 5. POST-INSTALLATION CLEANUP ---
echo -e "${GREEN}-------------------------------------------------------${NC}"
echo -e "${GREEN}✅ ELITE SOC 2026 IS LIVE!${NC}"
echo -e "Wazuh Dashboard: https://$(hostname -I | awk '{print $1}')"
echo -e "Shuffle SOAR: http://$(hostname -I | awk '{print $1}'):3001"
echo -e "MISP Intel: http://$(hostname -I | awk '{print $1}'):8080"
echo -e "-------------------------------------------------------"
echo -e "Credentials for Wazuh located in: /var/log/wazuh-install.log"
Run the script:

Bash
chmod +x elite_soc_2026.sh
sudo ./elite_soc_2026.sh
🎓 Why this script is "Elite" for your PFE

Kernel Tuning: Most students fail because vm.max_map_count defaults to 65530, causing Wazuh's database to crash instantly. This script pre-emptively fixes that.

Threat Intel (MISP): Adding MISP moves you from a "Log Collector" to a "Threat Hunter." You can now cross-reference IP addresses found in Wazuh with global malware databases.

Shuffle SOAR: The script includes the permission fix (chown 1000:1000) for the Shuffle database, which is a common "bug" that stops automation workflows from starting.

💡 The "Killer" Presentation Point

During your defense, mention that you used a modular microservices approach:

Host-based Protection: Wazuh Manager.

Automated Response: Shuffle (SOAR).

Intel Correlation: MISP.

Containerization: Using Docker-Compose ensures that your SOC can be scaled or migrated to a real production cloud server in minutes.
