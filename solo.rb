src = '/etc/chef/src'

cookbook_path src + '/cookbooks'
role_path     src + '/roles'
data_bag_path src + '/data_bags'

log_level        :info
log_location     STDOUT

