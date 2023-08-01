#!/bin/bash

# Function to check the health status of a container
check_health_status() {
    container_name="$1"
    health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container_name")
    echo "$health_status"
}

# Function to restart a container
restart_container() {
    container_name="$1"
    echo "Restarting container: $container_name"
    docker restart "$container_name"
}

# Function to log errors to journalctl
log_error() {
    error_message="$1"
    echo "Error: $error_message" >&2
    logger -p err -t DockerStatus "$error_message"
}

# Read container names from the external file
containers_file="chealth.conf"
containers=()

if [ -f "$containers_file" ]; then
    while IFS= read -r line; do
        containers+=("$line")
    done < "$containers_file"
else
    echo "Error: $containers_file not found. Please create the file and add container names, one per line."
    exit 1
fi

# Main loop
while true; do
    for container in "${containers[@]}"; do
        health_status=$(check_health_status "$container")
        echo "Container: $container, Health Status: $health_status"

        if [[ "$health_status" != "healthy" ]]; then
            restart_container "$container"
            log_error "Container '$container' is unhealthy, attempting to restart it."
        fi
    done

    sleep 30
done
