#! /bin/sh
uwsgi --ini ${UWSGI_INI_PATH};
tail -f /dev/null;