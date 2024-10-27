#!/bin/bash

# Set the base directory to search
BASE_DIR="$1"

# Generate unique image and container names using a timestamp
TIMESTAMP=$(date +%s)
IMAGE_NAME="image_$TIMESTAMP"
CONTAINER_NAME="container_$TIMESTAMP"

# Find the Dockerfile (either at the root or in an app subdirectory)
DOCKERFILE_PATH=$(find "$BASE_DIR" -type f -name Dockerfile \( -path "$BASE_DIR/Dockerfile" -o -path "$BASE_DIR/app/Dockerfile" \) | head -n 1)

# Check if Dockerfile is found
if [ -z "$DOCKERFILE_PATH" ]; then
  echo "No Dockerfile found in $BASE_DIR or $BASE_DIR/app"
  exit 1
fi

# Change to the root directory of the repository containing the Dockerfile
REPO_DIR=$(git -C "$DOCKERFILE_PATH" rev-parse --show-toplevel 2>/dev/null || dirname "$DOCKERFILE_PATH")
cd "$REPO_DIR" || exit

# Build the Docker image
echo "Building Docker image from $DOCKERFILE_PATH with name $IMAGE_NAME..."
docker build -t "$IMAGE_NAME" .

# Run the Docker container with a unique name
echo "Running Docker container with name $CONTAINER_NAME..."
docker run --rm --name "$CONTAINER_NAME" -d -p 5001:5000 "$IMAGE_NAME"

# Give the container a few seconds to start up
sleep 5

# Check for a 200 response from localhost:5001/
echo "Checking for a 200 response from http://localhost:5001/..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:5001/ | grep -q "200"; then
  echo "Received 200 response - Container is running successfully."
else
  echo "Did not receive 200 response - There may be an issue with the container."
fi

# Stop and remove the container after the check
echo "Stopping and removing container $CONTAINER_NAME..."
docker stop "$CONTAINER_NAME"
docker rm "$CONTAINER_NAME" > /dev/null 2>&1

# Clean up the entire code repository
echo "Removing entire repository: $REPO_DIR"
cd "$BASE_DIR" || exit  # Return to the base directory before deletion
rm -rf "$REPO_DIR"

# Confirm removal
echo "Container has been stopped, removed, and repository has been deleted."

