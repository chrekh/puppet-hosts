# frozen_string_literal: true

require 'spec_helper'

describe 'hosts::collect_lo' do
  context 'with some some networking facts' do
    let(:facts) do
      {
        networking: {
          interfaces: {
            lo: {
              bindings: [
                {
                  address: '127.0.0.1'
                },
                {
                  address: '127.0.0.2'
                },
              ],
              bindings6: [
                {
                  address: '::1'
                },
                {
                  address: '::2'
                },
              ]
            }
          }
        }
      }
    end

    it { is_expected.to run.with_params('bindings').and_return(['127.0.0.1', '127.0.0.2']) }
    it { is_expected.to run.with_params('bindings6').and_return(['::1', '::2']) }
  end
end
