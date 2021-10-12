# frozen_string_literal: true

require 'spec_helper'

describe 'hosts::includefilter' do
  # please note that these tests are examples only
  # you will need to replace the params and return value
  # with your expectations
  it { is_expected.to run.with_params(['x', 'y'], ['abc', 'yxa']).and_return(['yxa']) }
  it { is_expected.to run.with_params([], ['x', 'y']).and_return(['x', 'y']) }
  it { is_expected.to run.with_params(nil).and_raise_error(StandardError) }
end
