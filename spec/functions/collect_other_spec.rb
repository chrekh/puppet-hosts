# frozen_string_literal: true

require 'spec_helper'

describe 'hosts::collect_other' do
  context 'with some some networking facts' do
    let(:facts) do
      {
        networking: {
          interfaces: {
            eth1: {
              bindings: [
                {
                  address: '192.168.2.1'
                },
                {
                  address: '192.168.2.2'
                },
              ],
              bindings6: [
                {
                  address: '2001:db8:abba::1'
                },
                {
                  address: '2001:db8:abba::2'
                },
              ]
            }
          }
        }
      }
    end

    it { is_expected.to run.with_params('bindings').and_return(['192.168.2.1', '192.168.2.2']) }
    it { is_expected.to run.with_params('bindings6').and_return(['2001:db8:abba::1', '2001:db8:abba::2']) }
  end
end
