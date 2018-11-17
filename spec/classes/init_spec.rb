require 'spec_helper'
describe 'hosts' do
  let(:facts) do
    {
      'ipv4_lo_addrs'  => '127.0.0.1',
      'ipv6_lo_addrs'  => '::1',
      'ipv4_pri_addrs' => '192.168.2.1',
      'ipv6_pri_addrs' => '2001:db8:abba::1',
    }
  end

  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('hosts') }
  end
end
