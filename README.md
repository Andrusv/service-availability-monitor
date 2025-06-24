# Service Availability Monitor 🚨  

**Automated service health monitoring with instant email alerts - never miss a downtime event again.**  

![Network Monitoring](https://cdn-icons-png.flaticon.com/512/3059/3059518.png)

## 🔍 Overview  
A **Bash-based monitoring solution** that continuously checks your critical servers and services, sending immediate email alerts when issues are detected. Perfect for DevOps teams needing reliable infrastructure monitoring without complex setups.

### ⚙️ Core Features  
- **Multi-server monitoring** via ICMP ping (supports both IPs and hostnames)  
- **Instant email alerts** through `mailutils` integration  
- **Cron-powered scheduling** for continuous monitoring  
- **Detailed activity logging** with timestamps  
- **Configurable thresholds**:  
  - Adjustable ping attempts (`MAX_RETRIES=3`)  
  - Customizable timeout periods (`RETRY_DELAY=5`)  
- **Self-healing architecture** with automatic retry logic

## 🛠️ Technical Architecture  

### 📜 Monitoring Logic  
1. **Pre-Flight Checks**:  
   - Validates `mailutils` installation  
   - Verifies configuration files exist (`servers.list`, `email.conf`)  
   - Ensures log directory structure exists

2. **Health Checking**:  
   - Performs 3 ping attempts with 2-second timeout per server  
   - Uses `ping -c 3 -W 2` for reliable network testing  

3. **Alerting System**:  
   - Triggers SMTP alerts via `mail -s` when failures occur  
   - Includes server details and timestamp in notification body  

4. **Logging**:  
   - Writes detailed operational logs to `logs/monitor.log`  
   - Formats entries for easy parsing:  
     ```log
     2023-11-15 14:30:45: ERROR - Server 192.168.1.100 not responding
     ```
   - Automatic log rotation (via logrotate or cron)

5. **Self-Contained Configuration**:  
   - Server list in `config/servers.list` (supports comments):  
     ```text
     # Production Servers
     8.8.8.8    # Google DNS
     10.0.1.15   # Internal API
     ```
   - Email settings in `config/email.conf`:  
     ```bash
     ALERT_EMAIL="ops-team@yourcompany.com"
     SUBJECT_PREFIX="[CRITICAL]"
     ```

## 🚀 Instant Deployment  

### Prerequisites  
- Linux/Unix system with Bash  
- `mailutils` package configured for SMTP  
- Cron daemon running (for scheduled checks)  

### One-Command Setup & Execution  
```bash
git clone https://github.com/Andrusv/service-availability-monitor.git && \
cd service-availability-monitor && \
chmod +x scripts/monitor.sh && \
sudo apt-get install -y mailutils && \
mkdir -p logs && touch logs/monitor.log && \
./scripts/monitor.sh
```

### One-Command Scheduled Monitoring (Cron Job) ⏲️
```bash
# Add to crontab (run every 5 minutes)
(crontab -l 2>/dev/null; echo "*/5 * * * * $(pwd)/scripts/monitor.sh >> $(pwd)/logs/monitor.log 2>&1") | crontab -
```