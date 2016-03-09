#
# Cookbook Name:: .
# Recipe:: credentials
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'dsc_testing::default'

dsc_resource 'user' do
  resource :user
  property :UserName, 'TestUser1'
  property :password, ps_credential('TestUser1', 'P@ssw0rd!')
  property :ensure, 'Present'
  property :disabled, false
end
