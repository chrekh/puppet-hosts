# See https://puppet.com/docs/puppet/latest/lang_write_functions_in_puppet.html
# for more information on native puppet functions.
function hosts::collect_lo(String $what) >> Array {
  if $facts[networking][interfaces]
  and $facts[networking][interfaces][lo]
  and $facts[networking][interfaces][lo][$what] {
    $facts[networking][interfaces][lo][$what].map |$binding| {
      $binding[address]
    }
  }
  else {
    []
  }
}
