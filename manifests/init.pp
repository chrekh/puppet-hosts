# == Class: hosts
#
# Manage /etc/hosts
#
class hosts (
  $file          = '/etc/hosts',
  $lo_ipv4       = $ipv4_lo_addrs,
  $lo_ipv6       = $ipv6_lo_addrs,
  $lo_names      = [ 'localhost' ],
  $primary_ipv4  = $ipv4_pri_addrs,
  $primary_ipv6  = $ipv6_pri_addrs,
  $primary_names = [ $::fqdn, $::hostname ],
  $entries       = {},
) {
  validate_string($file)
  validate_array($lo_ipv4)
  validate_array($lo_ipv6)
  validate_array($lo_names)
  validate_array($primary_ipv4)
  validate_array($primary_ipv6)
  validate_array($primary_names)
  validate_hash($entries)
  file { $file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('hosts/hosts.erb'),
  }
}
