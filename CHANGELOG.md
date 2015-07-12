##2.0.0

Rewriten the code to find the local IP-addresses, to use a custom fact
which uses ruby class socket. This is to get better control than
core-facts can supply. And to be able to use all addresses configured
on an interface instead of just one.

The default is still to use just one address, but that is easy
configured with parameters one_primary_ipv4 and one_primary_ipv6
