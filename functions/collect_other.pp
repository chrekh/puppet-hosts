# See https://puppet.com/docs/puppet/latest/lang_write_functions_in_puppet.html
# for more information on native puppet functions.
function hosts::collect_other(Enum['ip','ip6'] $type,
                              Array[String] $include,
                              Array[String] $exclude) >> Array {
  $what = $type ? {
    'ip' => 'bindings',
    'ip6' => 'bindings6',
  }
  if $facts[networking] {
    $addrs = if $facts[networking][$type] !~ /^fe80::/ {
      [ $facts[networking][$type] ]
    }
    else {
      []
    }
    + if $facts[networking][interfaces] {
      $facts[networking][interfaces].keys.map |$if| {
        if $if != 'lo'
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
    $addrs.flatten.filter |$addr| { $addr }.unique
  }
  else {
    []
  }
}
