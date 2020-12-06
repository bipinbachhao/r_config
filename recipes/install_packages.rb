#
# Cookbook:: r_config
# Recipe:: install_packages
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'shellwords'

%w[abind acepack arules arm assertthat].each do |rpackage|
  r_config_package rpackage
end

r_config_package 'abind'