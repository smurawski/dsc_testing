#
# Cookbook Name:: dsc_testing
# Recipe:: with_hashes
#
# Copyright (c) 2016 Steven Murawski, All Rights Reserved.

include_recipe 'dsc_testing::default'

dsc_resource 'With hash' do
  resource :CIMTypes
  module_name 'DscTestModule'
  property :name, 'hash'
  property :hashtable, {one: 'two', three: 'four'}
end

dsc_resource 'With attribute' do
  resource :CIMTypes
  module_name 'DscTestModule'
  property :name, 'attribute'
  property :hashtable, node['dsc_testing']['test_hash'].to_hash
end

