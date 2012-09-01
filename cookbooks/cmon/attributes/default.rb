default['install_dir_cmon']   = "/usr/local"
default['install_config_path'] = "/etc"

default['cluster_id']      = 1
default['cluster_name']    = "default_cluster_1"
default['cluster_type']    = "replication"

default['controller']['mysql_user']        = "cmon"
default['controller']['mysql_hostname']    = "from-databag"
default['controller']['mysql_password']    = "cmon"
default['controller']['mysql_port']        = 3306
default['controller']['ndb_connectstring'] = "from-databag"
default['controller']['ssh_key'] = "/root/.ssh/id_rsa"

default['cmon_password']      = "cmon"

default['mode']['agent']      = "agent"
default['mode']['controller'] = "controller"
default['mode']['dual']       = "dual"

default['agent']['mysql_user']     = "cmon"
default['agent']['mysql_hostname'] = "127.0.0.1"
default['agent']['mysql_password'] = "cmon"
default['agent']['mysql_port']     = 3306

case
when node['instance_role'] == "vagrant"
  ipaddress = node['network']['interfaces']['eth1']['routes'][0]['src']
else
  ipaddress = node['ipaddress']
end

default['agent']['hostname']       = ipaddress

case node['platform']
when 'centos', 'redhat', 'fedora', 'suse', 'scientific', 'amazon'

  default['mysql']['install_dir']   = "/"
  default['mysql']['base_dir']      = "/usr"
  default['mysql']['bin_dir']       = default['mysql']['base_dir'] +"/bin"

  default['mysql']['ndb_bin_dir']   = default['mysql']['base_dir'] +"/bin"

  default['agent']['packages'] = %w(psmisc libaio sysstat)
  default['controller']['packages'] = %w(rrdtool mysql mysql-server)

  default['controller']['mysql_packages'] = %w(mysql mysql-server)
  default['controller']['rrdtool_packages'] = %w(rrdtool)

  default['web']['packages'] = %w(httpd php php-mysql php-gd)

  default['mysql']['service_name'] = "mysqld"

  default['misc']['wwwroot'] = "/var/www/html"
  default['misc']['web_user'] = "apache"

  default['apache']['service_name'] = "httpd"
  default['apache']['default-site'] = '/etc/httpd/conf/httpd.conf'

  default['rrd']['image_dir'] = "/var/www/html/cmon/graphs"

else

  default['mysql']['install_dir']   = "/"
  default['mysql']['base_dir']      = "/usr"
  default['mysql']['bin_dir']       = default['mysql']['base_dir'] +"/bin"

  default['mysql']['ndb_bin_dir']   = default['mysql']['base_dir'] +"/bin"

  default['agent']['packages'] = %w(psmisc libaio1 sysstat)
  default['controller']['packages'] = %w(rrdtool mysql-server)

  default['controller']['mysql_packages'] = %w(mysql-server)
  default['controller']['rrdtool_packages'] = %w(rrdtool)

  default['web']['packages'] = %w(apache2 libapache2-mod-php5 php5-mysql php5-gd)

  default['mysql']['service_name'] = "mysql"

  default['misc']['wwwroot'] = "/var/www"
  default['misc']['web_user'] = "www-data"

  default['apache']['service_name'] = "apache2"
  default['apache']['default-site'] = '/etc/apache2/sites-available/default'

  default['rrd']['image_dir'] = "/var/www/cmon/graphs"

end

default['xtra']['sleep'] = 60
default['mysql']['root_password'] = "password"
default['mysql']['mysql_bin'] = default['mysql']['bin_dir'] + "/mysql"

default['mysql']['data_dir']  = "/var/lib/mysql"
default['mysql']['pid_file']  = "mysqld.pid"
default['mysql']['socket']    = "/var/run/mysqld/mysqld.sock"

default['mysql']['repl_user']     = "repl"
default['mysql']['repl_password'] = "repl"

default['sql']['cmon_schema'] = default['install_dir_cmon'] + "/cmon/sql/cmon_db.sql"
default['sql']['cmon_data']   = default['install_dir_cmon'] + "/cmon/sql/cmon_data.sql"
default['sql']['controller_grants'] = default['install_dir_cmon'] + "/cmon/sql/cmon_controller_grants.sql"
default['sql']['controller_agent_grants'] = default['install_dir_cmon'] + "/cmon/sql/cmon_controller_agent_grants.sql"
default['sql']['agent_grants'] = default['install_dir_cmon'] + "/cmon/sql/cmon_agent_grants.sql"

default['rrd']['rrdtool']   = "/usr/bin/rrdtool"
default['rrd']['data_dir']  = "/var/lib/cmon"

default['misc']['os_user']  = "root"
default['misc']['core_dir'] = "/root/s9s"

default['misc']['pid_file'] = "/var/run/cmon.pid"
# /run/lock/ for ubuntu but for other dists?
default['misc']['lock_dir'] = "/run/lock"
default['misc']['log_file'] = "/var/log/cmon.log"
default['misc']['nodaemon'] = 1
default['misc']['db_stats_collection_interval'] = 30
default['misc']['host_stats_collection_interval'] = 30

default['mysql']['script_dir']    = "/usr/bin"

#default['cmon']['misc']['cmon_core_dir'] = ""
default['misc']['ndb_binary'] = ""
default['misc']['BACKUPDIR'] = ""
default['misc']['IDENTITY']  = default['controller']['ssh_key']
