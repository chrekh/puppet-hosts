# == Class: hosts
#
# Manage /etc/hosts
#
class hosts (
  Stdlib::Absolutepath $file                             = '/etc/hosts',
  Boolean $one_primary_ipv4                              = true,
  Boolean $one_primary_ipv6                              = true,
  Boolean $enable_ipv4                                   = true,
  Boolean $enable_ipv6                                   = true,
  Array[String] $include_ipv4                            = [],
  Array[String] $include_ipv6                            = [],
  Array[String] $exclude_ipv4                            = [],
  Array[String] $exclude_ipv6                            = [],
  Array[Stdlib::IP::Address::V4::Nosubnet] $lo_ipv4      = hosts::collect_lo('ip'),
  Array[Stdlib::IP::Address::V6::Nosubnet] $lo_ipv6      = hosts::collect_lo('ip6'),
  Array[Stdlib::IP::Address::V4::Nosubnet] $primary_ipv4 = hosts::collect_other('ip'),
  Array[Stdlib::IP::Address::V6::Nosubnet] $primary_ipv6 = hosts::collect_other('ip6'),
  Array[String] $lo_names                                = [ 'localhost' ],
  Array[String] $primary_names                           = [ $::fqdn, $::hostname ],
  Hash $entries                                          = {},
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
  $entries_addrs = $entries.keys.map |$entry| {
    if $entry =~ Hash {
      $entries[$entry].keys
    }
    else {
      $entry
    }
  }
  # Filtering
  $filtered_lo_ipv4 = hosts::excludefilter($exclude_ipv4,
    hosts::includefilter($include_ipv4,$lo_ipv4));
  $filtered_primary_ipv4 = hosts::excludefilter($exclude_ipv4,
    hosts::includefilter($include_ipv4,$primary_ipv4));
  $filtered_lo_ipv6 = hosts::excludefilter($exclude_ipv6,
    hosts::includefilter($include_ipv6,$lo_ipv6));
  $filtered_primary_ipv6 = hosts::excludefilter($exclude_ipv6,
    hosts::includefilter($include_ipv6,$primary_ipv6));

  if $one_primary_ipv4 {
    $loopback_ipv4 = [ $filtered_lo_ipv4[0] ].filter |$elt| { $elt } - $entries_addrs
    $pri_ipv4 = [ $filtered_primary_ipv4[0] ].filter |$elt| { $elt } - $entries_addrs
  }
  else {
    $loopback_ipv4 = $filtered_lo_ipv4.sort - $entries_addrs
    $pri_ipv4 = $filtered_primary_ipv4.sort - $entries_addrs
  }
  if $one_primary_ipv6 {
    $loopback_ipv6 = [ $filtered_lo_ipv6[0] ].filter |$elt| { $elt } - $entries_addrs
    $pri_ipv6 = [ $filtered_primary_ipv6[0] ].filter |$elt| { $elt } - $entries_addrs
  }
  else {
    $loopback_ipv6 = $filtered_lo_ipv6.sort - $entries_addrs
    $pri_ipv6 = $filtered_primary_ipv6.sort - $entries_addrs
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
