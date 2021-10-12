# frozen_string_literal: true

require 'spec_helper'

describe 'hosts::excludefilter' do
  # please note that these tests are examples only
  # you will need to replace the params and return value
  # with your expectations
  it { is_expected.to run.with_params([], ['abc', 'yxa']).and_return(['abc', 'yxa']) }
  it { is_expected.to run.with_params(['x', 'y'], ['abc', 'yxa']).and_return(['abc']) }
  it { is_expected.to run.with_params(nil).and_raise_error(StandardError) }
end
