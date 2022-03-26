# Collect addresses from all interfaces except loopback from fact networking.
# @api private
# @param type
#  IP protocol version to collect addresses for.
# @param lo_if
#  The name of the loopback interface.
# @param include
#  List of regexp for interfaces to include addresses from.
# @param exclude
#  List of regexp for interfaces to exclude addresses from.
# @return
#  List of addresses on the loopback interface
function hosts::collect_other(Enum['ip','ip6'] $type,
                              String $lo_if,
                              Array[String] $include,
                              Array[String] $exclude) >> Array {
  $what = $type ? {
    'ip' => 'bindings',
    'ip6' => 'bindings6',
  }
  if $facts[networking] and $facts[networking][$type] {
    $addrs = if $facts[networking][$type] !~ /^fe80::/ {
      [ $facts[networking][$type] ]
    }
    else {
      []
    }
    + if $facts[networking][interfaces] {
      $facts[networking][interfaces].keys.map |$if| {
        if $if != $lo_if
        and ( $include.empty
              or $include.any |$re| { $if =~ $re } )
        and ( $exclude.empty
              or $exclude.all |$re| { $if !~ $re } )
        and $facts[networking][interfaces][$if]
        and $facts[networking][interfaces][$if][$what] {
          $facts[networking][interfaces][$if][$what].map |$binding| {
            unless $binding[scope6] and 'link' in $binding[scope6].split(',') {
              $binding[address]
            }
          }
        }
      }
    }
    $addrs.flatten.filter |$addr| { $addr != undef and $addr != '' }.unique
  }
  else {
    []
  }
}
