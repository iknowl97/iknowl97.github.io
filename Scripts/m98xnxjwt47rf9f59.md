```bash
#!/bin/bash

# Find the Portainer container ID.
PORTAINER_CONTAINER_ID=$(docker ps --filter name=portainer --format "{{.ID}}")

# Check if the container ID was found.
if [ -n "$PORTAINER_CONTAINER_ID" ]; then
  echo "Stopping Portainer container: $PORTAINER_CONTAINER_ID"
  # Stop the Portainer container.
  docker stop "$PORTAINER_CONTAINER_ID"
  
  # Check the exit code of the stop command.
  if [ $? -ne 0 ]; then
    echo "Error stopping Portainer container. Exiting."
    exit 1
  fi

else
  echo "Portainer container not found."
  exit 1
fi

# Reset the Portainer password using the helper image.
echo "Resetting Portainer password..."
docker run --rm -v portainer_data:/data portainer/helper-reset-password

# Check the exit code of the reset command.
if [ $? -ne 0 ]; then
  echo "Error resetting Portainer password.  Check if the 'portainer_data' volume exists and is correctly configured.  Exiting."
  exit 1
fi

# Start the Portainer container.
if [ -n "$PORTAINER_CONTAINER_ID" ]; then
  echo "Starting Portainer container: $PORTAINER_CONTAINER_ID"
  docker start "$PORTAINER_CONTAINER_ID"

  # Check the exit code of the start command.
  if [ $? -ne 0 ]; then
    echo "Error starting Portainer container. Exiting."
    exit 1
  fi

  echo "Portainer password reset and container restarted.  The default username is 'admin' and the new password is 'password'."
else
  echo "Portainer container not found, cannot start."
fi

echo "Operation completed."
exit 0
```