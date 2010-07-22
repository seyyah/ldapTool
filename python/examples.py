import ldap

class AutoVivification(dict):
    """Implementation of perl's autovivification feature."""
    def __getitem__(self, item):
        try:
            return dict.__getitem__(self, item)
        except KeyError:
            value = self[item] = type(self)()
            return value

def ldap_entry_tolower (entry):
	"""\
	tum keys leri lowercase yap.
	"""
	keys = entry.keys()
	values = entry.values()
	
	for i in range(len(keys)):
		k = keys[i]
		lk = str.lower(k)
		if lk <> k:
			entry[lk] = values[i]
			del entry[k]

def ldap_entry2user (entry):
	"""\
	entry[keys][0] --> user[keys]
	"""
	user = AutoVivification()
	for keys in entry.keys():
		user[keys] = entry[keys][0]

	return user


LDAP_HOST = 'localhost'
ds = ldap.initialize('ldap://' + LDAP_HOST +':389')
data = ds.search_s('ou=moodleusers,dc=debuntu,dc=local', ldap.SCOPE_SUBTREE, '(cn=*)')

for dn, entry in data:
	print "processing %s" % (dn)
	
	ldap_entry_tolower(entry)
	user = ldap_entry2user(entry)
	
	print "cn = %s, sn = %s, telephonenumber = %s, postalcode = %s" % \
		(user["cn"], user["sn"], user["telephonenumber"], user["postalcode"])
