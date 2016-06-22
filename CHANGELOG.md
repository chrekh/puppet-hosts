##2.2.7

Bugfixes to fact handling.

##2.2.6

Add boolean parameters enable_ipv4 & enable_ipv6

##2.2.5

Use exceptions in custom fact.

##2.2.4

Put standart ipaddress facts first in lists.

The purpose is to get the expected ip-address if using
one_primary_ipv4 or one_primary_ipv6

##2.2.3

Change order of IP loaders in facter to be compatible with AIX

##2.2.2

Fixed so that hosts::entries in new format overrides IP's on local
interfaces

##2.2.1

Entries in hosts::entries can now be grouped, resulting in a comment
before each group in /etc/hosts. Example,

```yaml
hosts::entries:
  'Foocluster nodes':
    '2001:db8:abba::1':
      - 'node1.example.org'
      - 'node1'
    '2001:db8:abba::2':
      - 'node2.example.org'
      - 'node2'
```

This change is backward compatible. The old data-structure still works
as before.

##2.2.0

Entries in hosts::entries now overrides IP's on local interfaces

##2.1.1

Changed domain used as example.

##2.1.0

Fallback to std fact values for IP-adresses if custom facts fails.

##2.0.5

Support for AIX, by Maxime Anciaux.

##2.0.4

Added support for Darwin (OS X)

##2.0.3

Added compatibility for ruby18, with much help from Frank Wall

##2.0.2

Added support for FreeBSD, by Frank Wall

##2.0.1

Workaround for older facter not handling arrays

##2.0.0

Rewriten the code to find the local IP-addresses, to use a custom fact
which uses ruby class socket. This is to get better control than
core-facts can supply. And to be able to use all addresses configured
on an interface instead of just one.

The default is still to use just one address, but that is easy
configured with parameters one_primary_ipv4 and one_primary_ipv6
