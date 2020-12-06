# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/

property :package_name, String, name_property: true
property :configure_args, String, default: ''
property :configure_vars, String, default: ''
property :makeflags, String, default: ''
property :install_opts, String, default: ''
property :ld_run_path, String, default: ''
property :dependencies, String, default: 'TRUE'
property :source, String, default: "'#{[
  node['r_config']['cran_repo_url'],
  node['r_config']['cran_local_repo_url'],
].join("', '")}'"

default_action :install

action :install do
  if installed?(new_resource.package_name)
    Chef::Log.info("#{@new_resource} Already Installed - Nothing To Do.")
  else
    converge_by("Installing R Package #{@new_resource}: ") do
      install(new_resource.package_name)
    end
  end
end

action :delete do
  if installed?(new_resource.package_name)
    converge_by("Deleting R Package #{@new_resource}: ") do
      delete(new_resource.package_name)
    end
  end
end

action :upgrade do
  converge_by("Upgrading R Package #{@new_resource}: ") do
    install(new_resource.package_name)
  end
end

def which_R
  if ::File.exist?(::File.join(node['r_config']['prefix'], 'bin', 'R'))
    ::File.join(node['r_config']['prefix'], 'bin', 'R')
  else
    'R'
  end
end

# Get R path to Rscript
def which_Rscript
  if ::File.exist?(::File.join(node['r_config']['prefix'], 'bin', 'Rscript'))
    ::File.join(node['r_config']['prefix'], 'bin', 'Rscript')
  else
    'Rscript'::File.join(node['r_config']['prefix'], 'bin', 'Rscript')
  end
end

def which_RLib
  if ::Dir.exist?(::File.join(node['r_config']['prefix'], 'lib64'))
    ::File.join(node['r_config']['prefix'], 'lib64')
  elsif ::Dir.exist?(::File.join(node['r_config']['prefix'], 'lib'))
    ::File.join(node['r_config']['prefix'], 'lib')
  else
    '/usr/lib64'
  end
end

# Check if R Package is Installed
def installed?(package)
  if ::File.exist?(::File.join(node['r_config']['prefix'], 'lib64', 'R', 'library', "#{package}", 'R', "#{package}"))
    true
  elsif ::File.exist?(::File.join(node['r_config']['prefix'], 'lib64', "#{package}", 'R', "#{package}"))
    true
  elsif ::File.exist?(::File.join(node['r_config']['prefix'], 'lib', 'R', 'library', "#{package}", 'R', "#{package}"))
    true
  elsif ::File.exist?(::File.join(node['r_config']['prefix'], 'lib', "#{package}", 'R', "#{package}"))
    true
  else
    false
  end
end

# Install The R Package
def install(_package)
  rscript = which_Rscript
  repos = if source[0] != '\''
            "\'#{source}\'"
          else
            source
          end
  rhomebin = ::File.join(node['r_config']['prefix'], 'bin')
  paths = rhomebin + ':/sbin:/bin:/usr/sbin:/usr/bin'
  # Disable Java GUI
  command = 'NOAWT=1 '
  command += "MAKEFLAGS=#{makeflags} " unless makeflags.empty?
  command += "#{rscript} -e "\
            "\"options(download.file.method = 'libcurl'); "\
            "tryCatch(suppressWarnings(install.packages('#{package_name}', "
  command += "configure.args=#{configure_args}, " unless configure_args.empty?
  command += "configure.vars=#{configure_vars}, " unless configure_vars.empty?
  command += "INSTALL_opts='#{install_opts}', " unless install_opts.empty?
  command += "repos=c(#{repos}), Ncpus = getOption('Ncpus', 4L), lib='" + which_RLib +
             "' , dependencies=#{dependencies})), " \
             'warning=function(w){print(w); quit(status=1)}, ' \
             'error=function(e){print(e); quit(status=1)})"'

  Chef::Log.info("Installing R Package #{package_name}")
  # Throw an Error if the Installation Fails !!!
  shell_out!(command, timeout: 3600, env: { 'PATH' => paths })
  nil
end

# Delete the R Package
def delete(_package)
  r = which_R
  command = "#{r} CMD REMOVE #{package_name}"
  Chef::Log.info("Removing R Package #{package_name}")
  # Throw an Error if the Removal Fails !!!
  shell_out!(command)
end
