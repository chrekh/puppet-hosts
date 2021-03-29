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
    $loopback_ipv4 = [ $lo_ipv4[0] ]
    $pri_ipv4 = [ $primary_ipv4[0] ]
  }
  else {
    $loopback_ipv4 = $lo_ipv4
    $pri_ipv4 = $primary_ipv4
  }
  if $one_primary_ipv6 {
    $loopback_ipv6 = [ $lo_ipv6[0] ]
    $pri_ipv6 = [ $primary_ipv6[0] ]
  }
  else {
    $loopback_ipv6 = $lo_ipv6
    $pri_ipv6 = $primary_ipv6
  }

  $entries_output = hiera_hash('hosts::entries', $entries)
  assert_type(Hash, $entries_output)

  file { $file:
    ensure  => present,
    owner   => 'root',
    group   => $root_group,
    mode    => '0644',
    content => template('hosts/hosts.erb'),
  }
}
