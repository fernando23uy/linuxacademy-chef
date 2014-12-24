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
  document_root = "/var/www/html/#{sitename}"
  %w[ /var/www /var/www/html ].each do |path|
  	directory path do
		if node["platform"] == "ubuntu"
                	owner "www-data"
                	group "www-data"
        	elsif node["platform"] == "centos"
                	owner "apache"
               		group "apache"
        	end
        	mode "0755"
  	end
  end 
#Creates the directory if doesnt exist recursively and assign permissions
  directory document_root do
        if node["platform"] == "ubuntu"
                owner "www-data"
                group "www-data"
        elsif node["platform"] == "centos"
                owner "apache"
                group "apache"
        end
	mode "0755"
	recursive true
  end

  if node["platform"] == "ubuntu"
        template_dir = "/etc/apache2/sites-enabled"
  elsif node["platform"] == "centos"       
        template_dir = "/etc/httpd/conf.d"
  end

  directory template_dir do
        mode "0755"
        recursive true
        if node["platform"] == "ubuntu"
                owner "www-data"
                group "www-data"
        elsif node["platform"] == "centos"
                owner "apache"
                group "apache"
        end
  end
  template_location = "#{template_dir}/#{sitename}.conf"
#only for centOS
#  template "/etc/httpd/conf.d/#{sitename}.conf" do
  template "#{template_dir}/#{sitename}.conf" do
	mode "0644"
        if node["platform"] == "ubuntu"
		source "vhost_ubuntu.erb"
                owner "www-data"
                group "www-data"
        elsif node["platform"] == "centos"
		source "vhost_centos.erb"
                owner "apache"
                group "apache"
        end
	force_unlink true
	variables(
		:document_root => document_root,
		:port => data["port"],
		:domain => data["domain"]
	)
	notifies :restart, "service[httpd]"
  end


#Create an index.html file
  template "#{document_root}/index.html" do
  	source "index.html.erb"
	mode "0644"
	if node["platform"] == "ubuntu"
		owner "www-data"
        	group "www-data"
  	elsif node["platform"] == "centos"
		owner "apache"
        	group "apache"
  	end
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
execute "echo restarting apache" do
        notifies :restart, "service[httpd]"
end
