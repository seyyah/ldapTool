#!/bin/sh

echo "Searching..."
ldapsearch -x -b "ou=moodleusers,dc=debuntu,dc=local"

echo "Modifing..."
ldapmodify -c -x -W -D "cn=admin,dc=debuntu,dc=local" -f modify.conf
ldapsearch -x -b "ou=moodleusers,dc=debuntu,dc=local"

echo "Deleting..."
ldapadd -c -x -W -D "cn=admin,dc=debuntu,dc=local" -f mahmut.ldif
ldapdelete -x -W -D 'cn=admin,dc=debuntu,dc=local' 'cn=mahmut,ou=moodleusers,dc=debuntu,dc=local'
ldapsearch -x -b "ou=moodleusers,dc=debuntu,dc=local"

echo "Adding..."
ldapadd -c -x -W -D "cn=admin,dc=debuntu,dc=local" -f mahmut.ldif
ldapsearch -x -b "ou=moodleusers,dc=debuntu,dc=local"

echo "Comparing..."
ldapcompare -x -W -D 'cn=admin,dc=debuntu,dc=local' 'cn=mahmut,ou=moodleusers,dc=debuntu,dc=local' 'sn:kuru'
ldapcompare -x -W -D 'cn=admin,dc=debuntu,dc=local' 'cn=mahmut,ou=moodleusers,dc=debuntu,dc=local' 'sn:kurum'
