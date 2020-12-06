#
# Cookbook:: r_config
# Recipe:: install
#
# Apache 2.0 license

include_recipe '::prerequisites'

version = node['r_config']['version']
install_root = node['r_config']['install_root']
source = "#{install_root}/source/R-#{node['r_config']['version']}"
download_url = node['r_config']['download_url']
prefix = node['r_config']['prefix']
configure_options = node['r_config']['configure_options']

[install_root, source, prefix].each do |dir|
  directory dir do
    mode '0755'
    action :create
    recursive true
  end
end

remote_file "#{source}/R-#{version}.tar.gz" do
  source download_url
  mode '0755'
  action :create
end

archive_file "#{source}/R-#{version}.tar.gz" do
  destination "#{install_root}/source/"
  overwrite :auto
  action :extract
end

execute 'Install_R' do
  cwd source
  command <<-INSTALL
  ./configure #{configure_options}
  make -j4
  make install
  make install-tests
  make install-libR
  INSTALL
  creates "#{prefix}/bin/R"
end
