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
