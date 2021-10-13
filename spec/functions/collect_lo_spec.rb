# frozen_string_literal: true

require 'spec_helper'

describe 'hosts::collect_lo' do
  it {
    is_expected.to run.with_params('ip').and_return(['127.0.0.1', '127.0.0.2'])
  }
  it {
    is_expected.to run.with_params('ip6').and_return(['::1', '::2'])
  }
end
