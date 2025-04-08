```bash
#!/bin/bash

# Auto-detect Portainer container ID
PORTAINER_CONTAINER_ID=$(docker ps -q --filter "name=portainer")

# Check if Portainer container is running
if [ -z "$PORTAINER_CONTAINER_ID" ]; then
  echo "Portainer container not found. Please ensure Portainer is running or adjust the filter if necessary."
  exit 1
fi

echo "Portainer container ID: $PORTAINER_CONTAINER_ID"

# Stop the Portainer container
echo "Stopping Portainer container..."
docker stop "$PORTAINER_CONTAINER_ID"

# Reset the Portainer admin password
echo "Resetting Portainer admin password..."
docker pull portainer/helper-reset-password #ensure updated version
docker run --rm -v portainer_data:/data portainer/helper-reset-password

# Start the Portainer container
echo "Starting Portainer container..."
docker start "$PORTAINER_CONTAINER_ID"

echo "Portainer password reset process completed."
echo "Please check the output for the new admin password."
```