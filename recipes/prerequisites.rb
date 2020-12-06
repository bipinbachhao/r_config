#
# Cookbook:: r_config
# Recipe:: prerequisites
#
# Apache 2.0 license

case node['platform_family']
when 'debian'

  apt_update 'update' do
    compile_time true
  end

  package %w[build-essential libsasl2-dev openssl libssl-dev libnss3-dev
    xz-utils libsqlite3-dev libbz2-dev libgdbm-dev tcl-dev tk-dev tcl tk
    libncursesw5-dev libreadline-gplv2-dev libc6-dev libffi-dev gfortran gfortran-8
    xorg-dev libbz2-dev liblzma-dev libpcre++-dev pcre2-utils libpcre2-dev libcurl4-gnutls-dev]
when 'amazon', 'fedora', 'rhel'
  package 'epel-release' if platform?('centos')
  package %w[libpcap-devel] unless node['platform_version'] > '8'
  package %w[openssl openssl-devel zlib-devel bzip2 bzip2-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel xz xz-libs xz-devel libffi-devel sqlite-devel expat-devel]
  package %w[blas bzip2-devel cmake3 cyrus-sasl-devel gcc-gfortran geos-devel glibc-devel.i686
    libgcc.i686 gmp-devel gcc-gfortran libX11-devel libXt-devel libcurl-devel]
end

build_essential 'Install Build Essential' do
  compile_time true
  action :install
end

openjdk_pkg_install '11'

package %w[automake cmake git]