# powerdns-admin-docker

```
docker run --name pdnsadmin -e BIND_ADDRESS=0.0.0.0 \
  -e SECRET_KEY='secret_key' \
  -e PORT='80' \
  -e SQLA_DB_USER='powerdns_admin_user' \
  -e SQLA_DB_PASSWORD='exceptionallysecure' \
  -e SQLA_DB_HOST='db.domain.com' \
  -e SQLA_DB_NAME='powerdns_admin_dbname' \
  -e LDAP_TYPE='ldap' \
  -e LDAP_URI='ldaps://ldap.domain.com:636' \
  -e LDAP_USERNAME='uid=ldap,ou=Users,dc=domain,dc=com' \
  -e LDAP_PASSWORD='ldappassword' \
  -e LDAP_SEARCH_BASE='ou=Users,dc=domain,dc=com' \
  -e PDNS_STATS_URL='http://ns.domain.com:8081/' \
  -e PDNS_API_KEY='api_key' \
  -d -p 80:9393/tcp artsn00p/powerdns-admin:latest
```
