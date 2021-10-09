# == Class: hosts
#
# Manage /etc/hosts
#
class hosts (
  Stdlib::Absolutepath $file   = '/etc/hosts',
  Array[String] $lo_ipv4       = split($ipv4_lo_addrs,' '),
  Array[String] $lo_ipv6       = split($ipv6_lo_addrs,' '),
  Array[String] $lo_names      = [ 'localhost' ],
  Boolean $one_primary_ipv4    = true,
  Boolean $one_primary_ipv6    = true,
  Boolean $enable_ipv4         = true,
  Boolean $enable_ipv6         = true,
  Array[String] $primary_ipv4  = split($ipv4_pri_addrs,' '),
  Array[String] $primary_ipv6  = split($ipv6_pri_addrs,' '),
  Array[String] $primary_names = [ $::fqdn, $::hostname ],
  Array[String] $include_ipv4  = [],
  Array[String] $include_ipv6  = [],
  Array[String] $exclude_ipv4  = [],
  Array[String] $exclude_ipv6  = [],
  Hash $entries                = {},
) {
  case $::osfamily {
    /^(FreeBSD|DragonFly|Darwin)$/: {
      $root_group = 'wheel'
    }
    /^(AIX)$/: {
      $root_group = 'system'
    }
    default: {
      $root_group = 'root'
    }
  }
  if $one_primary_ipv4 {
    $loopback_ipv4 = [ $lo_ipv4[0] ].filter |$elt| { $elt }
    $pri_ipv4 = [ $primary_ipv4[0] ].filter |$elt| { $elt }
  }
  else {
    $loopback_ipv4 = $lo_ipv4.sort
    $pri_ipv4 = $primary_ipv4.sort
  }
  if $one_primary_ipv6 {
    $loopback_ipv6 = [ $lo_ipv6[0] ].filter |$elt| { $elt }
    $pri_ipv6 = [ $primary_ipv6[0] ].filter |$elt| { $elt }
  }
  else {
    $loopback_ipv6 = $lo_ipv6.sort
    $pri_ipv6 = $primary_ipv6.sort
  }

  $entries_output = lookup('hosts::entries', Hash, 'hash', $entries)
  assert_type(Hash, $entries_output)

  file { $file:
    ensure  => present,
    owner   => 'root',
    group   => $root_group,
    mode    => '0644',
    content => epp('hosts/hosts.epp'),
  }
}
