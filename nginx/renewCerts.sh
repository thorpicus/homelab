 #!/bin/bash

# Configuration
CERT_DIR="./certificates"
NGINX_CONTAINER="local-nginx-proxy"
DOMAIN="athome.taile8f2ff.ts.net"

echo "=== Starting Tailscale Certificate Renewal Process ==="

# Ensure the cert directory exists on the host
mkdir -p "$CERT_DIR"

# List of subdomains
declare -a arr=("photos" "music" "monitoring" "registry" "assistant" "wine-server" "wine" "nas" "tv")

# Track if any certificate fails
ANY_FAILED=0


# Default domain
# Run tailscale cert (Fixed case sensitivity and removed semicolon after 'do')
tailscale cert --cert-file="${CERT_DIR}/${DOMAIN}.crt" --key-file="${CERT_DIR}/${DOMAIN}.key" "${DOMAIN}"
# Check if the command failed for this specific subdomain
if [ $? -ne 0 ]; then
    echo "WARNING: Failed to fetch certificate for ${DOMAIN}"
    ANY_FAILED=1
fi


# 1. Fetch/renew the certificates using the host's tailscale CLI
for server in "${arr[@]}"
do
    # Construct the full FQDN for this subdomain
    FULL_DOMAIN="${server}.${DOMAIN}"
    
    echo "Fetching certificate for: ${FULL_DOMAIN}..."
    
    # Run tailscale cert (Fixed case sensitivity and removed semicolon after 'do')
    tailscale cert --cert-file="${CERT_DIR}/${FULL_DOMAIN}.crt" --key-file="${CERT_DIR}/${FULL_DOMAIN}.key" "${FULL_DOMAIN}"
    
    # Check if the command failed for this specific subdomain
    if [ $? -ne 0 ]; then
        echo "WARNING: Failed to fetch certificate for ${FULL_DOMAIN}"
        ANY_FAILED=1
    fi
done

# Evaluate the overall health of the loop execution
if [ $ANY_FAILED -eq 0 ]; then
    echo "Certificates successfully generated/renewed on host."
    
    # Correct file permissions (Removed quotes around wildcards so expansion works)
    chmod 644 ${CERT_DIR}/*.crt
    chmod 600 ${CERT_DIR}/*.key

    # 2. Tell NGINX inside Docker to gracefully reload the new certificates
    echo "Reloading NGINX configuration inside Docker container..."
    docker exec $NGINX_CONTAINER nginx -s reload
    
    echo "=== Renewal completed successfully ==="
else
    echo "ERROR: One or more Tailscale certificates failed to generate."
    exit 1
fi
