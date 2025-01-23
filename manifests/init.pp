# @summary Manage /etc/hosts
#
# @example With default entries only
#   include hosts
# @example With all primary addresses
#   class { 'hosts':
#     'one_primary_ipv4' => false,
#     'one_primary_ipv6' => false,
#   }
# @param file
#   The file to manage.
# @param one_primary_ipv4
#   If true, only use the first address from primary_ipv4.
# @param one_primary_ipv6
#   If true, only use the first address from primary_ipv6.
# @param enable_ipv4
#   If false, don't add IPv4 loopback or primary addresses. (IPv4 addresses
#   from hosts::entries is still added)
# @param enable_ipv6
#   If false, don't add IPv6 loopback or primary addresses. (IPv6 addresses
#   from hosts::entries is still added)
# @param include_ipv4
#   A list of regexp. If the list is empty all IPv4 addresses are included. If
#   the list is not empty all IPv4 addresses matching any of the regexps are
#   included.
# @param include_ipv6
#   A list of regexp. If the list is empty all IPv6 addresses are included. If
#   the list is not empty all IPv6 addresses matching any of the regexps are
#   included.
# @param exclude_ipv4
#   A list of regexp. Exclude IPv4 addresses that matches any of the regexps.
# @param exclude_ipv6
#   A list of regexp. Exclude IPv6 addresses that matches any of the regexps.
# @param include_ifs
#   A list of regexp. If the list is empty addresses from all interfaces are
#   included. If the list is not empty only addresses from interfaces matching
#   any of the regexps are included.
# @param exclude_ifs
#   A list of regexp. Exclude addresses from interfaces that match any of the
#   regexps.
# @param loopback_if
#   The name of the loopback interface.
# @param lo_ipv4
#   List of IPv4 addresses for localhost. Empty list means no entry.
# @param lo_ipv6
#   List of IPv6 addresses for localhost. Empty list means no entry.
# @param primary_ipv4
#   List of IPv4 addresses. Empty list means no entry.
# @param primary_ipv6
#   List of IPv6 addresses. Empty list means no entry.
# @param lo_names
#   List of names for localhost.
# @param primary_names
#   List of names for primary addresses.
# @param root_group
#   Group that should own the hosts file.
# @param entries
#   A hash with additional host entries to add. Entries in this hash overrides
#   automatic hostentries for IP's on local interfaces.  The content can be
#   either comment => { ip => [ names ], ... } or just ip => [ names ].
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
  Array[String] $include_ifs                             = [],
  Array[String] $exclude_ifs                             = [],
  String $loopback_if                                    = 'lo',
  Array[Stdlib::IP::Address::V4::Nosubnet] $lo_ipv4      = hosts::collect_lo('ip',$loopback_if),
  Array[Stdlib::IP::Address::V6::Nosubnet] $lo_ipv6      = hosts::collect_lo('ip6',$loopback_if),
  Array[Stdlib::IP::Address::V4::Nosubnet] $primary_ipv4 = hosts::collect_other('ip',$loopback_if, $include_ifs,$exclude_ifs),
  Array[Stdlib::IP::Address::V6::Nosubnet] $primary_ipv6 = hosts::collect_other('ip6',$loopback_if, $include_ifs,$exclude_ifs),
  Array[String] $lo_names                                = ['localhost'],
  Array[String] $primary_names                           = [$facts['networking']['fqdn'], $facts['networking']['hostname']],
  Variant[Integer[0],String[1]] $root_group              = 'root',
  Hash $entries                                          = {},
) {
  $entries_addrs = $entries.keys.map |$entry| {
    if $entry =~ Hash {
      $entries[$entry].keys
    }
    else {
      $entry
    }
  }

  # Filtering
  $filtered_lo_ipv4      = hosts::excludefilter($exclude_ipv4, hosts::includefilter($include_ipv4,$lo_ipv4))
  $filtered_primary_ipv4 = hosts::excludefilter($exclude_ipv4, hosts::includefilter($include_ipv4,$primary_ipv4))
  $filtered_lo_ipv6      = hosts::excludefilter($exclude_ipv6, hosts::includefilter($include_ipv6,$lo_ipv6))
  $filtered_primary_ipv6 = hosts::excludefilter($exclude_ipv6, hosts::includefilter($include_ipv6,$primary_ipv6))

  if $one_primary_ipv4 {
    $loopback_ipv4 = [$filtered_lo_ipv4[0]].filter |$elt| { $elt != undef and $elt != '' } - $entries_addrs
    $pri_ipv4 = [$filtered_primary_ipv4[0]].filter |$elt| { $elt != undef and $elt != '' } - $entries_addrs
  }
  else {
    $loopback_ipv4 = $filtered_lo_ipv4.sort - $entries_addrs
    $pri_ipv4 = $filtered_primary_ipv4.sort - $entries_addrs
  }

  if $one_primary_ipv6 {
    $loopback_ipv6 = [$filtered_lo_ipv6[0]].filter |$elt| { $elt != undef and $elt != '' } - $entries_addrs
    $pri_ipv6 = [$filtered_primary_ipv6[0]].filter |$elt| { $elt != undef and $elt != '' } - $entries_addrs
  }
  else {
    $loopback_ipv6 = $filtered_lo_ipv6.sort - $entries_addrs
    $pri_ipv6 = $filtered_primary_ipv6.sort - $entries_addrs
  }

  $entries_output = lookup('hosts::entries', Hash, 'hash', $entries)
  assert_type(Hash, $entries_output)

  file { $file:
    ensure  => file,
    owner   => 'root',
    group   => $root_group,
    mode    => '0644',
    content => epp('hosts/hosts.epp'),
  }
}
