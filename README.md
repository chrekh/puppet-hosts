# hosts

A template-based module to manage /etc/hosts. The main goal for this
module is to add entries for localhost and primary address based on
existing ip-adresses on existing interfaces. Tested by me on Gentoo,
SLES, RedHat, and OS X. But it should work or any Linux and Unix-like
OS.

This module unconditionally overwrites your hosts file. You have been
warned! There are two reasons that this is template-based.

1) Currently the default host type don't allow multiple IP for a
   hostname (not even a IPv4 and a IPv6).

2) I prefer to manage files with puppet exclusively, or not at all.

## Usage

```puppet
class { 'hosts': }
```

## Parameters

file
----
The file to add host entries to.
- *Default*: '/etc/hosts'

lo_ipv4
-------
List of IPv4 addresses for localhost. Empty list means no entry.
- *Default*: [ IPv4 loopback addresses ]

lo_ipv6
-------
List of IPv6 addresses for localhost. Empty list means no entry.
- *Default*: [ IPv6 loopback addresses ]

lo_names
--------
List of names for localhost.
- *Default*: [ 'localhost' ]

primary_ipv4
------------
List of IPv4 addresses. Empty list means no entry.
- *Default*: [ IPv4 addresses (not loopback or multicast) ]

primary_ipv6
------------
List of IPv6 addresses. Empty list means no entry.
- *Default*: [ IPv6 addresses (not loopback, multicast, or linklocal) ]

primary_names
-------------
List of names for primary addresses.
- *Default*: [ $::fqdn, $::hostname ]

one_primary_ipv4
-----------------
If true, only use the first address from primary_ipv4
- *Default*: true

one_primary_ipv6
-----------------
If true, only use the first address from primary_ipv6
- *Default*: true

enable_ipv4
-----------

If false, don't add IPv4 loopback or primary addresses. (IPv4
addresses from hosts::entries is still added)
- *Default*: true

enable_ipv6
-----------
If false, don't add IPv6 loopback or primary addresses. (IPv6
addresses from hosts::entries is still added)
- *Default*: true

entries
-------
A hash with additional host entries to add. Entries in this hash
overrides automatic hostentries for IP's on local interfaces.
The content can be either comment => { ip => [ names ], ... } or just ip => [ names ].
- *Default*: {}

## Example

```puppet
class { 'hosts':
    one_primary_ipv4 => false, 
    one_primary_ipv6 => false,
    entries => { '192.168.2.1' => [ 'foo.example.org', 'foo' ] }
}
```

## Hiera example

```yaml
hosts::one_primary_ipv4: false
hosts::one_primary_ipv6: false
hosts::entries:
  '::2':
    - 'localhost2'
  'Foocluster nodes':
    '2001:db8:abba::1':
      - 'node1.example.org'
      - 'node1'
    '2001:db8:abba::2':
      - 'node2.example.org'
      - 'node2'
```
