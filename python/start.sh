#! /bin/sh
uwsgi --ini /var/www/data_layer/uwsgi.ini;
tail -f /var/log/uwsgi/uwsgi9090.log;