# Collect addresses on the loopback interface from fact networking.
# @api private
# @param type
#  IP protocol version to collect addresses for.
# @return
#  List of addresses on the loopback interface.
function hosts::collect_lo(Enum['ip','ip6'] $type) >> Array {
  $what = $type ? {
    'ip' => 'bindings',
    'ip6' => 'bindings6',
  }
  if $facts[networking][interfaces]
  and $facts[networking][interfaces][lo] {
    $addrs = [ $facts[networking][interfaces][lo][$type] ]
    + if $facts[networking][interfaces][lo][$what] {
      $facts[networking][interfaces][lo][$what].map |$binding| {
        $binding[address]
      }
    }
    $addrs.flatten.filter |$addr| { $addr != undef and $addr != ''}.unique
  }
  else {
    $addrs = []
  }
}
