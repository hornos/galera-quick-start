current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "macbook"
client_key               "#{current_dir}/macbook.pem"
validation_client_name   "chef-validator"
validation_key           "#{current_dir}/chef-validator.pem"
chef_server_url          "http://10.10.10.10:4000"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
encrypted_data_bag_secret "#{current_dir}/data_bag.key"
