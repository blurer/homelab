#!/bin/bash
# Prompt for the service name
read -p "What service: " SERVICE_NAME
# Create a new Cloudflare tunnel
echo "-> Creating Cloudflare tunnel for $SERVICE_NAME..." TUNNEL_OUTPUT=$(cloudflared tunnel create "$SERVICE_NAME" 2>&1)
# Extract the tunnel ID and credentials file path
TUNNEL_ID=$(echo "$TUNNEL_OUTPUT" | grep -oP 'Created tunnel with ID \K[^\s]+') CREDENTIALS_FILE=$(echo "$TUNNEL_OUTPUT" | grep -oP 'Credentials file created at \K[^\s]+')
# Check if the tunnel was created successfully
if [[ -z "$TUNNEL_ID" || -z "$CREDENTIALS_FILE" ]]; then echo "Error: Failed to create tunnel. Please check the output below:" echo "$TUNNEL_OUTPUT" exit 1 fi
# Construct the DNS record
CFARGO_DOMAIN="${TUNNEL_ID}.cfargotunnel.com"
# Display the results
echo "-> Tunnel created successfully!" echo "-> Backend JSON file: $CREDENTIALS_FILE" echo "-> DNS record for $SERVICE_NAME: $CFARGO_DOMAIN" echo "-> Kubernetes secret creation command:" echo " kubectl -n $SERVICE_NAME create secret generic tunnel-credentials 
--from-file=credentials.json=$CREDENTIALS_FILE"
# Optional: Add cleanup instructions
echo "-> Note: To delete this tunnel, run: cloudflared tunnel delete $SERVICE_NAME"
