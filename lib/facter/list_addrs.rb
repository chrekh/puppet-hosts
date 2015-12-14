require 'socket'

lo_ipv4 = Array.new
primary_ipv4 = Array.new
lo_ipv6 = Array.new
primary_ipv6 = Array.new

if defined? Socket.ip_address_list
  addrs = Socket.ip_address_list
else
  require 'facter/util/ip'
  addrs = Array.new
  Facter::Util::IP.get_interfaces.each do |interface|
    addrs << Facter::Util::IP.get_interface_value(interface,ipaddress)
    addrs << Facter::Util::IP.get_interface_value(interface,ipaddress6)
  end
end

addrs.each { |addr|
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
    result = lo_ipv4.join(' ')
  end
end
Facter.add('ipv4_pri_addrs') do
  setcode do
    result = primary_ipv4.join(' ')
  end
end
Facter.add('ipv6_lo_addrs') do
  setcode do
    result = lo_ipv6.join(' ')
  end
end
Facter.add('ipv6_pri_addrs') do
  setcode do
    result = primary_ipv6.join(' ')
  end
end
