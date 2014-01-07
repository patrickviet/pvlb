
# LIST OF SERVER NAME TO IP ADDRESS MAPPINGS + WEIGHT (RELATIVE POWER)
node.default['pvlb']['lb_servers'] = {
  'bob-web1' => {
    'ipaddr' => '10.10.10.1',
    'weight' => 10,
  },
  'bob-web2' => {
    'ipaddr' => '10.10.10.2',
    'weight' => 20,
  },
  'henri-web1' => {
    'ipaddr' => '10.10.10.3',
    'weight' => 10,
  },
  'henri-web2' => {
    'ipaddr' => '10.10.10.4',
    'weight' => 10,
  },
}

# LIST OF SERVER GROUPS
node.default['pvlb']['lb_groups'] = {
  'bob' => [
    'bob-web1',
    'bob-web2'
  ],
  'henri' => [
    'henri-web1',
    'henri-web2',
  ],  
}

# MAPPING: WHICH VHOST GOES TO WHICH GROUP
node.default['pvlb']['lb_vhosts'] = {
  'www.bob.dnspow.com'        => 'bob',
  'www.bobby.dnspow.com'      => 'bob',
  'www.henri.dnspow.com'      => 'henri',
  'www.superhenri.dnspow.com' => 'henri',
}

node.default['pvlb']['statspwd'] = 'mypwd'

## ----------------------------------------------------------------------------
#### GENERATE PORT TO NAME MAPPING

# We assume that the ports from 12000 onwards are open
node.default['pvlb']['starting_port'] = 12000
current_port = node['pvlb']['starting_port']

node.default['pvlb']['lb_groups_to_port'] = {}

node['pvlb']['lb_vhosts'].each do |vhost,name|
  unless node['pvlb']['lb_groups_to_port'].has_key? name
    # this means that the port 1 is reserved for the stats.
    current_port += 1
    node.default['pvlb']['lb_groups_to_port'][name] = current_port
  end
end

# Compute md5 hash for each server (for serverid)
# Why? Because it's a bit safer, it hides a bit of your infrastructure
require 'digest/md5'
node['pvlb']['lb_servers'].keys.each do |servername|
  node.default['pvlb']['lb_servers'][servername]['hexdigest'] =
    Digest::MD5.hexdigest(servername)
end

# Now create a list of port to vhost correspondances
node.default['pvlb']['lb_ports'] = {}

node.default['pvlb']['lb_vhosts'].each do |vhost_name,lb_group_name|
  port = node['pvlb']['lb_groups_to_port'][lb_group_name]

  if node['pvlb']['lb_ports'].has_key? port
    node.default['pvlb']['lb_ports'][port].push vhost_name
  else
    node.default['pvlb']['lb_ports'][port] = [vhost_name]
  end
end

# Now we will have:
# NGINX->Vhost name->Local port->HAPROXY->servers
# Through an NGINX config that maps names to port
# and an HAPROXY config that maps port to servers

