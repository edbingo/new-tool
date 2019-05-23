#!/bin/bash

TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED_B='\e[1;31m'

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Fully upgrades the system
echo -e $TEXT_RED_B'\e[1;31m'
echo "Updating apt repositories"
echo -e $TEXT_RESET
apt -qq update
echo -e $TEXT_RED_B'\e[1;31m'
echo "Updating system software"
echo -e $TEXT_RESET
apt -qq upgrade -y
echo -e $TEXT_RED_B'\e[1;31m'
echo "Done"
echo -e $TEXT_RESET
cd /

# Installs prerequired packages
echo -e $TEXT_RED_B'\e[1;31m'
echo "Installing curl, nodejs, sudo, gnupg, build-essential and dirmngr"
echo -e $TEXT_RESET
apt -qq install -y curl gnupg build-essential dirmngr sudo apt-transport-https ca-certificates && curl --fail -ssL -o setup-nodejs https://deb.nodesource.com/setup_8.x && bash setup-nodejs && apt install -y nodejs

# Fetches key from server
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
echo -e $TEXT_RED_B'\e[1;31m'
echo "Key fetched"
echo -e $TEXT_RESET

# Fetches RVM from server
\curl -sSL https://get.rvm.io | bash -s stable --rails
rvm install ruby-2.6.0
echo -e $TEXT_RED_B'\e[1;31m'
echo "RVM installed"
echo -e $TEXT_RESET

# Gets keys for passenger
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
echo -e $TEXT_RED_B'\e[1;31m'
echo "Passenger keys received"
echo -e $TEXT_RESET
# Adds the repo to the sources list and refreshes them
sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger stretch main > /etc/apt/sources.list.d/passenger.list'
echo -e $TEXT_RED_B'\e[1;31m'
echo "Repo added to apt list"
echo -e $TEXT_RESET
apt -qq update
echo -e $TEXT_RED_B'\e[1;31m'
echo "Apt repositories updated"
echo -e $TEXT_RESET

# Installs the Passenger and Apache modules
echo -e $TEXT_RED_B'\e[1;31m'
echo "Installing Passenger + Apache modules"
echo -e $TEXT_RESET
apt -qq install -y libapache2-mod-passenger
echo -e $TEXT_RED_B'\e[1;31m'
echo "Passenger + Apache moules installed"
echo -e $TEXT_RESET

# Enable passenger mod (just in case)
a2enmod passenger
echo -e $TEXT_RED_B'\e[1;31m'
echo "Passenger mod enabled"
echo -e $TEXT_RESET
apache2ctl restart
echo -e $TEXT_RED_B'\e[1;31m'
echo "Apache2 restarted"
echo -e $TEXT_RESET



echo -e $TEXT_RED_B'\e[1;31m'
echo "Installation complete. moving on to step 2"
echo -e $TEXT_RESET

cd /

# Adds dedicated user for safety reasons
adduser bks-tool --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "bks-tool:Site.Access" | chpasswd
echo -e $TEXT_RED_B'\e[1;31m'
echo "User has been added"
echo -e $TEXT_RESET
usermod -a -G rvm bks-tool
echo -e $TEXT_RED_B'\e[1;31m'
echo "User added to group rvm"
echo -e $TEXT_RESET

# Configures the apache
touch /etc/apache2/sites-enabled/new-tool.conf
touch /etc/apache2/sites-available/new-tool.conf
cd /etc/apache2/sites-enabled/
echo "<VirtualHost *:80>" >> new-tool.conf
echo "    ServerName athene.bks-campus.ch" >> new-tool.conf
echo "    ServerAdmin informatik@bks-campus.ch" >> new-tool.conf
echo "    Redirect Permanent / https://athene.bks-campus.ch" >> new-tool.conf
echo "" >> new-tool.conf
echo "    # Tell Apache and Passenger where your app's 'public' directory is" >> new-tool.conf
echo "    DocumentRoot /var/www/new-tool/public" >> new-tool.conf
echo "" >> new-tool.conf
echo "    PassengerRuby /usr/local/rvm/gems/ruby-2.6.0/wrappers/ruby" >> new-tool.conf
echo "" >> new-tool.conf
echo "    # Relaxes Apache security" >> new-tool.conf
echo "    <Directory /var/www/new-tool/public>" >> new-tool.conf
echo "      Allow from all" >> new-tool.conf
echo "      Options -MultiViews" >> new-tool.conf
echo "    </Directory>" >> new-tool.conf
echo "    ErrorLog ${APACHE_LOG_DIR}/error.log" >> new-tool.conf
echo "    CustomLog ${APACHE_LOG_DIR}/access.log combined" >> new-tool.conf
echo "</VirtualHost>" >> new-tool.conf
touch /etc/apache2/sites-enabled/new-tool-ssl.conf

apache2ctl restart
echo -e $TEXT_RED_B'\e[1;31m'
echo "Apache configured and restarted"
echo -e $TEXT_RESET

apt -qq update
apt -qq upgrade
echo -e $TEXT_RED_B'\e[1;31m'
echo "Sys update finished"
echo -e $TEXT_RESET

# Makes folder to hold webapp
mkdir -p /var/www/new-tool
echo -e $TEXT_RED_B'\e[1;31m'
echo "Folder created"
echo -e $TEXT_RESET
chown -R bks-tool: /var/www/
echo -e $TEXT_RED_B'\e[1;31m'
echo "Permission given to new user"
echo -e $TEXT_RESET
git clone https://github.com/edbingo/new-tool /var/www/new-tool
echo -e $TEXT_RED_B'\e[1;31m'
echo "Install has completed."
echo "Please run ./usersetup.sh as the bks-tool user"
echo -e $TEXT_RESET
