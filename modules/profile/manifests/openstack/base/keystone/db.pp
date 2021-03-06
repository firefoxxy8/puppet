class profile::openstack::base::keystone::db(
    $labs_hosts_range = hiera('profile::openstack::base::labs_hosts_range'),
    $puppetmaster_hostname = hiera('profile::openstack::base::puppetmaster_hostname'),
    $designate_host = hiera('profile::openstack::base::designate_host'),
    $second_region_designate_host = hiera('profile::openstack::base::second_region_designate_host'),
    $osm_host = hiera('profile::openstack::base::osm_host'),
    $prometheus_nodes = hiera('prometheus_nodes'),
    ) {

    package {'mysql-server':
        ensure => 'present',
    }

    file {'/etc/mysql/my.cnf':
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("profile/openstack/base/keystone/db/${::lsbdistcodename}.my.cnf.erb"),
        require => Package['mysql-server'],
    }

    # prometheus monitoring
    prometheus::mysqld_exporter { 'default':
        client_password => '',
        client_socket   => '/var/run/mysqld/mysqld.sock',
        arguments       => "-collect.global_status \
-collect.global_variables \
-collect.info_schema.processlist \
-collect.info_schema.processlist.min_time 0 \
-collect.slave_status \
-collect.info_schema.tables false \
"
    }

    $prometheus_ferm_nodes = join($prometheus_nodes, ' ')

    ferm::service { 'prometheus-mysqld-exporter':
        proto  => 'tcp',
        port   => '9104',
        srange => "@resolve((${prometheus_ferm_nodes}))",
    }

    # mysql monitoring and administration from root clients/tendril
    $mysql_root_clients = join($::network::constants::special_hosts['production']['mysql_root_clients'], ' ')
    ferm::service { 'mysql_admin_standard':
        proto  => 'tcp',
        port   => '3306',
        srange => "(${mysql_root_clients})",
    }
    ferm::service { 'mysql_admin_alternative':
        proto  => 'tcp',
        port   => '3307',
        srange => "(${mysql_root_clients})",
    }

    ferm::rule{'mysql_nova':
        ensure => 'present',
        rule   => "saddr ${labs_hosts_range} proto tcp dport (3306) ACCEPT;",
    }

    ferm::rule{'mysql_designate':
        ensure => 'present',
        rule   => "saddr (@resolve((${designate_host} ${second_region_designate_host})) @resolve((${designate_host} ${second_region_designate_host}), AAAA)) proto tcp dport (3306) ACCEPT;",
    }

    ferm::rule{'mysql_puppetmaster':
        ensure => 'present',
        rule   => "saddr (@resolve(${puppetmaster_hostname}) @resolve(${puppetmaster_hostname}, AAAA)) proto tcp dport (3306) ACCEPT;",
    }

    ferm::rule{'mysql_wikitech':
        ensure => 'present',
        rule   => "saddr (@resolve(${osm_host}) @resolve(${osm_host}, AAAA)) proto tcp dport (3306) ACCEPT;",
    }
}
