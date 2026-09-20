# cloudflare-temporary-domain
generates cloudflare temporary domain for = domain-for-ipv6.sh

## 1. Cloudflare Worker & KV Database Setup

- Log in to the Cloudflare Dashboard and navigate to Storage & Database -> Workers KV.

- Click Create a namespace, name it exactly TUNNEL_DB, and click Add.

- Go back to Compute > Workers & Pages, click Create application -> Create Worker, and deploy the default Hello World.

- On your new Worker's overview page, go to Bindings > Add Binding > KV Namespace Bindings and click Add binding. Set the Variable name to TUNNEL_DB, select your TUNNEL_DB namespace from the dropdown, and save.

- Click Edit code in the top right corner, replace everything with the script code1 in worker, and click Deploy and finally run code2.sh in vps terminal.
