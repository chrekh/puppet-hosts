# See https://puppet.com/docs/puppet/latest/lang_write_functions_in_puppet.html
# for more information on native puppet functions.
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
    $addrs.flatten.filter |$addr| { $addr }.unique
  }
  else {
    $addrs = []
  }
}
