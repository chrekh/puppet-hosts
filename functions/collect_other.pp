# See https://puppet.com/docs/puppet/latest/lang_write_functions_in_puppet.html
# for more information on native puppet functions.
function hosts::collect_other(String $what) >> Array {
  if $facts[networking][interfaces] {
    $addrs = $facts[networking][interfaces].keys.map |$if| {
      if $if != 'lo'
      and $facts[networking][interfaces][$if]
      and $facts[networking][interfaces][$if][$what] {
        $facts[networking][interfaces][$if][$what].map |$binding| {
          unless $binding[scope6] and 'link' in $binding[scope6].split(',') {
            $binding[address]
          }
        }
      }
    }
    $addrs.flatten.filter |$addr| { $addr }
  }
  else {
    []
  }
}
