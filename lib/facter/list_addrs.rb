require 'socket'

lo_ipv4 = [Facter.value('ipaddress_lo')].compact
primary_ipv4 = [Facter.value('ipaddress')].compact
lo_ipv6 = [Facter.value('ipaddress6_lo')].compact
primary_ipv6 = [Facter.value('ipaddress6')].compact
if %r{^fe80::}i.match?(primary_ipv6[0])
  primary_ipv6 = []
end

if defined? Socket.ip_address_list
  begin
    addrs = Socket.ip_address_list
  rescue ScriptError
  rescue
  end
end
if !addrs && defined? Socket.getifaddrs
  begin
    addrs = Socket.getifaddrs.map { |i| i.addr }
  rescue ScriptError
  rescue
  end
end
unless addrs
  addrs = []
  begin
    require 'facter/util/ip'
    Facter::Util::IP.get_interfaces.each do |interface|
      ['ipaddress', 'ipaddress6'].each do |label|
        addrs << Facter::Util::IP.get_interface_value(interface, label)
      end
    end
  rescue ScriptError
  rescue
  end
end

addrs.each do |addr|
  if (defined? addr.ipv4_loopback?) && addr.ipv4_loopback?
    lo_ipv4 << addr.ip_address
  elsif (defined? addr.ipv6_loopback?) && addr.ipv6_loopback?
    lo_ipv6 << addr.ip_address
  elsif (defined? addr.ipv4?) && addr.ipv4? && !addr.ipv4_multicast?
    primary_ipv4 << addr.ip_address
  elsif (defined? addr.ipv6?) && addr.ipv6? && !addr.ipv6_linklocal? && !addr.ipv6_multicast?
    primary_ipv6 << addr.ip_address
  end
end

Facter.add('ipv4_lo_addrs') do
  setcode do
    lo_ipv4.uniq.join(' ')
  end
end
Facter.add('ipv4_pri_addrs') do
  setcode do
    primary_ipv4.uniq.join(' ')
  end
end
Facter.add('ipv6_lo_addrs') do
  setcode do
    lo_ipv6.uniq.join(' ')
  end
end
Facter.add('ipv6_pri_addrs') do
  setcode do
    primary_ipv6.uniq.join(' ')
  end
end
