default['r_config']['version'] = '4.0.3'
default['r_config']['download_url'] = "https://cran.rstudio.com/src/base/R-4/R-#{node['r_config']['version']}.tar.gz"
default['r_config']['install_root'] = '/opt/R'
default['r_config']['prefix'] = "#{node['r_config']['install_root']}/R-#{node['r_config']['version']}"
default['r_config']['configure_options'] = "--prefix=#{node['r_config']['prefix']} --enable-memory-profiling --enable-R-shlib --with-blas --with-lapack --with-tcltk --with-cairo"
default['r_config']['cran_repo_url'] = 'https://ftp.osuosl.org/pub/cran'
default['r_config']['cran_local_repo_url'] = 'https://ftp.osuosl.org/pub/cran'