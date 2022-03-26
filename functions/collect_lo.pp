# Collect addresses on the loopback interface from fact networking.
# @api private
# @param type
#  IP protocol version to collect addresses for.
# @param if
#  The name of the loopback interface.
# @return
#  List of addresses on the loopback interface.
function hosts::collect_lo(Enum['ip','ip6'] $type,String $if) >> Array {
  $what = $type ? {
    'ip' => 'bindings',
    'ip6' => 'bindings6',
  }
  if $facts[networking][interfaces]
  and $facts[networking][interfaces][$if] {
    $addrs = [ $facts[networking][interfaces][$if][$type] ]
    + if $facts[networking][interfaces][$if][$what] {
      $facts[networking][interfaces][$if][$what].map |$binding| {
        $binding[address]
      }
    }
    $addrs.flatten.filter |$addr| { $addr != undef and $addr != ''}.unique
  }
  else {
    $addrs = []
  }
}
