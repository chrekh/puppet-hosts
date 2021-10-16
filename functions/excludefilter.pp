# See https://puppet.com/docs/puppet/latest/lang_write_functions_in_puppet.html
# for more information on native puppet functions.
function hosts::excludefilter(Array[String] $regexps, Array[String] $addrs) >> Array[String] {
  if $regexps.empty {
    $addrs
  }
  else {
    $excluded = $regexps.map |$re| {
      $addrs.filter |$addr| {
        $addr =~ $re
      }
    }.flatten.unique
    $addrs - $excluded
  }
}
