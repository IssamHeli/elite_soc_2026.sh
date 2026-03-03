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
