Step 1. Moving the Mysql data directory

mysql -u root -p

select @@datadir;

sudo systemctl stop mysql
sudo systemctl status mysql

sudo rsync -av /var/lib/mysql /mnt/

sudo mv /var/lib/mysql /var/lib/mysql.bak

Step 2. Pointing to the New Data Location

sudo gedit /etc/mysql/mysql.conf.d/mysqld.cnf

'''''
datadir = /mnt/../mysql
'''''


Step 3. Configuring AppArmor Access Control Rules

sudo gedit /etc/apparmor.d/tunables/alias

'''''
alias /var/lib/mysql/ -> /mnt/.../mysql/,
'''''


sudo systemctl restart apparmor


Step 4. Restarting Mysql
sudo gedit /usr/share/mysql/mysql-systemd-start

'''''
if [ ! -d /var/lib/mysql ] && [ ! -L /var/lib/mysql ]; then
 echo "MySQL data dir not found at /var/lib/mysql. Please create one."
 exit 1
fi

if [ ! -d /var/lib/mysql/mysql ] && [ ! -L /var/lib/mysql/mysql ]; then
 echo "MySQL system database not found. Please run mysql_install_db tool."
 exit 1
fi
'''''
sudo mkdir /var/lib/mysql/mysql -p

sudo systemctl start mysql
sudo systemctl status mysql

mysql -u root -p


select @@datadir;


sudo systemctl restart mysql


