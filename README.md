# kipalink

kipalink project source code.

## How to deploy

Notice:

* database password are committed
* secrets should be renew in production code

### Git checkout and install
```
$ git clone git@github.com:huydx/kipalink.git
$ bundle install
$ bin/rake bower:install
```

### Dump database from production and insert to local

```
$ mysqldump -u root -p <password> kipalog > kipalog.sql

# @ local machine
$ mysql -u root -p < kipalog.sql
$ mysql -u root -p 
mysql> flush privileges;
```

### Dump migration

```
$ bin/rake db:schema:dump
$ bin/rake db:migrate
```

### Confirm

```
$ bin/rails s
```
