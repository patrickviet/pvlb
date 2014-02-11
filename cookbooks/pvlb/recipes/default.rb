# INSTALL AND DEFINE SERVICES
package 'nginx'
package 'haproxy'

# Some default files/directories
directory '/var/pvlb/html' do
  mode '0755'
  owner 'root'
  group 'root'
  recursive true
end

cookbook_file '/var/pvlb/html/index.html' do
  mode '0644'
  owner 'root'
  group 'root'
end

file '/var/pvlb/html/health.txt' do
  mode '0644'
  owner 'root'
  group 'root'
  content "OK\n"
end

# NGINX CONFIG
template '/etc/nginx/nginx.conf' do
  mode '0644'
  owner 'root'
  group 'root'
  notifies :reload 'service[nginx]'
end

# HAPROXY CONFIG

# This is to make it be able to start
file '/etc/default/haproxy' do
  mode '0644'
  owner 'root'
  group 'root'
  content "ENABLED=1\n"
  notifies :reload, 'service[haproxy]'
end

# The actual config - sourced from
template '/etc/haproxy/haproxy.cfg' do
  mode '0644'
  owner 'root'
  group 'root'
  notifies :reload, 'service[haproxy]'
end


service 'nginx' do
  action :start
end

service 'haproxy' do
  action :start
end

