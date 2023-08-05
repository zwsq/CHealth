#!/bin/sh

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
    echo "$(date +'%Y-%m-%d %H:%M:%S') - DockerStatus: $error_message" | logger -p user.err
}

# Main loop
while true; do
    # Read container names from chealth.conf file
    containers_file="chealth.conf"

    if [ -f "$containers_file" ]; then
        while IFS= read -r container; do
            health_status=$(check_health_status "$container")
            echo "Container: $container, Health Status: $health_status"

            if [ "$health_status" != "healthy" ]; then
                restart_container "$container"
                log_error "Container '$container' is unhealthy and was restarted."
            fi
        done < "$containers_file"
    else
        echo "Error: $containers_file not found. Please create the file and add container names, one per line."
        exit 1
    fi

    sleep 30
done