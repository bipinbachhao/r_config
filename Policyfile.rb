# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile/

# A name that describes what the system you're building with Chef does.
name 'r_config'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'r_config::default', 'r_config::prerequisites', 'r_config::install'

# Specify a custom source for a single cookbook:
cookbook 'r_config', path: '.'

# # Cookbook Dependencies
cookbook 'java', '~> 8.5.0', :supermarket
