require 'spec_helper'
describe 'hosts' do
  let(:facts) do
    {
      'ipv4_lo_addrs'  => '127.0.0.1',
      'ipv6_lo_addrs'  => '::1',
      'ipv4_pri_addrs' => '192.168.2.1',
      'ipv6_pri_addrs' => '2001:db8:abba::1',
      'osfamily'       => 'Gentoo',
    }
  end

  let(:testaddrs) do
    {
      lo_ipv4: ['127.0.0.1', '127.0.0.2'],
      lo_ipv6: ['::1', '::2'],
      primary_ipv4: ['192.168.2.1', '192.168.2.2', '192.168.10.1', '192.168.11.1', '192.168.11.2', '192.168.12.1'],
      primary_ipv6: ['2001:db8:abba::1', '2001:db8:abba::2', '2001:db8::42:1', '2001:db8:dd:42::1']
    }
  end

  it { is_expected.to contain_class('hosts') }
  context 'with defaults for all parameters' do
    let(:params) do
      testaddrs
    end

    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^127[.]0[.]0[.]1\s+localhost$}) }
    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^127[.]0[.]0[.]2\s+}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^192[.]168[.]2[.]1\s+}) }
    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^192[.]168[.]11[.]1\s+}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^::1\s+}) }
    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^::2\s+}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^2001:db8:abba::1\s+}) }
    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^2001:db8::42:1\s+}) }
  end
  context 'With one_primary_x false' do
    let(:params) do
      testaddrs.merge({ one_primary_ipv4: false,
                        one_primary_ipv6: false })
    end

    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^127[.]0[.]0[.]1\s+localhost$}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^127[.]0[.]0[.]2\s+}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^192[.]168[.]2[.]1\s+}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^192[.]168[.]11[.]1\s+}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^::1\s+}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^::2\s+}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^2001:db8:abba::1\s+}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^2001:db8::42:1\s+}) }
  end
  context 'With enable_ipv4 false' do
    let(:params) do
      testaddrs.merge({ enable_ipv4: false })
    end

    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^\d{3}[.]}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^::1\s+}) }
  end
  context 'With enable_ipv6 false' do
    let(:params) do
      testaddrs.merge({ enable_ipv6: false })
    end

    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^127[.]0[.]0[.]1\s+localhost$}) }
    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^\S*:}) }
  end
  context 'With include/exclude filters' do
    let(:params) do
      testaddrs.merge({ one_primary_ipv4: false,
        one_primary_ipv6: false,
        include_ipv4: [
          '^127[.]',
          '^192[.]168[.]2[.]',
        ],
        exclude_ipv4: [
          '^192[.]168[.]2[.]2',
        ],
        include_ipv6: [
          '^::',
          '^2001:db8:abba:',
        ],
        exclude_ipv6: [
          '^::2',
          '^2001:db8:abba::2',
        ], })
    end

    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^127[.]0[.]0[.]1\s+localhost$}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^192[.]168[.]2[.]1\s+}) }
    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^192[.]168[.]2[.]2\s+}) }
    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^192[.]168[.]1.[.]1\s+}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^::1\s+}) }
    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^::2\s+}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^2001:db8:abba::1\s+}) }
    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^2001:db8:abba::2\s+}) }
    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^2001:db8::42:1\s+}) }
  end
  context 'With some hosts::entries' do
    let(:params) do
      {
        one_primary_ipv4: false,
        one_primary_ipv6: false,
        entries: {
          '::2' => [
            'localhost2',
          ],
          'Foocluster nodes' => {
            '2001:db8:abba::1' => [
              'node1.example.org',
              'node1',
            ],
            '2001:db8:abba::2' => [
              'node2.example.org',
              'node2',
            ],
          },
        },
      }
    end

    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^# Foocluster nodes$}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^::2\s+localhost2$}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^2001:db8:abba::1\s+node1.example.org node1}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^2001:db8:abba::2\s+node2.example.org node2}) }
  end
end
