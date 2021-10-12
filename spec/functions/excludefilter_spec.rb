# frozen_string_literal: true

require 'spec_helper'

describe 'hosts::excludefilter' do
  it { is_expected.to run.with_params([], ['abc', 'yxa']).and_return(['abc', 'yxa']) }
  it { is_expected.to run.with_params(['x', 'y'], ['abc', 'yxa']).and_return(['abc']) }
  it { is_expected.to run.with_params(nil).and_raise_error(StandardError) }
end
