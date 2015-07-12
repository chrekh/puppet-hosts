require 'socket'

lo_ipv4 = Array.new
primary_ipv4 = Array.new
lo_ipv6 = Array.new
primary_ipv6 = Array.new

Socket.getifaddrs.each.map { |ifaddr| ifaddr.addr }.each { |addr|
  if addr.ipv4_loopback?
    lo_ipv4 << addr.ip_address
  elsif addr.ipv6_loopback?
    lo_ipv6 << addr.ip_address
  elsif addr.ipv4? && !addr.ipv4_multicast?
    primary_ipv4 << addr.ip_address
  elsif addr.ipv6? && !addr.ipv6_linklocal? && !addr.ipv6_multicast?
    primary_ipv6 << addr.ip_address
  end
}

Facter.add('ipv4_lo_addrs') do
  setcode do
    result = lo_ipv4
  end
end

Facter.add('ipv4_pri_addrs') do
  setcode do
    result = primary_ipv4
  end
end
Facter.add('ipv6_lo_addrs') do
  setcode do
    result = lo_ipv6
  end
end
Facter.add('ipv6_pri_addrs') do
  setcode do
    result = primary_ipv6
  end
end
