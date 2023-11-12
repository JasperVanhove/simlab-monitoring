# Simlab1 Monitoring
This repository contains the setup for the monitoring of our setup in Simlab1. It contains the following components:
- `docker-compose.yml`: The docker-compose file that defines the containers for our setup.
- `config/`: The configuration files for the different components.
- `dashboards/`: The dashboards we can import into grafana.
- `install.sh`: A script that installs and configures all the necessary packages.
- `setup.sh`: A script that sets up the monitoring environment.

## Setup
To install the necessary packages for the monitoring environment, run the following command:
```bash
sudo chmod +x install.sh
./install.sh
```

After successfully installing the necessary packages, you can run the following command to setup the monitoring environment:
```bash
cd config/influxdb
sudo chmod +x setup.sh
./setup.sh

cd ../..
sudo chmod +x setup.sh
./setup.sh
```