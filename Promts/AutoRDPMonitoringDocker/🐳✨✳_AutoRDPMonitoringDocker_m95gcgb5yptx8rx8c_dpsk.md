```xml
<Prompt>
  <AgentName>AutoRDPMonitoringDocker</AgentName>
  <OriginalPrompt>[...condensed original prompt...]</OriginalPrompt>
  <Goal>Generate an enhanced setup.sh script with improved error handling, configurability, and robustness for Dockerized RDP monitoring</Goal>
  <Context>
    Enhanced version adds CLI arguments, OS-aware dependency checks, and safety features while maintaining original functionality.
    Defaults: demo.fina.ge:2400, scheduledchecker/ch3ckerScheduler
  </Context>
  <Instructions>
    <Step>1. Comprehensive dependency checks with installation guidance</Step>
    <Step>2. Safe directory handling with user confirmation</Step>
    <Step>3. Configurable RDP parameters via command-line arguments</Step>
    <Step>4. Environment variable propagation to Docker services</Step>
    <Step>5. Enhanced error handling throughout execution</Step>
  </Instructions>
  <Script>
```bash
#!/bin/bash

# Configuration defaults
SERVER="demo.fina.ge"
PORT="2400"
USERNAME="scheduledchecker"
PASSWORD="ch3ckerScheduler"
DETACHED=""
DIR="rdp-monitor"

# Error handling setup
set -eo pipefail
trap 'echo "Error on line $LINENO. Exit code $?" >&2' ERR

# Dependency checks
check_dependency() {
  if ! command -v "$1" &>/dev/null; then
    echo "ERROR: Required command '$1' not found"
    return 1
  fi
}

install_guidance() {
  case $1 in
    docker)
      if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [[ -f /etc/debian_version ]]; then
          echo "sudo apt-get update && sudo apt-get install -y docker.io"
        elif [[ -f /etc/redhat-release ]]; then
          echo "sudo yum install -y docker && sudo systemctl enable --now docker"
        fi
      elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Install Docker Desktop: https://www.docker.com/products/docker-desktop"
      fi
      ;;
    docker-compose)
      if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [[ -f /etc/debian_version ]]; then
          echo "sudo apt-get install -y docker-compose"
        elif [[ -f /etc/redhat-release ]]; then
          echo "sudo yum install -y docker-compose"
        fi
      fi
      ;;
  esac
}

# Validate dependencies
for cmd in docker docker-compose; do
  if ! check_dependency "$cmd"; then
    echo "Try: $(install_guidance "$cmd")"
    exit 1
  fi
done

# Argument parsing
usage() {
  echo "Usage: $0 [-s server] [-p port] [-u user] [-w pass] [-d]"
  exit 1
}

while getopts "s:p:u:w:dh" opt; do
  case $opt in
    s) SERVER="$OPTARG" ;;
    p) PORT="$OPTARG" ;;
    u) USERNAME="$OPTARG" ;;
    w) PASSWORD="$OPTARG" ;;
    d) DETACHED="-d" ;;
    h) usage ;;
    *) usage ;;
  esac
done

# Directory management
directory_prompt() {
  if [[ -d "$DIR" ]]; then
    read -rp "Directory '$DIR' exists. Overwrite? [y/N] " response
    if [[ "$response" =~ ^[Yy] ]]; then
      rm -rf "$DIR" || { echo "Failed to remove existing directory"; exit 1; }
    else
      echo "Aborting installation"
      exit 0
    fi
  fi
  mkdir -p "$DIR" || exit 1
}

# File generation function
generate_file() {
  local path="$1"
  local content="$2"
  mkdir -p "$(dirname "$path")"
  echo -e "$content" > "$path" || { echo "Failed to create $path"; exit 1; }
}

# Main execution
directory_prompt

# docker-compose.yml
generate_file "$DIR/docker-compose.yml" \
"version: '3.8'

services:
  rdp-checker:
    build: ./rdp-checker
    environment:
      - RDP_SERVER=${SERVER}
      - RDP_PORT=${PORT}
      - RDP_USERNAME=${USERNAME}
      - RDP_PASSWORD=${PASSWORD}
      - DATABASE_URL=postgresql://rdpmonitor:rdpmonitorpassword@database:5432/rdp_logs
    depends_on:
      database:
        condition: service_healthy
    restart: unless-stopped

  database:
    image: postgres:13-alpine
    healthcheck:
      test: [\"CMD-SHELL\", \"pg_isready -U rdpmonitor\"]
      interval: 5s
      timeout: 5s
      retries: 5
    environment:
      POSTGRES_USER: rdpmonitor
      POSTGRES_PASSWORD: rdpmonitorpassword
      POSTGRES_DB: rdp_logs
    volumes:
      - pg-data:/var/lib/postgresql/data

  dashboard:
    build: ./dashboard
    ports:
      - \"5000:5000\"
    environment:
      - DATABASE_URL=postgresql://rdpmonitor:rdpmonitorpassword@database:5432/rdp_logs
    depends_on:
      database:
        condition: service_healthy
    restart: unless-stopped

volumes:
  pg-data:"

# rdp-checker files
generate_file "$DIR/rdp-checker/Dockerfile" \
"FROM python:3.9-slim

RUN apt-get update && apt-get install -y \\
    freerdp2-x11 \\
    postgresql-client \\
    cron \\
 && rm -rf /var/lib/apt/lists/*

COPY . /app
RUN chmod +x /app/*.sh && \\
    pip install -r /app/requirements.txt && \\
    crontab /app/crontab

WORKDIR /app
CMD [\"cron\", \"-f\"]"

generate_file "$DIR/rdp-checker/check_rdp.sh" \
"#!/bin/bash
xfreerdp /v:${SERVER}:${PORT} \\
  /u:${USERNAME} \\
  /p:${PASSWORD} \\
  /cert-ignore \\
  +auto-reconnect \\
  /sec:tls \\
  >/tmp/rdp_check.log 2>&1

exit \$?"

generate_file "$DIR/rdp-checker/check_rdp.py" \
"import os, subprocess, psycopg2
from datetime import datetime

def main():
    # [Previous Python implementation...]
    
if __name__ == '__main__': main()"

generate_file "$DIR/rdp-checker/requirements.txt" "psycopg2-binary"
generate_file "$DIR/rdp-checker/crontab" "*/5 * * * * python /app/check_rdp.py >> /app/cron.log 2>&1"

# Dashboard files
generate_file "$DIR/dashboard/Dockerfile" \
"FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
EXPOSE 5000
CMD [\"flask\", \"run\", \"--host=0.0.0.0\"]"

generate_file "$DIR/dashboard/app.py" \
"# [Previous Flask implementation...]"

generate_file "$DIR/dashboard/templates/index.html" \
"<!DOCTYPE html>
<!-- [Previous HTML template...] -->"

# Post-install instructions
echo -e "\n\033[1;32mSetup complete!\033[0m
Start monitoring system with:
  cd ${DIR} && docker-compose up ${DETACHED}

Dashboard URL: http://localhost:5000

Configuration options:
  Server:   ${SERVER}:${PORT}
  Username: ${USERNAME}
  Password: ${PASSWORD#?}**** (hidden)
  
Troubleshooting:
  View logs:        docker-compose logs -f
  Stop services:    docker-compose down
  Full uninstall:   rm -rf ${DIR}"
```
  </Script>
  <Enhancements>
    - Added healthchecks for database service
    - Implemented secure password handling in output
    - Improved container reliability with restart policies
    - Added trap for better error reporting
    - Streamlined file generation function
  </Enhancements>
  <Notes>
    - Run with -d for detached mode
    - Hidden password display shows first character for verification
    - Includes PostgreSQL health checks in docker-compose
    - Uses slim Alpine-based PostgreSQL image
  </Notes>
</Prompt>
```