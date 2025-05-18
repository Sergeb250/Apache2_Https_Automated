# Apache2_Https_Automated

# 🔐 Automated HTTPS Setup Script

### by **Serge Benit** – Cybersecurity Researcher

---

## 🧾 Overview

This project is a **bash script** designed to automate the generation and deployment of a **self-signed SSL certificate** and configure it with **Apache2** for HTTPS access. It simplifies the process of securing a domain or IP address by handling certificate creation, Apache configuration, and basic testing in one go.

Ideal for:
- Local development environments
- Internal tools requiring encrypted traffic
- Educational and research purposes

> ⚠️ *Not for use in production environments where trusted CA certificates are required.*

---

## 📦 Features

- Interactive input for SSL metadata (Country, State, Domain, etc.)
- Auto-generates a 2048-bit self-signed SSL certificate
- Configures Apache to force HTTPS with SSL
- Deploys a test page to verify SSL setup
- Displays a success message with verification status

---

## 🛠️ Requirements

- Ubuntu/Debian-based system
- Root privileges
- Apache2 installed  
  ```bash
  sudo apt update && sudo apt install apache2 -y
openssl, curl installed

bash
Copy
Edit
sudo apt install openssl curl -y
🚀 How to Use
Save the script as auto-https.sh.

Make it executable:

bash
Copy
Edit
chmod +x auto-https.sh
Run the script as root:

bash
Copy
Edit
sudo ./auto-https.sh
You'll be prompted to enter certificate details like:

yaml
Copy
Edit
Country (2-letter code): RW  
State/Province: Kigali  
Locality/City: Remera  
Organization: AUCA  
Organizational Unit: CyberSec Lab  
Common Name (e.g., name_ID): serge-benit  
Domain/IP to secure: example.local  
After successful setup, access the test page:

arduino
Copy
Edit
https://your-domain-or-ip/sslTest.html
🧪 Sample Output
csharp
Copy
Edit
[1/4] Generating SSL Certificate
[2/4] Configuring Apache
[3/4] Creating SSL Test Page
[4/4] Testing Configuration

[SUCCESS] SSL is working! Access:
🔗 https://your-domain-or-ip/sslTest.html


SSL configuration completed successfully!
📁 Output Files
File Path	Purpose
/etc/ssl/private/ssl.key	SSL Private Key
/etc/ssl/certs/ssl.crt	SSL Certificate
/etc/apache2/sites-available/ssl.conf	Apache SSL config
/var/www/html/sslTest.html	Test HTML file

❗ Notes
Make sure port 443 is open and not blocked by firewalls.

For production-grade SSL, consider Let's Encrypt.

You can access logs at:

bash
Copy
Edit
cat /var/log/apache2/error.log



👨‍💻 Author

Serge Benit
Cybersecurity Researcher

📧 hacksergeb@gmail.com

🌍 Kigali, Rwanda
