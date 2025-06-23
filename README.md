# Service Availability Monitor

A Bash script that monitors service availability via ping and sends email alerts when services are down.

## Features
- Checks availability of multiple IPs/services
- Sends email alerts when a service is down
- Configurable via Cron for scheduled execution
- Simple configuration

## Requirements
- Bash
- mailutils (for email notifications)
- ping (available on most systems)