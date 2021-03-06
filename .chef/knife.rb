# See https://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "fernandochef1"
client_key               "#{current_dir}/fernandochef1.pem"
validation_client_name   "linux-academy-chef-validator"
validation_key           "#{current_dir}/linux-academy-chef-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/linux-academy-chef"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
