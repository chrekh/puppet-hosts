# == Class: hosts
#
# Manage /etc/hosts
#
class hosts (
  $file          = '/etc/hosts',
  $lo_ipv4       = [ $::ipaddress_lo ],
  $lo_ipv6       = [ '::1' ], # I wish there was a fact for this.
  $lo_names      = [ 'localhost' ],
  $primary_ipv4  = [ $::ipaddress ],
  $primary_ipv6  = [ $::ipaddress6 ],
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
