# Use the official Alpine Linux image as the base image
FROM alpine:latest

# Update package repositories and install any necessary dependencies
RUN apk update && \
    apk add --no-cache docker

# Copy the chealth.sh script into the container's /usr/local/bin/ directory
COPY chealth.sh /usr/local/bin/

# Give execute permission to the script
RUN chmod +x /usr/local/bin/chealth.sh

# Set the working directory to /usr/local/bin/
WORKDIR /usr/local/bin/

# Define the command to be executed when the container starts
ENTRYPOINT ["sh", "/usr/local/bin/chealth.sh"]
