FROM debian:buster

COPY ./srcs/config.sql /root/.

COPY ./srcs/localhost.conf /root/.

COPY ./srcs/start.sh .

COPY ./srcs/config.inc.php /root/.

ENV AUTOINDEX on

RUN apt-get update && apt-get install -y wget

RUN apt-get install -y nginx

RUN apt-get -y install mariadb-server

RUN apt-get -y install php-mysql

RUN apt-get -y install php7.3-fpm

RUN wget -c http://wordpress.org/latest.tar.gz

RUN tar -xzvf latest.tar.gz

RUN cp -R wordpress/ /var/www/html/localhost

RUN chown -R www-data:www-data /var/www/html/localhost

RUN chmod -R 775 /var/www/html/localhost

RUN service mysql start && mysql -u root < /root/config.sql

RUN mv /root/localhost.conf /etc/nginx/conf.d/.

RUN rm /etc/nginx/sites-enabled/default

RUN rm /etc/nginx/sites-available/default

RUN mkdir /var/www/html/localhost/phpmyadmin

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz && tar -xvzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/html/localhost/phpmyadmin && cp /root/config.inc.php /var/www/html/localhost/phpmyadmin/

RUN apt install -y libnss3-tools

RUN wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64 && mv mkcert-v1.1.2-linux-amd64 mkcert && chmod +x mkcert && ./mkcert -install && ./mkcert localhost

RUN mkdir /root/mkcert && mv localhost.pem /root/mkcert/. && mv localhost-key.pem /root/mkcert/.

CMD bash start.sh && sh