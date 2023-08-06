[![Docker Image Build and Push](https://github.com/zwsq/CHealth/actions/workflows/docker-image.yml/badge.svg)](https://github.com/zwsq/CHealth/actions/workflows/docker-image.yml)
# Docker Container Health Check Script

The Docker Container Health Check Script is a bash script that monitors the health status of Docker containers and automatically restarts them if they are unhealthy. This script runs in the background as a systemd service and logs its activities to journalctl.

## Requirements

- Linux-based operating system
- Docker installed and configured

## Installation
  
### I) Using Docker
1. You need to create a chealth.conf file and put the desired container names in each line of the file.
2. Now you can use following docker run command to start the healthchecker container. Remember to replace the /etc/chealth.conf with your chealth.conf file address on your machine in docker run command.
```bash
docker run -d --name=CHealth -v /etc/chealth.conf:/usr/local/bin/chealth.conf -v /var/run/docker.sock:/var/run/docker.sock:ro zwsq/chealth:14
```
#### Note: Since the container need to know the status of the host containers, acess to the docker.sock file of the host is required.
### II) Using bash and systemd
1. Clone the repository to your desired location:

```bash
git clone https://github.com/zwsq/CHealth.git
```
2. Go to the downloaded directory:

```bash
cd CHealth
```
3. Make the script executable:
```bash
sudo chmod +x chealth.sh
```
4. Add the names of the Docker containers you want to monitor, one per line in the chealth.conf file.
```
container1
container2
container3
```
5. Open the chealth.service file in an editor and modify `ExecStart` and `WorkingDirectory` according to the location of chealth.sh file on your machine.
```bash
sudo nano chealth.service
```

```
WorkingDirectory=/path/to/chealth/directory
ExecStart=/path/to/chealth/directory/chealth.sh
```
6. Copy `chealth.service` file you `/etc/systemd/system` and reload systemd daemon.
```bash
sudo cp chealth.sh /etc/systemd/system && sudo systemctl daemon-reload
```
7. Now you can enable and start the service.
```bash
sudo systemctl enable --now chealth.service
```

## Customization
Changing the Check Interval: If you want to modify the check interval, you can edit the sleep duration in the script. For example, to check every 60 seconds, change sleep 30 to sleep 60.

Adding/Removing Containers: To add or remove containers to be monitored, simply edit the containers.txt file, adding or removing container names as needed. The script will automatically pick up the changes during its next iteration.

## Contributing
Contributions are welcome! If you find any issues or have suggestions for improvements, please create an issue or submit a pull request.

## License
This project is licensed under the MIT License.
