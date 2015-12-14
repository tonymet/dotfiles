alias dm=docker-machine

docroot="$HOME/insomniac/insomniacevents/docroot"

docker-run-drupal(){
  docker run -v "$docroot":/var/www/html --link insomniac-db -p 80:80 -d insomniac-drupal-6 apache2-foreground
}

docker-run-mysql(){
  docker run --name insomniac-db -i -t -d -p 3306:3306 --volumes-from x-mysql insomniac-mysql-6 mysqld
}