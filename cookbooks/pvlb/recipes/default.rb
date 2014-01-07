# INSTALL AND DEFINE SERVICES
package 'nginx'
package 'haproxy'

#log node.pvlb
#return
# NGINX CONFIG
template '/etc/nginx/nginx.conf' do
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[nginx]'
end

# HAPROXY CONFIG

# This is to make it be able to start
file '/etc/default/haproxy' do
  mode '0644'
  owner 'root'
  group 'root'
  content "ENABLED=1\n"
  notifies :restart, 'service[haproxy]'
end

# The actual config - sourced from
template '/etc/haproxy/haproxy.cfg' do
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[haproxy]'
end


service 'nginx' do
  action :start
end

service 'haproxy' do
  action :start
end

