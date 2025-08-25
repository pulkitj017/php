# Define the installation directory (replace with your preferred path)
INSTALL_DIR="$HOME/bin"
PROJECT_DIR=$(pwd)
echo $PROJECT_DIR
# Install Trivy
echo "Installing Trivy..."
sudo curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b "$INSTALL_DIR" v0.50.4
"$INSTALL_DIR/trivy" fs --scanners vuln --format table --output trivy-vulnerabilities.txt "$PROJECT_DIR"
cd "$PROJECT_DIR"
