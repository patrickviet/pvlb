# LIST OF SERVER NAME TO IP ADDRESS MAPPINGS + WEIGHT (RELATIVE POWER)
node.default['pvlb']['lb_servers'] = {
  'web1' => {
    'ipaddr' => '172.31.38.248',
    'weight' => 10,
  },
  'web2' => {
    'ipaddr' => '172.31.38.250',
    'weight' => 10,
  },
}

# LIST OF SERVER GROUPS
node.default['pvlb']['lb_groups'] = {
  'testpvlb' => [
    'web1',
    'web2'
  ],
}

# MAPPING: WHICH VHOST GOES TO WHICH GROUP
node.default['pvlb']['lb_vhosts'] = {
  'testpvlb' => [
    'testpvlb.dnspow.com',
    'www.testpvlb.dnspow.com',
  ],
}

node.default['pvlb']['statspwd'] = 'supersecure'
node.default['pvlb']['haproxy_extra_raw_config'] = ''

## ----------------------------------------------------------------------------
#### GENERATE PORT TO NAME MAPPING

# We assume that the ports from 12000 onwards are open
node.default['pvlb']['starting_port'] = 12000
current_port = node['pvlb']['starting_port']

node.default['pvlb']['lb_name_to_port'] = {}

node['pvlb']['lb_vhosts'].each do |name,vhosts|
  # first port is for stats (since we do +1 immediately)
  current_port += 1
  node.default['pvlb']['lb_name_to_port'][name] = current_port
end

# Compute md5 hash for each server (for serverid)
# Why? Because it's a bit safer, it hides a bit of your infrastructure
require 'digest/md5'
node['pvlb']['lb_servers'].keys.each do |servername|
  node.default['pvlb']['lb_servers'][servername]['hexdigest'] =
    Digest::MD5.hexdigest(servername)
end

# Now we will have:
# NGINX->Vhost name->Local port->HAPROXY->servers
# Through an NGINX config that maps names to port
# and an HAPROXY config that maps port to servers

