require 'spec_helper'
describe 'hosts' do
  it { is_expected.to contain_class('hosts') }
  context 'with defaults for all parameters' do
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
      {
        one_primary_ipv4: false,
        one_primary_ipv6: false
      }
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
      {
        enable_ipv4: false
      }
    end

    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^\d{3}[.]}) }
    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^::1\s+}) }
  end
  context 'With enable_ipv6 false' do
    let(:params) do
      {
        enable_ipv6: false
      }
    end

    it { is_expected.to contain_file('/etc/hosts').with_content(%r{^127[.]0[.]0[.]1\s+localhost$}) }
    it { is_expected.to contain_file('/etc/hosts').without_content(%r{^\S*:}) }
  end
end
