#!/bin/sh

if [ ! -z $SECRET_KEY ]; then
  sed -i "s|SECRET_KEY = 'changeme'|SECRET_KEY = '${SECRET_KEY}'|g" /powerdns-admin/config.py
fi

DB_HOST = '${SQLA_DB_HOST}'
DB_USER = '${SQLA_DB_USER}'
DB_NAME = '${SQLA_DB_NAME}'
DB_PASSWORD = '${SQLA_DB_PASSWORD}'

sed -i "s|LDAP_ENABLED = False|LDAP_ENABLED = True|g" /powerdns-admin/config.py

if [ ! -z $LDAP_TYPE ]; then
  sed -i "s|LDAP_TYPE = 'ldap'|LDAP_TYPE = '${LDAP_TYPE}'|g" /powerdns-admin/config.py
fi

if [ ! -z $LDAP_URI ]; then
  sed -i "s|LDAP_URI = 'ldaps://your-ldap-server:636'|LDAP_URI = '${LDAP_URI}'|g" /powerdns-admin/config.py
fi

if [ ! -z $LDAP_USERNAME ]; then
  sed -i "s|LDAP_USERNAME = 'cn=dnsuser,ou=users,ou=services,dc=duykhanh,dc=me'|LDAP_USERNAME = '${LDAP_USERNAME}'|g" /powerdns-admin/config.py
fi

if [ ! -z $LDAP_PASSWORD ]; then
  sed -i "s|LDAP_PASSWORD = 'dnsuser'|LDAP_PASSWORD = '${LDAP_PASSWORD}'|g" /powerdns-admin/config.py
fi

if [ ! -z $LDAP_SEARCH_BASE ]; then
  sed -i "s|LDAP_SEARCH_BASE = 'ou=System Admins,ou=People,dc=duykhanh,dc=me'|LDAP_SEARCH_BASE = '${LDAP_SEARCH_BASE}'|g" /powerdns-admin/config.py
fi

if [ ! -z $LDAP_USERNAMEFIELD ]; then
  sed -i "s|LDAP_USERNAMEFIELD = 'uid'|LDAP_USERNAMEFIELD = '${LDAP_USERNAMEFIELD}'|g" /powerdns-admin/config.py
fi

if [ ! -z $LDAP_FILTER ]; then
  sed -i "s|LDAP_FILTER = '(objectClass=inetorgperson)'|LDAP_FILTER = '${LDAP_FILTER}'|g" /powerdns-admin/config.py
fi

PDNS_HOST = '${PDNS_STATS_URL}'
PDNS_API_KEY = '${PDNS_API_KEY}'

cd /powerdns-admin

if [ ! -d "/powerdns-admin/migrations" ]; then
    flask db init --directory /powerdns-admin/migrations
    flask db migrate -m "Init DB" --directory /powerdns-admin/migrations
    flask db upgrade --directory /powerdns-admin/migrations
    ./init_data.py

else
    /usr/local/bin/flask db migrate -m "Upgrade BD Schema" --directory /powerdns-admin/migrations
    /usr/local/bin/flask db upgrade --directory /powerdns-admin/migrations
fi

yarn install --pure-lockfile
flask assets build

/usr/bin/supervisord -c /etc/supervisord.conf


