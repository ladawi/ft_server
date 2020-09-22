FROM debian:buster

COPY ./srcs/config.sql /root/.

COPY ./srcs/localhost.conf /root/.

COPY ./srcs/start.sh .

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

CMD bash start.sh && sh