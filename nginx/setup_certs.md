sudo snap install --classic certbot
sudo snap set certbot trust-plugin-with-root=ok
sudo snap install certbot-dns-cloudflare

sudo mkdir /etc/letsencrypt
sudo vi /etc/letsencrypt/cloudflare.ini

dns_cloudflare_api_token = [See nord pass]

sudo chmod 600 /etc/letsencrypt/cloudflare.ini

sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini -d amysackville.co.uk -d '*.amysackville.co.uk'


