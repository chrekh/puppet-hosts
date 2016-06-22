# == Class: hosts
#
# Manage /etc/hosts
#
class hosts (
  $file             = '/etc/hosts',
  $lo_ipv4          = split($ipv4_lo_addrs,' '),
  $lo_ipv6          = split($ipv6_lo_addrs,' '),
  $lo_names         = [ 'localhost' ],
  $one_primary_ipv4 = true,
  $one_primary_ipv6 = true,
  $enable_ipv4      = true,
  $enable_ipv6      = true,
  $primary_ipv4     = split($ipv4_pri_addrs,' '),
  $primary_ipv6     = split($ipv6_pri_addrs,' '),
  $primary_names    = [ $::fqdn, $::hostname ],
  $entries          = {},
) {
  validate_string($file)
  validate_array($lo_ipv4)
  validate_array($lo_ipv6)
  validate_array($lo_names)
  validate_bool($one_primary_ipv4)
  validate_bool($one_primary_ipv6)
  validate_bool($enable_ipv4)
  validate_bool($enable_ipv6)
  validate_array($primary_ipv4)
  validate_array($primary_ipv6)
  validate_array($primary_names)
  validate_hash($entries)
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
  file { $file:
    ensure  => present,
    owner   => 'root',
    group   => $root_group,
    mode    => '0644',
    content => template('hosts/hosts.erb'),
  }
}
