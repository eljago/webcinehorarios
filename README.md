# CINE HORARIOS WEBSERVER

### Links
- http://railscasts.com/episodes/335-deploying-to-a-vps
- http://railscasts.com/episodes/271-resque
- https://www.digitalocean.com/community/articles/how-to-install-and-use-redis
- http://redis.io/topics/quickstart

### Instalar Redis Server
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
make test
sudo make install
cd utils
sudo ./install_server.sh
sudo update-rc.d redis_6379 defaults


### Crear tarea
nohup rake resque:work QUEUE='*' RAILS_ENV=production &
rake resque:work QUEUE='*' RAILS_ENV=production &
== Cuando se muestren workers pero ya se hayan eliminado sus procesos, en reails console:
Resque.workers.first.prune_dead_workers

## Dependencia de minimagick
sudo apt-get install imagemagick