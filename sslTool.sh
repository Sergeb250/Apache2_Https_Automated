#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Banner
echo -e "${GREEN}"
cat << "EOF"
   _____ _____ _      ___  __  __      _          ____  
  / ___/ ___| |    / _ \|  \/  | ___| |__      |___ \ 
  \___ \___ \ |   | | | | |\/| |/ _ \ '_ \       __) |
   ___) |__) | |___| |_| | |  | |  __/ |_) |    / __/ 
  |____/____/|_____|\___/|_|  |_|\___|_.__/    |_____|
EOF
echo -e "                     Professional SSL Automation Tool${NC}\n"

# Root check
[ "$(id -u)" -ne 0 ] && echo -e "${RED}[ERROR] Run as root${NC}" && exit 1

# User inputs
echo -e "${YELLOW}[CONFIGURATION] Enter SSL Details:${NC}"
read -p "Country (2-letter code): " COUNTRY
read -p "State/Province: " STATE
read -p "Locality/City: " LOCALITY
read -p "Organization: " ORG
read -p "Organizational Unit: " UNIT
read -p "Common Name (e.g., name_ID): " CN
read -p "Domain/IP to secure: " DOMAIN

# Certificate generation
echo -e "\n${YELLOW}[1/4] Generating SSL Certificate${NC}"
mkdir -p /etc/ssl/{certs,private}
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/ssl.key \
    -out /etc/ssl/certs/ssl.crt \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORG/OU=$UNIT/CN=$CN" 2>/dev/null
chmod 600 /etc/ssl/private/ssl.key

# Apache configuration
echo -e "${YELLOW}[2/4] Configuring Apache${NC}"
a2enmod ssl rewrite >/dev/null 2>&1

cat > /etc/apache2/sites-available/ssl.conf <<EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    Redirect permanent / https://$DOMAIN/
</VirtualHost>

<VirtualHost *:443>
    ServerName $DOMAIN
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/ssl.crt
    SSLCertificateKeyFile /etc/ssl/private/ssl.key
    DocumentRoot /var/www/html
    
    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Create test page
echo -e "${YELLOW}[3/4] Creating SSL Test Page${NC}"
cat > /var/www/html/sslTest.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>SSL Connection Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .ssl-status { padding: 20px; border-radius: 5px; }
        .success { background: #d4edda; color: #155724; }
        .info { margin-top: 20px; padding: 15px; background: #e2e3e5; }
    </style>
</head>
<body>
    <h1>SSL Connection Test</h1>
    <div id="status" class="ssl-status success">
        <h2>🔒 Secure Connection Established</h2>
        <p>This page confirms your SSL configuration is working correctly.</p>
    </div>
    
    <div class="info">
        <h3>Certificate Information</h3>
        <p><strong>Issued To:</strong> $CN</p>
        <p><strong>Domain:</strong> $DOMAIN</p>
        <p><strong>Valid Until:</strong> $(date -d "+365 days" "+%Y-%m-%d")</p>
    </div>
    
    <script>
        document.getElementById('status').innerHTML += 
            '<p><strong>Protocol:</strong> ' + window.location.protocol + '</p>';
    </script>
</body>
</html>
EOF

# Permissions
chown -R www-data:www-data /var/www/html
a2ensite ssl.conf >/dev/null 2>&1
systemctl restart apache2

# Verification
echo -e "${YELLOW}[4/4] Testing Configuration${NC}"
if curl -sk https://$DOMAIN/sslTest.html | grep -q "Secure Connection Established"; then
    echo -e "${GREEN}[SUCCESS] SSL is working! Access:${NC}"
    echo -e "  🔗 https://$DOMAIN/sslTest.html"
    echo -e "\n${GREEN}SSL configuration completed successfully!${NC}"
else
    echo -e "${RED}[ERROR] SSL configuration failed${NC}"
    echo "Check /var/log/apache2/error.log for details"
fi
