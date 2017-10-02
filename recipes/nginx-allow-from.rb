cookbook_file "#{node['nginx']['dir']}/allow_from_pingdom_ips.conf" do
  source 'nginx/allow_from_pingdom_ips.conf'
  owner  'root'
  group  'root'
  mode   '0644'
end

cookbook_file "/usr/local/bin/allow_from_pingdom" do
  source 'nginx/allow_from_pingdom.sh'
  owner  'root'
  group  'root'
  mode   '0750'
end

cron_d 'allow_from_pingdom' do
  minute  0
  hour    8
  command "/usr/local/bin/allow_from_pingdom #{node['nginx']['dir']}/allow_from_pingdom_ips.conf > /dev/null 2>&1"
  user    'root'
end

execute "first run of allow_from_pingdom" do
  command "/usr/local/bin/allow_from_pingdom #{node['nginx']['dir']}/allow_from_pingdom_ips.conf"
end
