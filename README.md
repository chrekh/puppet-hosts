# hosts

A minimalistic template-based module to manage /etc/hosts. The main
goal for this module is to add entries for localhost and primary
address based on facts.

This module uncontidionally overwrites your hosts file. You have been
warned! There are two reasons that this is template-based.

1) Currently the default host type don't allow multiple IP for a
   hostname (not even a IPv4 and a IPv6).

2) I prefer to manage a file with puppet alone, or not at all.

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
- *Default*: [ $::ipaddress_lo ]

lo_ipv6
-------
List of IPv6 addresses for localhost. Empty list means no entry.
- *Default*: [ '::1' ]

lo_names
--------
List of names for localhost.
- *Default*: [ 'localhost' ]

primary_ipv4
------------
List of IPv4 addresses. Empty list means no entry.
- *Default*: [ $::ipaddress ]

primary_ipv6
------------
List of IPv6 addresses. Empty list means no entry.
- *Default*: [ $::ipaddress6 ]

primary_names
-------------
List of names for primary addresses.
- *Default*: [ $::fqdn, $::hostname ]

entries
-------
A hash with additional host entries to add.
- *Default*: {}

## Example

```puppet
class { 'hosts':
    entries => { '192.168.2.1' => [ 'foo.bar.org', 'foo' ] }
}
```

## Hiera example

```yaml
hosts::entries:
  '::2':
    - 'localhost2'
  '2001::db8:abba::1':
    - 'foo.bar.org'
    - 'foo'
```
