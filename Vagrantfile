# -*- mode: ruby -*-
# vi: set ft=ruby :
#

# header
clusterfile = "Clusterfile.yml"
begin
  $cluster = YAML.load_file clusterfile
rescue Exception => e
  STDERR.puts e.message
  STDERR.puts "ERROR: Clusterfile not found: #{clusterfile}"
  exit(-1)
end


# vagrant
Vagrant::Config.run do |config|

  vm_defaults = proc do |cfg|
    $cluster[:defaults][:vm].each do |k,v|
      eval("cfg.vm.#{k} = \"#{v}\"")
    end

    $cluster[:defaults][:modifyvm].each do |k,v|
      cfg.vm.customize ["modifyvm", :id, "--#{k}", "#{v}"]
    end
  end

  # cluster
  $cluster[:nodes].each do |node,opts|
    puts "Load cluster node: #{node}"
    config.vm.define node.to_s do |cfg|
      vm_defaults[cfg]
      # cpu and memory
      if not opts[:cpus].nil? then 
        cfg.vm.customize ["modifyvm", :id, "--cpus", opts[:cpus]]
      end
      if not opts[:memory].nil? then 
        cfg.vm.customize ["modifyvm", :id, "--memory", opts[:memory]]
      end

      cfg.vm.host_name = node.to_s

      # networking
      if not opts[:hostonly].nil? then
        cfg.vm.network :hostonly, opts[:hostonly]
      end

      if not opts[:bridged].nil? then
        cfg.vm.network :bridged, opts[:bridged]
      end

      # forwarding
      if not opts[:forward].nil? then
        opts[:forward].each { |p| cfg.vm.forward_port p[0], p[1]}
      end

      if opts[:chef_client] then
        orgname = $cluster[:knife][:node_name]

        cfg.vm.provision :chef_client do |chef|
          if $cluster[:knife][:server_url].nil? then
            chef.chef_server_url = "https://api.opscode.com/organizations/#{orgname}"
          else
            chef.chef_server_url = $cluster[:knife][:server_url]
          end

          if $cluster[:knife][:client_name].nil? then
            chef.validation_client_name = "#{orgname}-validator"
            chef.validation_key_path = ".chef/#{orgname}-validator.pem"
          else
            chef.validation_client_name = $cluster[:knife][:client_name]
            chef.validation_key_path = ".chef/#{$cluster[:knife][:client_name]}.pem"
          end

          chef.encrypted_data_bag_secret_key_path = ".chef/data_bag.key"
          chef.node_name = node.to_s

          if not $cluster[:knife][:log_level].nil? then
            chef.log_level = $cluster[:knife][:log_level]
          end
          chef.environment = opts[:chef_client]

          if not opts[:roles].nil? then 
            chef.run_list = opts[:roles]
          end
        end # :chef_client
      else
        cfg.vm.provision :chef_solo do |chef|
          chef.cookbooks_path = opts[:cookbooks_path].nil? ? "cookbooks" : opts[:cookbooks_path]

          chef.log_level = :debug

          if not opts[:roles].nil? then 
            chef.run_list = opts[:roles]
          end

          # access from chef node[:]
          chef.json = {
            :cluster => $cluster,
            :host => opts,
            "chef_server" => opts[:chef_server]
          }
        end
      end # :chef_solo

    end # cfg
  end # nodes

end
