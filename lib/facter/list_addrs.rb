require 'socket'

lo_ipv4 = Array.new
primary_ipv4 = Array.new
lo_ipv6 = Array.new
primary_ipv6 = Array.new

Socket.getifaddrs.each.each { |ifaddr|
  if ifaddr.flags & Socket::IFF_LOOPBACK != 0
    if ifaddr.addr.ipv4_loopback? && ifaddr.addr.ip_address == '127.0.0.1'
      lo_ipv4 << ifaddr.addr.ip_address
    elsif ifaddr.addr.ipv6_loopback?
      lo_ipv6 << ifaddr.addr.ip_address
    end
  elsif ifaddr.addr.ipv4? && !ifaddr.addr.ipv4_multicast?
    primary_ipv4 << ifaddr.addr.ip_address
  elsif ifaddr.addr.ipv6? && !ifaddr.addr.ipv6_linklocal? && !ifaddr.addr.ipv6_multicast?
    primary_ipv6 << ifaddr.addr.ip_address
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
