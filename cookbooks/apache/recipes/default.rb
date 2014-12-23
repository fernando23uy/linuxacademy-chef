#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# In order to install the package resource on CentOS machine
## Resource defines the action that in this case is to install apache package

if node["platform"] == "ubuntu"
	execute "apt-get update -y" do
	end
end

#package name only for centOs
#package "httpd" do
#	action :install
#end

#package depending on case in attributes
package "apache2" do
	package_name node["apache"]["package"]
end

#Ruby loop
node["apache"]["sites"].each do |sitename, data|
  document_root = "/content/sites/#{sitename}"

#Creates the directory if doesnt exist recursively and assign permissions
  directory document_root do
	mode "0755"
	recursive true
  end

if node["platform"] == "ubuntu"
        template_location = "/etc/apache2/sites-enabled/#{sitename}.conf"
elsif node["platform"] == "centos"       
        template_location = "/etc/httpd/conf.d/#{sitename}.conf"
end

#only for centOS
#  template "/etc/httpd/conf.d/#{sitename}.conf" do
  template template_location do
	source "vhost.erb"
	mode "0644"
	variables(
		:document_root => document_root,
		:port => data["port"],
		:domain => data["domain"]
	)
	notifies :restart, "service[httpd]"


  
  end


#Create an index.html file
  template "/content/sites/#{sitename}/index.html" do
  	source "index.html.erb"
	mode "0644"
	variables(
		:site_title => data["site_title"],
		:comingsoon => "Coming soon as variable"
	)
  end

end 

#Executing commands
execute "rm /etc/httpd/conf.d/welcome.conf" do
	only_if do
		File.exist?("/etc/httpd/conf.d/welcome.conf")
	end
	notifies :restart, "service[httpd]"
end
execute "rm /etc/httpd/conf.d/README" do
        only_if do
                File.exist?("/etc/httpd/conf.d/README")
        end
        notifies :restart, "service[httpd]"
end
service "httpd" do
	service_name node["apache"]["package"] 
	action [:enable, :start]
end

#include_recipe "php::default"

