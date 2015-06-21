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
  file { $file:
    ensure  => present,
    content => template('hosts/hosts.erb'),
  }
}
