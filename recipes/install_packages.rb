#
# Cookbook:: r_config
# Recipe:: install_packages
#
# Apache 2.0 license

require 'shellwords'

%w[abind acepack arules arm assertthat].each do |rpackage|
  r_config_package rpackage
end

%w[base64enc beanplot BH biclust git2r bitops boot bootstrap brew broom binGroup].each do |rpackage|
  r_config_package rpackage
end

%w[ca caTools class cluster clinfun cmprsk coda codetools].each do |rpackage|
  r_config_package rpackage
end

%w[datasets DBI].each do |rpackage|
  r_config_package rpackage
end

%w[odbc].each do |rpackage|
  r_config_package rpackage
end