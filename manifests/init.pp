# == Class: hosts
#
# Manage /etc/hosts
#
class hosts (
  $file             = '/etc/hosts',
  $lo_ipv4          = $ipv4_lo_addrs,
  $lo_ipv6          = $ipv6_lo_addrs,
  $lo_names         = [ 'localhost' ],
  $one_primary_ipv4 = true,
  $one_primary_ipv6 = true,
  $primary_ipv4     = $ipv4_pri_addrs,
  $primary_ipv6     = $ipv6_pri_addrs,
  $primary_names    = [ $::fqdn, $::hostname ],
  $entries          = {},
) {
  validate_string($file)
  validate_array($lo_ipv4)
  validate_array($lo_ipv6)
  validate_array($lo_names)
  validate_bool($one_primary_ipv4)
  validate_bool($one_primary_ipv6)
  validate_array($primary_ipv4)
  validate_array($primary_ipv6)
  validate_array($primary_names)
  validate_hash($entries)
  $pri_ipv4 = $one_primary_ipv4 ? {
    true    => [ $primary_ipv4[0] ],
    default => $primary_ipv4,
  }
  $pri_ipv6 = $one_primary_ipv6 ? {
    true    => [ $primary_ipv6[0] ],
    default => $primary_ipv6,
  }
  file { $file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('hosts/hosts.erb'),
  }
}
