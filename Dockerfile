FROM tutum/lamp:latest
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get remove -y php5-mysql && \
	apt-get install -y php5-xcache php5-mysqlnd php5-gd php5-json php5-curl php5-sqlite && \
	apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN ln -s ../../mods-available/mcrypt.ini /etc/php5/apache2/conf.d/20-mcrypt.ini && \
	ln -s ../../mods-available/mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini && \
	rm -fr /app && git clone --recursive https://github.com/skycomic-org/skycomic.org.git /app && \
	cp /app/index.default.php /app/index.php && \
	cp /app/application/config/config.default.php /app/application/config/config.php && \
	cp /app/application/config/constants.default.php /app/application/config/constants.php && \
	cp /app/application/config/database.default.php /app/application/config/database.php && \
	sed -i "s/\\['username'\\] = 'comic'/['username'] = 'root'/g" /app/application/config/database.php && \
	mysql -u root -e "CREATE DATABASE comic;" && \
	mysql -u root comic < /app/private/install.sql && \
	chown www-data:www-data /app/application/logs /app/application/cache && \
	/app/private/scripts/init.sh
EXPOSE 80 3306
CMD ["/run.sh"]