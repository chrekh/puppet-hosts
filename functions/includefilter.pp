# Helper function for inclusion of addresses
# @api private
# @param regexps
#  List of regexps to include matching adresses from.
# @param addrs
#  List of addresses to filter
# @return
#  List of addresses included by regexps.
function hosts::includefilter(Array[String] $regexps, Array[String] $addrs) >> Array[String] {
  if $regexps.empty {
    $addrs
  }
  else {
    $regexps.map |$re| {
      $addrs.filter |$addr| {
        $addr =~ $re
      }
    }.flatten.unique
  }
}
