PostgreSQL 설치 Ubuntu 18.04

설치 
sudo apt-get install postgresql
sudo systemctl restart postgresql

user create
# post 사용자로 전환
sudo -i -u postgres

createuser gomguard --interactive

sudo -u postgres createdb <dbname>
createdb gomdb -O gomguard --encoding='utf-8' --locale=en_US.utf8 --template=template0

giving the user a password
sudo -u postgres psql
alter user <username> with encrypted password '<password>'

grant
grant all privileges on database <dbname> to <username> ;


IN SQL
show data_directory;


ERROR 발생시
	Is the server running locally and accepting
	connections on Unix domain socket "/var/run/postgresql/.s.PGSQL.5432"?


Edit: postgresql.conf

sudo nano /etc/postgresql/9.3/main/postgresql.conf
Enable or add:

listen_addresses = '*'
Restart the database engine:

sudo service postgresql restart
Also, you can check the file pg_hba.conf

sudo nano /etc/postgresql/9.3/main/pg_hba.conf
And add your network or host address:

## 문제 해결

/media/id/mount 를 전체 가능으로 바꿔줄 것

## 외부접속
https://dejavuqa.tistory.com/32

sudo ufw
http://blog.plura.io/?p=4580
