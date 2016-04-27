#
# Cookbook Name:: jr-jenkins
# Spec:: default
#
# Copyright (c) 2016 Jackson River, All Rights Reserved.

require 'spec_helper'

describe 'jr-jenkins::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |_node, server|
        # Stub data bag items for testing.
        data_bag_stubs(server)
      end
      runner.converge(described_recipe)
    end

    before do
      stub_command('/usr/sbin/httpd -t').and_return(true)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
