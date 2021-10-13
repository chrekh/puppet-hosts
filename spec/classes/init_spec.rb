require 'spec_helper'
describe 'hosts' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('hosts') }
  end
end
