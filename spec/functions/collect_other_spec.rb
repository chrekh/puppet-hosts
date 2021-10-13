# frozen_string_literal: true

require 'spec_helper'

describe 'hosts::collect_other' do
  it {
    is_expected.to run.with_params('ip').and_return([
                                                      '192.168.2.1',
                                                      '192.168.2.2',
                                                      '192.168.10.1',
                                                      '192.168.11.1',
                                                      '192.168.11.2',
                                                      '192.168.12.1',
                                                    ])
  }
  it {
    is_expected.to run.with_params('ip6').and_return(['2001:db8:abba::1',
                                                      '2001:db8:abba::2',
                                                      '2001:db8::42:1',
                                                      '2001:db8:dd:42::1'])
  }
end
