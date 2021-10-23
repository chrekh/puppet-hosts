# Helper function for exclusion of addresses
# @api private
# @param regexps
#  List of regexps to exclude matching adresses from.
# @param addrs
#  List of addresses to filter
# @return
#  List of addresses not excluded by regexps.
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
