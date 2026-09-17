 1.installation:
 curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null && echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared jammy main' | sudo tee /etc/apt/sources.list.d/cloudflared.list && sudo apt-get update && sudo apt-get install -y cloudflared && cloudflared tunnel --url http://127.0.0.1:80

 2.For ipv6:
 cloudflared tunnel --edge-ip-version 6 --url http://127.0.0.1:80

 3.For ipv6 visible domain:
 cloudflared tunnel --edge-ip-version 6 --url http://127.0.0.1:80 2>&1 | grep --line-buffered -oE "https://[a-zA-Z0-9-]+\.trycloudflare\.com"
 
