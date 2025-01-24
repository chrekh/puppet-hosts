## 4.1.1
### Jan 24, 2025

* Raise stdlib boundary

## 4.1.0
### Apr 29, 2023

* Replace remaining references to legacy facts, needed for puppet-8

## 4.0.4
### Apr 17, 2022

* Make $root_group a parameter with defaults in hiera
* Add defaults for Solaris

## 4.0.3
### Mar 26, 2022

* Use 'lo0' as default loopback interface on FreeBSD.

## 4.0.2
### Oct 26, 2021

* Fix bug if IPv6 is disabled.

## 4.0.1
### Oct 25, 2021

* puppet-5.5 compatibility

## 4.0.0
### Oct 23, 2021

### Major rewrite

* Replaced ruby-code to collect addresses from interfaces with puppet code to collect addresses from structured fact networking.
* Replaced complex erb template with much simpler epp template.
* Added parameters exclude_ifs and include_ifs

## 3.2.0
### Apr 04, 2021

* Added ability to filter the lists of addresses with lists of regexps.

## 3.1.0
### May 10, 2020

* Sort IP-adresses to make hosts content stable across runs.

## 3.0.0
### Jul 29, 2019

* Replace deprecated validate-functions with puppet-4 data types.

## 2.4.0
### Dec 31, 2018

* Converted to pdk.

## 2.3.1
### Apr 03, 2017

* Bugfix: Reject nil IP

## 2.3.0
### Feb 23, 2017

* Ability to merge entries by hiera

## 2.2.7
### Jun 22, 2016

* Bugfixes to fact handling.

## 2.2.6
### Jun 15, 2016

* Add boolean parameters enable_ipv4 & enable_ipv6

## 2.2.5
### Apr 22, 2016

* Use exceptions in custom fact.

## 2.2.4
### Apr 18, 2016

* Put standard ipaddress facts first in lists, to get the expected ip-address if using one_primary_ipv4 or one_primary_ipv6

## 2.2.3
### Apr 12, 2016

* Change order of IP loaders in facter to be compatible with AIX

## 2.2.2
### Apr 05, 2016

* Fixed so that hosts::entries in new format overrides IP's on local interfaces

## 2.2.1
### Apr 04, 2016

* Entries in hosts::entries can now be grouped, resulting in a comment before each group in /etc/hosts. Example,

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

This change is backward compatible. The old data-structure still works as before.

## 2.2.0
### Mar 20, 2016

* Entries in hosts::entries now overrides IP's on local interfaces

## 2.1.1
### Mar 19, 2016

* Changed domain used as example.

## 2.1.0
### Feb 19, 2016

* Fallback to std fact values for IP-adresses if custom facts fails.

## 2.0.5
### Feb 11, 2016

* Support for AIX, by Maxime Anciaux.

## 2.0.4
### Jan 05, 2016

* Added support for Darwin (OS X)

## 2.0.3
### Dec 29, 2015

* Added compatibility for ruby18, with much help from Frank Wall

## 2.0.2
### Dec 09, 2015

* Added support for FreeBSD, by Frank Wall

## 2.0.1
### Nov 17, 2015

* Workaround for older facter not handling arrays

## 2.0.0
### Jul 15, 2015

* Rewritten the code to find the local IP-addresses, to use a custom fact which uses ruby class socket.

This is to get better control than core-facts can supply. And to be able to use
all addresses configured on an interface instead of just one.  The default is
still to use just one address, but that is easy configured with parameters
one_primary_ipv4 and one_primary_ipv6
