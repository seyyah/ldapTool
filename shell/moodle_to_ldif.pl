#!/usr/bin/perl -w

use MIME::Base64 qw(encode_base64);
use DBI;

# ----- Configure these values below to match your moodle setup -------#
$moodle_db = 'moodle';
$moodle_user = 'moodle';
$moodle_password = 'secret';

# ----- Configure these values below to match your LDAP setup ------#
#$ou = 'ou=moodleusers,dc=mydomain,dc=eu';
$ou = 'dc=debuntu,dc=local';
$objectClass = 'inetOrgPerson';

# ----------------------------------------------------------------------------- #

$dbh = DBI->connect('DBI:mysql:'.$moodle_db, $moodle_user, $moodle_password);

$sth = $dbh->prepare('select username, firstname, lastname, email, password from mdl_user where deleted = 0');
$sth->execute();
while (@row = $sth->fetchrow_array()) {
        print "dn: cn=$row[0],$ou\n";
        print "objectClass: $objectClass\n";
        print "uid: $row[0]\n";
        print "givenName: $row[1]\n";
        print "sn: $row[2]\n";
        print "mail: $row[3]\n";
        if ($row[4] ne '') {
                $password = '{MD5}'. encode_base64(pack ("H32", $row[4]));
                print "userPassword: $password\n";
        }
        print "\n";
}
$sth->finish();
$dbh->disconnect();
 
