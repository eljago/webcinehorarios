# CINE HORARIOS WEBSERVER

### Links
- http://railscasts.com/episodes/335-deploying-to-a-vps
- http://railscasts.com/episodes/271-resque
- https://www.digitalocean.com/community/articles/how-to-install-and-use-redis
- http://redis.io/topics/quickstart

### Instalar Redis Server
brew install redis

### Dependencia de minimagick: Imagemagick
brew install imagemagick

### Crear worker
rake resque:work QUEUE='*' RAILS_ENV=production &
#### Cuando se muestren workers pero ya se hayan eliminado sus procesos, en rails console:
Resque.workers.first.prune_dead_workers
