# hosts

A template-based module to manage /etc/hosts. The main goal for this module is
to add entries for localhost and primary address based on existing ip-adresses
on existing interfaces. as reported by structured fact networking[].  Tested by
me on Gentoo, SLES, RedHat, and OS X. But it should work or any Linux and
Unix-like OS.

This module unconditionally overwrites your hosts file.

## Usage

```puppet
class { 'hosts': }
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
