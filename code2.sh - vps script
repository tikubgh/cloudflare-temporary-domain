rm -f setup.sh
cat > setup.sh << 'EOF'
#!/bin/bash
sudo systemctl stop cftunnel.service 2>/dev/null
sudo systemctl disable cftunnel.service 2>/dev/null
if ! command -v cloudflared &> /dev/null; then
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt-get update && sudo apt-get install -y cloudflared
fi
read -p "Enter your Cloudflare Worker URL: " BASE_URL
WORKER_URL="${BASE_URL%/}/update"
SECRET="my_super_secret_password"
sudo tee /etc/logrotate.d/cftunnel > /dev/null << 'LOG_EOF'
/var/log/cf-quick.log {
size 10M
rotate 2
missingok
notifempty
copytruncate
}
LOG_EOF
sudo tee /usr/local/bin/tunnel-runner.sh > /dev/null << 'SCRIPT_EOF'
#!/bin/bash
WORKER_URL="REPLACE_URL"
SECRET="REPLACE_SECRET"
pkill -f "cloudflared tunnel"
> /var/log/cf-quick.log
cloudflared tunnel --edge-ip-version auto --protocol http2 --no-autoupdate --url http://127.0.0.1:80 > /var/log/cf-quick.log 2>&1 &
TUNNEL_PID=$!
tail -f /var/log/cf-quick.log | grep --line-buffered -oE 'https://[a-zA-Z0-9-]+\.trycloudflare\.com' | while read -r URL; do
for i in 1 2 3; do
curl -s -f -X POST "$WORKER_URL" -H "Content-Type: application/json" -d "{\"url\":\"$URL\",\"secret\":\"$SECRET\"}" && break
sleep 2
done
done &
TAIL_PID=$!
wait $TUNNEL_PID
kill $TAIL_PID 2>/dev/null
SCRIPT_EOF
sudo sed -i "s|REPLACE_URL|$WORKER_URL|g" /usr/local/bin/tunnel-runner.sh
sudo sed -i "s|REPLACE_SECRET|$SECRET|g" /usr/local/bin/tunnel-runner.sh
sudo chmod +x /usr/local/bin/tunnel-runner.sh
sudo tee /etc/systemd/system/cftunnel.service > /dev/null << 'SVC_EOF'
[Unit]
Description=Cloudflare Tunnel Auto-Updater
After=network-online.target
Wants=network-online.target
[Service]
Type=simple
ExecStart=/bin/bash /usr/local/bin/tunnel-runner.sh
Restart=always
RestartSec=5
[Install]
WantedBy=multi-user.target
SVC_EOF
sudo systemctl daemon-reload
sudo systemctl enable --now cftunnel.service
EOF
bash setup.sh
