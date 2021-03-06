# = Class: profile::icinga
#
# Sets up a icinga instance which checks services
# and hosts for Wikimedia Production cluster
#
# = Parameters
#
class profile::icinga(
    $monitoring_groups = hiera('monitoring::groups'),
    $active_host = hiera('profile::icinga::active_host'),
    $partners = hiera('profile::icinga::partners', []),
    $ensure_service = hiera('profile::icinga::ensure_service', 'running'),
    $virtual_host = hiera('profile::icinga::virtual_host'),
    $icinga_user = hiera('profile::icinga::icinga_user', 'icinga'),
    $icinga_group = hiera('profile::icinga::icinga_group', 'icinga'),
){
    $is_passive = !($::fqdn == $active_host)

    interface::add_ip6_mapped { 'main': }

    if os_version('debian >= stretch') {
        require_package('mariadb-client')
    } else {
        class { 'mysql': }
    }

    # leaving address blank means also using IPv6
    class { 'rsync::server':
        address => '',
    }

    class { 'netops::monitoring': }
    class { 'facilities': }
    class { 'lvs::monitor': }
    class { 'icinga::monitor::checkpaging': }
    class { 'icinga::nsca::daemon': }
    class { 'icinga::monitor::wikidata': }
    class { 'icinga::monitor::ores': }
    class { 'icinga::monitor::toollabs': }
    class { 'icinga::monitor::legal': }
    class { 'icinga::monitor::certs': }
    class { 'icinga::monitor::gsb': }
    class { 'icinga::monitor::commons': }
    class { 'icinga::monitor::elasticsearch': }
    class { 'icinga::monitor::wdqs': }
    class { 'icinga::monitor::performance': }
    class { 'icinga::monitor::services': }
    class { 'icinga::monitor::reading_web': }
    class { 'icinga::monitor::traffic': }

    class { 'icinga::event_handlers::raid':
        icinga_user  => $icinga_user,
        icinga_group => $icinga_group,
    }

    class { '::profile::bird::anycast_monitoring': }
    class { '::profile::prometheus::alerts': }
    class { '::profile::maps::alerts': }
    class { '::profile::cache::kafka::alerts': }

    class { '::icinga::monitor::etcd_mw_config': }
    class { '::snmp::mibs': }

    create_resources(monitoring::group, $monitoring_groups)

    monitoring::service { 'https':
        description   => 'HTTPS',
        check_command => "check_ssl_http_letsencrypt!${virtual_host}",
    }

    $ircbot_present = $is_passive ? {
        false => 'present', #aka active
        true  => 'absent',
    }
    $enable_notifications = $is_passive ? {
        false => 1, #aka active
        true  => 0,
    }
    $enable_event_handlers = $is_passive ? {
        false => 1, #aka active
        true  => 0,
    }

    class { '::icinga':
        enable_notifications  => $enable_notifications,
        enable_event_handlers => $enable_event_handlers,
        ensure_service        => $ensure_service,
        icinga_user           => $icinga_user,
        icinga_group          => $icinga_group,
    }

    class { '::icinga::web':
        virtual_host => $virtual_host,
    }

    class { '::icinga::naggen':    }
    class { '::profile::icinga::ircbot':
        ensure => $ircbot_present,
    }

    if ($is_passive) {
        file { '/usr/local/sbin/sync_icinga_state':
          ensure  => present,
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => template('role/icinga/sync_icinga_state.sh.erb'),
        }
    }
    else {
        $partners.each |String $partner| {
            ferm::service { "icinga-rsync-${partner}":
              proto  => 'tcp',
              port   => 873,
              srange => "(@resolve(${partner}) @resolve(${partner}, AAAA))",
            }
        }
    }

    # allow NSCA (Nagios Service Check Acceptor)
    # connections on port 5667/tcp
    ferm::service { 'icinga-nsca':
        proto  => 'tcp',
        port   => '5667',
        srange => '($PRODUCTION_NETWORKS $FRACK_NETWORKS)',
    }

    rsync::server::module { 'icinga-tmpfs':
        read_only => 'yes',
        path      => '/var/icinga-tmpfs',
    }
    rsync::server::module { 'icinga-cache':
        read_only => 'yes',
        path      => '/var/cache/icinga',
    }
    rsync::server::module { 'icinga-lib':
        read_only => 'yes',
        path      => '/var/lib/icinga',
    }

    # We absent the cron on active hosts, should only exist on passive ones
    $cron_presence = $is_passive ? {
        true  => 'present',
        false => 'absent',
    }
    cron { 'sync-icinga-state':
        ensure  => $cron_presence,
        minute  => '33',
        command => '/usr/local/sbin/run-no-puppet /usr/local/sbin/sync_icinga_state >/dev/null 2>&1',
    }
}
