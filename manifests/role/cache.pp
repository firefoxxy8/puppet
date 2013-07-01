# role/cache.pp
# cache::squid and cache::varnish role classes

# Virtual resources for the monitoring server
@monitor_group { "cache_text_pmtpa": description => "text squids pmtpa" }
@monitor_group { "cache_text_eqiad": description => "text squids eqiad" }
@monitor_group { "cache_text_esams": description => "text squids esams" }

@monitor_group { "cache_upload_pmtpa": description => "upload squids pmtpa" }
@monitor_group { "cache_upload_eqiad": description => "upload squids eqiad" }
@monitor_group { "cache_upload_esams": description => "upload squids esams" }

@monitor_group { "cache_bits_pmtpa": description => "pmtpa bits Varnish" }
@monitor_group { "cache_bits_eqiad": description => "eqiad bits Varnish "}
@monitor_group { "cache_bits_esams": description => "esams bits Varnish" }

@monitor_group { "cache_mobile_eqiad": description => "eqiad mobile Varnish" }
@monitor_group { "cache_mobile_esams": description => "esams mobile Varnish" }

@monitor_group { "cache_parsoid_eqiad": description => "Parsoid caches eqiad" }

class role::cache {
	class configuration {
		include lvs::configuration

		$active_nodes = {
			'production' => {
				"text" => {
					"pmtpa-squid" => [
						'sq33.wikimedia.org',   # API
						'sq34.wikimedia.org',   # API
						'sq36.wikimedia.org',   # API
						'sq37.wikimedia.org',
						'sq59.wikimedia.org',
						'sq60.wikimedia.org',
						'sq61.wikimedia.org',
						'sq62.wikimedia.org',
						'sq63.wikimedia.org',
						'sq64.wikimedia.org',
						'sq65.wikimedia.org',
						'sq66.wikimedia.org',
						'sq71.wikimedia.org',
						'sq72.wikimedia.org',
						'sq73.wikimedia.org',
						'sq74.wikimedia.org',
						'sq75.wikimedia.org',
						'sq76.wikimedia.org',
						'sq77.wikimedia.org',
						'sq78.wikimedia.org',
					],
					"eqiad-squid" => [
						'cp1001.eqiad.wmnet',	# API
						'cp1002.eqiad.wmnet',	# API
						'cp1003.eqiad.wmnet',	# API
						'cp1004.eqiad.wmnet',	# API
						'cp1005.eqiad.wmnet',	# API
						'cp1006.eqiad.wmnet',
						'cp1007.eqiad.wmnet',
						'cp1008.eqiad.wmnet',
						'cp1009.eqiad.wmnet',
						'cp1010.eqiad.wmnet',
						'cp1011.eqiad.wmnet',
						'cp1012.eqiad.wmnet',
						'cp1013.eqiad.wmnet',
						'cp1014.eqiad.wmnet',
						'cp1015.eqiad.wmnet',
						'cp1016.eqiad.wmnet',
						'cp1017.eqiad.wmnet',
						'cp1018.eqiad.wmnet',
						'cp1019.eqiad.wmnet',
						'cp1020.eqiad.wmnet',
					],
					"eqiad" => [
						'cp1037.eqiad.wmnet',
						'cp1038.eqiad.wmnet',
						'cp1039.eqiad.wmnet',
						'cp1040.eqiad.wmnet',
					],
					"esams-squid" => [
						"knsq23.knams.wikimedia.org",
						"knsq24.knams.wikimedia.org",
						"knsq25.knams.wikimedia.org",
						"knsq26.knams.wikimedia.org",
						"knsq27.knams.wikimedia.org",
						"knsq28.knams.wikimedia.org",
						"knsq29.knams.wikimedia.org",

						"amssq31.esams.wikimedia.org",
						"amssq32.esams.wikimedia.org",
						"amssq33.esams.wikimedia.org",
						"amssq34.esams.wikimedia.org",
						"amssq35.esams.wikimedia.org",
						"amssq36.esams.wikimedia.org",
						"amssq37.esams.wikimedia.org",
						"amssq38.esams.wikimedia.org",
						"amssq39.esams.wikimedia.org",
						"amssq40.esams.wikimedia.org",
						"amssq41.esams.wikimedia.org",
						"amssq42.esams.wikimedia.org",
						"amssq43.esams.wikimedia.org",
						"amssq44.esams.wikimedia.org",
						"amssq45.esams.wikimedia.org",
						"amssq46.esams.wikimedia.org",
					],
					"esams" => [
						'amssq47.esams.wikimedia.org',
					]
				},
				"api" => {
					"pmtpa-squid" => [
						'sq33.wikimedia.org',   # API
						'sq34.wikimedia.org',   # API
						'sq36.wikimedia.org',   # API
					],
					"eqiad-squid" => [
						'cp1001.eqiad.wmnet',	# API
						'cp1002.eqiad.wmnet',	# API
						'cp1003.eqiad.wmnet',	# API
						'cp1004.eqiad.wmnet',	# API
						'cp1005.eqiad.wmnet',	# API
					],
					"esams" => [],
				},
				"bits" => {
					"pmtpa" => ["sq67.wikimedia.org", "sq68.wikimedia.org", "sq69.wikimedia.org", "sq70.wikimedia.org"],
					"eqiad" => ["arsenic.wikimedia.org", "niobium.wikimedia.org", "strontium.eqiad.wmnet", "palladium.eqiad.wmnet",
					 	'cp1056.eqiad.wmnet', 'cp1057.eqiad.wmnet', 'cp1069.eqiad.wmnet', 'cp1070.eqiad.wmnet'],
					"esams" => ["cp3019.esams.wikimedia.org", "cp3020.esams.wikimedia.org", "cp3021.esams.wikimedia.org", "cp3022.esams.wikimedia.org"],
				},
				"upload" => {
					"pmtpa-squid" => [
						'sq41.wikimedia.org',
						'sq42.wikimedia.org',
						'sq43.wikimedia.org',
						'sq44.wikimedia.org',
						'sq45.wikimedia.org',
						'sq48.wikimedia.org',
						'sq49.wikimedia.org',
						'sq50.wikimedia.org',

						'sq51.wikimedia.org',
						'sq52.wikimedia.org',
						'sq53.wikimedia.org',
						'sq54.wikimedia.org',
						'sq55.wikimedia.org',
						'sq56.wikimedia.org',
						'sq57.wikimedia.org',
						'sq58.wikimedia.org',

						'sq79.wikimedia.org',
						'sq80.wikimedia.org',
						'sq81.wikimedia.org',
						'sq82.wikimedia.org',
						'sq83.wikimedia.org',
						'sq84.wikimedia.org',
						'sq85.wikimedia.org',
						'sq86.wikimedia.org',
					],
					# FIXME: remove after migration
					"eqiad-old" => [
						'cp1021.eqiad.wmnet',
						'cp1022.eqiad.wmnet',
						'cp1023.eqiad.wmnet',
						'cp1024.eqiad.wmnet',
						'cp1025.eqiad.wmnet',
						'cp1026.eqiad.wmnet',
						'cp1027.eqiad.wmnet',
						'cp1028.eqiad.wmnet',
						'cp1029.eqiad.wmnet',
						'cp1030.eqiad.wmnet',
						'cp1031.eqiad.wmnet',
						'cp1032.eqiad.wmnet',
						'cp1033.eqiad.wmnet',
						'cp1034.eqiad.wmnet',
						'cp1035.eqiad.wmnet',
						'cp1036.eqiad.wmnet',
						'dysprosium.eqiad.wmnet',
					],
					'eqiad' => [
						'cp1048.eqiad.wmnet',
						'cp1049.eqiad.wmnet',
						'cp1050.eqiad.wmnet',
						'cp1051.eqiad.wmnet',
						'cp1061.eqiad.wmnet',
						'cp1062.eqiad.wmnet',
						'cp1063.eqiad.wmnet',
						'cp1064.eqiad.wmnet',
					],
					"esams" => [
						'cp3003.esams.wikimedia.org',
						'cp3004.esams.wikimedia.org',
						'cp3005.esams.wikimedia.org',
						'cp3006.esams.wikimedia.org',
						'cp3007.esams.wikimedia.org',
						'cp3008.esams.wikimedia.org',
						'cp3009.esams.wikimedia.org',
						'cp3010.esams.wikimedia.org',
					],
				},
				"mobile" => {
					"pmtpa" => [],
					# FIXME: remove after migration
					"eqiad-old" => ["cp1041.eqiad.wmnet", "cp1042.eqiad.wmnet", "cp1043.wikimedia.org", "cp1044.wikimedia.org"],
					'eqiad' => ['cp1046.eqiad.wmnet', 'cp1047.eqiad.wmnet', 'cp1059.eqiad.wmnet', 'cp1060.eqiad.wmnet'],
					"esams" => ['cp3011.esams.wikimedia.org', 'cp3012.esams.wikimedia.org', 'cp3013.esams.wikimedia.org', 'cp3014.esams.wikimedia.org'],
				},
				"parsoid" => {
					"pmtpa" => [],
					"eqiad" => ['cp1045.eqiad.wmnet', 'cp1058.eqiad.wmnet'],
					"esams" => []
				}
			},
			'labs' => {
				'api'    => { 'pmtpa' => '127.0.0.1', },
				'bits'   => { 'pmtpa' => '127.0.0.1', },
				'mobile' => { 'pmtpa' => '127.0.0.1', },
				'text'   => { 'pmtpa' => '127.0.0.1', },
				'upload' => { 'pmtpa' => '127.0.0.1', },
				'parsoid' => { 'pmtpa' => '127.0.0.1', },
			},
		}

		$decommissioned_nodes = {
			"text" => {
				"pmtpa" => [
					'sq16.wikimedia.org',
					'sq17.wikimedia.org',
					'sq18.wikimedia.org',
					'sq19.wikimedia.org',
					'sq20.wikimedia.org',
					'sq21.wikimedia.org',
					'sq22.wikimedia.org',
					'sq23.wikimedia.org',
					'sq24.wikimedia.org',
					'sq25.wikimedia.org',
					'sq26.wikimedia.org',
					'sq27.wikimedia.org',
					'sq28.wikimedia.org',
					'sq29.wikimedia.org',
					'sq30.wikimedia.org',

					'sq31.wikimedia.org',
					"sq32.wikimedia.org",
					"sq35.wikimedia.org",
					'sq38.wikimedia.org',
					'sq40.wikimedia.org',
				],
				"eqiad" => [],
				"esams" => [
					'knsq1.knams.wikimedia.org',
					'knsq2.knams.wikimedia.org',
					'knsq3.knams.wikimedia.org',
					'knsq4.knams.wikimedia.org',
					'knsq5.knams.wikimedia.org',
					'knsq6.knams.wikimedia.org',
					'knsq7.knams.wikimedia.org',

					"knsq30.knams.wikimedia.org"
				]
			},
			"api" => {
				"pmtpa" => [],
				"eqiad" => [],
				"esams" => [],
			},
			"bits" => {
				"pmtpa" => [],
				"eqiad" => [],
				"esams" => [
					"knsq1.esams.wikimedia.org",
					"knsq2.esams.wikimedia.org",
					"knsq4.esams.wikimedia.org",
					"knsq5.esams.wikimedia.org",
					"knsq6.esams.wikimedia.org",
					"knsq7.esams.wikimedia.org"
				],
			},
			"upload" => {
				"pmtpa" => [
					'sq1.wikimedia.org',
					'sq2.wikimedia.org',
					'sq3.wikimedia.org',
					'sq4.wikimedia.org',
					'sq5.wikimedia.org',
					'sq6.wikimedia.org',
					'sq7.wikimedia.org',
					'sq8.wikimedia.org',
					'sq9.wikimedia.org',
					'sq10.wikimedia.org',
					'sq11.wikimedia.org',
					'sq12.wikimedia.org',
					'sq13.wikimedia.org',
					'sq14.wikimedia.org',
					'sq15.wikimedia.org',
					'sq47.wikimedia.org',
				],
				"eqiad" => [],
				"esams" => [
					'knsq8.knams.wikimedia.org',
					'knsq9.knams.wikimedia.org',
					'knsq10.knams.wikimedia.org',
					'knsq11.knams.wikimedia.org',
					'knsq12.knams.wikimedia.org',
					'knsq13.knams.wikimedia.org',
					'knsq14.knams.wikimedia.org',
					'knsq15.knams.wikimedia.org'
				],
			},
			"mobile" => {
				"pmtpa" => [],
				"eqiad" => [],
				"esams" => []
			},
			"parsoid" => {
				"pmtpa" => [],
				"eqiad" => [],
				"esams" => []
			}
		}

		$backends = {
			'production' => {
				'appservers' => $lvs::configuration::lvs_service_ips['production']['apaches'],
				'api' => $lvs::configuration::lvs_service_ips['production']['api'],
				'rendering' => $lvs::configuration::lvs_service_ips['production']['rendering'],
				'bits' => {
					'pmtpa' => flatten([$lvs::configuration::lvs_service_ips['production']['bits']['pmtpa']['bitslb']]),
					'eqiad' => flatten([$lvs::configuration::lvs_service_ips['production']['bits']['eqiad']['bitslb']]),
				},
				'bits_appservers' => {
					'pmtpa' => [ "srv248.pmtpa.wmnet", "srv249.pmtpa.wmnet", "mw60.pmtpa.wmnet", "mw61.pmtpa.wmnet" ],
					'eqiad' => [ "mw1149.eqiad.wmnet", "mw1150.eqiad.wmnet", "mw1151.eqiad.wmnet", "mw1152.eqiad.wmnet" ],
				},
				'test_appservers' => {
					'pmtpa' => [ "srv193.pmtpa.wmnet" ],
					'eqiad' => [ "srv193.pmtpa.wmnet" ],
				},
				'parsoid' => $lvs::configuration::lvs_service_ips['production']['parsoid']
			},
			'labs' => {
				'appservers' => {
					'pmtpa' => [
						'10.4.0.166',  # deployment-apache32
						'10.4.0.187',  # deployment-apache33
					],
				},
				'api' => {
					'pmtpa' => [
						'10.4.0.166',  # deployment-apache32
						'10.4.0.187',  # deployment-apache33
					],
				},
				'bits' => {
					'pmtpa' => "10.4.0.252",
				},
				'bits_appservers' => {
					'pmtpa' => [
						'10.4.0.166',  # deployment-apache32
						'10.4.0.187',  # deployment-apache33
					],
				},
				'rendering' => {
					'pmtpa' => [
						'10.4.0.166',  # deployment-apache32
						'10.4.0.187',  # deployment-apache33
					],
				},
				'test_appservers' => {
					'pmtpa' => [ '10.4.0.166' ],
				},
				'parsoid' => {
					'pmtpa' => [ '10.4.1.121' ], # deployment-parsoid2
				}
			}
		}
	}

	class squid {
		class common($role) {
			system_role { "role::cache::${role}": description => "${role} Squid cache server"}

			$cluster = "squids_${role}"
			$nagios_group = "cache_${role}_${::site}"

			include lvs::configuration

			include	standard,
				::squid

			class { "lvs::realserver": realserver_ips => $lvs::configuration::lvs_service_ips[$::realm][$role][$::site] }

			# Monitoring
			monitor_service {
				"frontend http":
					description => "Frontend Squid HTTP",
					check_command => $role ? {
						text => 'check_http',
						upload => 'check_http_upload',
					};
				"backend http":
					description => "Backend Squid HTTP",
					check_command => $role ? {
						text => 'check_http_on_port!3128',
						upload => 'check_http_upload_on_port!3128',
					};
			}

			# HTCP packet loss monitoring on the ganglia aggregators
			if $ganglia_aggregator and $::site != "esams" {
				include misc::monitoring::htcp-loss
			}
		}
	}
	
	class varnish::logging {
		if $::realm == 'production' {
			$cliargs = '-m RxRequest:^(?!PURGE$) -D'
			varnish::logging {
				'emery':
					listener_address => '208.80.152.184',
					cli_args => $cliargs;
				'multicast_relay':
					listener_address => '208.80.154.73',
					port => '8419',
					cli_args => $cliargs;
			}
		}
	}

	class varnish::logging::eventlistener {
		if $::realm == 'production' {
			$event_listener = $::site ? {
				/^(pmtpa|eqiad)$/ => '10.64.21.123', # vanadium
				'esams'           => '208.80.154.73', # gadolinium
			}

			varnish::logging { 'kraken' :
				listener_address => '208.80.154.154', # analytics1001
				port             => '8422',
				instance_name    => '',
				cli_args         => '-m RxURL:^/event\.gif\?. -D',
				log_fmt          => "%U\t%q\t%{Host}i\t%t\t%h\t%{X-Forwarded-For}i\t%{Referer}i\t%{Accept-Language}i\t%{Cookie}i\t%{X-WAP-Profile}i\t%{User-agent}i\t%l\t%n",
				monitor          => false,
			}
		}
		else {
			$event_listener = '10.4.0.48' # deployment-eventlogging
		}

		varnish::logging { 'vanadium' :
			listener_address => $event_listener,
			port             => '8422',
			instance_name    => '',
			cli_args         => '-m RxURL:^/event\.gif\?. -D',
			log_fmt          => "%q\t%l\t%n\t%t\t%h",
			monitor          => false,
		}
	}

	# Ancestor class for all Varnish clusters
	class varnish::base {
		include lvs::configuration, role::cache::configuration, network::constants

		# Any changes here will affect all descendent Varnish clusters
		# unless they're overridden!
		$storage_size_main = $::realm ? { 'labs' => 5, default => 100 }
		if $::site in ["pmtpa", "eqiad"] {
			$cluster_tier = 1
			$default_backend = "backend"
		} else {
			$cluster_tier = 2
			$default_backend = $::mw_primary
		}
		$wikimedia_networks = flatten([$network::constants::all_networks, "127.0.0.0/8", "::1/128"])

		$storage_partitions = $::realm ? {
			'production' => ["sda3", "sdb3"],
			'labs' => ["vdb"],
		}

		#class { "varnish::packages": version => "3.0.3plus~rc1-wm5" }
	}

	# Ancestor class for common resources of 1-layer clusters
	class varnish::1layer inherits role::cache::varnish::base {
		# Any changes here will affect all descendent Varnish clusters
		# unless they're overridden!
		$backend_weight = 10

		# Ganglia monitoring
		class { "varnish::monitoring::ganglia": }
	}

	# Ancestor class for common resources of 2-layer clusters
	class varnish::2layer inherits role::cache::varnish::base {
		# Any changes here will affect all descendent Varnish clusters
		# unless they're overridden!
		$backend_weight = 100
		$storage_size_bigobj = 50

		if regsubst($::memorytotal, '^([0-9]+)\.[0-9]* GB$', '\1') > 96 {
			$memory_storage_size = 16
		} elsif regsubst($::memorytotal, '^([0-9]+)\.[0-9]* GB$', '\1') > 32 {
			$memory_storage_size = 8
		} else {
			$memory_storage_size = 1
		}

		# Ganglia monitoring
		class { "varnish::monitoring::ganglia": varnish_instances => [ "", "frontend" ] }
	}

	class varnish::text inherits role::cache::varnish::2layer {
		$cluster = "cache_text"
		$nagios_group = "cache_text_${::site}"

		system_role { "role::cache::text": description => "text Varnish cache server" }

		class { "lvs::realserver": realserver_ips => $lvs::configuration::lvs_service_ips[$::realm]['text'][$::site] }

		$varnish_be_directors = {
			1 => {
				"backend" => $role::cache::configuration::backends[$::realm]['appservers'][$::mw_primary],
				"api" => $role::cache::configuration::backends[$::realm]['api'][$::mw_primary],
				"rendering" => $role::cache::configuration::backends[$::realm]['rendering'][$::mw_primary],
				"test_wikipedia" => $role::cache::configuration::backends[$::realm]['test_appservers'][$::mw_primary],
			},
			2 => {
				"eqiad" => $role::cache::configuration::active_nodes[$::realm]['text']['eqiad'],
			},
		}

		include standard,
			nrpe

		varnish::setup_filesystem{ $storage_partitions:
			before => Varnish::Instance["text-backend"]
		}

		class { "varnish::htcppurger": varnish_instances => [ "127.0.0.1:80", "127.0.0.1:3128" ] }

		varnish::instance { "text-backend":
			name => "",
			vcl => "text-backend",
			extra_vcl => ["text-common"],
			port => 3128,
			admin_port => 6083,
			runtime_parameters => $::site ? {
				'esams' => ["prefer_ipv6=on", "default_ttl=86400"],
				default => [],
			},
			storage => $::realm ? {
				'production' => "-s main1=persistent,/srv/sda3/varnish.main1,${storage_size_main}G -s main2=persistent,/srv/sdb3/varnish.main2,${storage_size_main}G",
				'labs' => "-s main1=persistent,/srv/vdb/varnish.main1,${storage_size_main}G -s main2=persistent,/srv/vdb/varnish.main2,${storage_size_main}G",
			},
			directors => $varnish_be_directors[$cluster_tier],
			director_type => $cluster_tier ? {
				1 => 'random',
				default => 'chash',
			},
			vcl_config => {
				'default_backend' => $default_backend,
				'retry503' => 1,
				'retry5xx' => 0,
				'cache4xx' => "1m",
				'purge_regex' => '^http://(?!upload\.wikimedia\.org)',
				'cluster_tier' => $cluster_tier,
				'layer' => 'backend',
			},
			backend_options => [
				{
					'backend_match' => '^cp[0-9]+\.eqiad\.wmnet$',
					'port' => 3128,
					'probe' => "varnish",
				},
				{
					'backend_match' => '^srv193\.pmtpa\.wmnet$',
					'max_connections' => 20,
				},
				{
					'port' => 80,
					'connect_timeout' => "5s",
					'first_byte_timeout' => "30s",
					'between_bytes_timeout' => "4s",
					'max_connections' => 1000,
					'weight' => $backend_weight,
				}],
			wikimedia_networks => $wikimedia_networks,
			xff_sources => $network::constants::all_networks
		}

		varnish::instance { "text-frontend":
			name => "frontend",
			vcl => "text-frontend",
			extra_vcl => ["text-common"],
			port => 80,
			admin_port => 6082,
			storage => "-s malloc,${memory_storage_size}G",
			directors => { "backend" => $role::cache::configuration::active_nodes[$::realm]['text'][$::site] },
			director_type => "chash",
			vcl_config => {
				'retry503' => 1,
				'retry5xx' => 0,
				'cache4xx' => "1m",
				'purge_regex' => '^http://(?!upload\.wikimedia\.org)',
				'cluster_tier' => $cluster_tier,
				'layer' => 'frontend',
			},
			backend_options => [
				{
					'port' => 3128,
					'connect_timeout' => "5s",
					'first_byte_timeout' => "35s",
					'between_bytes_timeout' => "2s",
					'max_connections' => 100000,
					'probe' => "varnish",
					'weight' => $backend_weight,
				}],
			xff_sources => $network::constants::all_networks,
		}

		include role::cache::varnish::logging

		# HTCP packet loss monitoring on the ganglia aggregators
		if $ganglia_aggregator and $::site != "esams" {
			include misc::monitoring::htcp-loss
		}
	}

	class varnish::upload inherits role::cache::varnish::2layer {
		$cluster = "cache_upload"
		$nagios_group = "cache_upload_${::site}"

		system_role { "role::cache::upload": description => "upload Varnish cache server" }

		class { "lvs::realserver": realserver_ips => $lvs::configuration::lvs_service_ips[$::realm]['upload'][$::site] }

		# FIXME: remove after migration
		$suffix = $::hostname ? {
			/^(dysprosium|cp10[23][0-9])$/ => "-old",
			default => "",
		}
		$varnish_be_directors = {
			1 => {
				"backend" => $lvs::configuration::lvs_service_ips[$::realm]['swift']['pmtpa'],
				"rendering" => $role::cache::configuration::backends[$::realm]['rendering'][$::mw_primary],
			},
			2 => {
				"eqiad" => $role::cache::configuration::active_nodes[$::realm]['upload']['eqiad']
			}
		}

		$default_backend = $cluster_tier ? { 1 => 'backend', default => 'eqiad' }

		# FIXME: remove after migration
		if $::hostname =~ /^cp10[23][0-9]$/ {
			$storage_size_main = 100
			$storage_size_bigobj = 10
		}
		elsif $::hostname =~ /^cp30[0-9][0-9]$/ {
			$storage_size_main = 300
		}
		else {
			$storage_size_main = 250
		}

		if $cluster_tier == 1 {
			$director_retries = 2
		} else {
			$director_retries = $backend_weight * 4
		}

		include standard,
			nrpe

		# FIXME: set to default on new servers
		$storage_partitions = $::realm ? {
			'production' =>
				$::hostname ? {
					'dysprosium' => ['sdc1', 'sdd1'],
					default => ['sda3', 'sdb3'],
				},
			'labs' => ['vdb']
		}
		varnish::setup_filesystem{ $storage_partitions:
			before => Varnish::Instance["upload-backend"]
		}

		class { "varnish::htcppurger": varnish_instances => [ "127.0.0.1:80", "127.0.0.1:3128" ] }

		varnish::instance { "upload-backend":
			name => "",
			vcl => "upload-backend",
			port => 3128,
			admin_port => 6083,
			runtime_parameters => $::site ? {
				'esams' => ["prefer_ipv6=on", "default_ttl=86400"],
				default => [],
			},
			# FIXME: remove after migration
			storage => $::hostname ? {
				'dysprosium' => "-s main1=persistent,/srv/sdc1/varnish.persist,300G -s main2=file,/srv/sdd1/varnish.persist,300G -s bigobj1=file,/srv/sdc1/large-objects.persist,50G -s bigobj2=file,/srv/sdd1/large-objects.persist,50G",
				/^cp(10[23][0-9]|30[01][0-9])$/ => "-s main1=persistent,/srv/sda3/varnish.persist,${storage_size_main}G -s main2=persistent,/srv/sdb3/varnish.persist,${storage_size_main}G -s bigobj1=file,/srv/sda3/large-objects.persist,${storage_size_bigobj}G -s bigobj2=file,/srv/sdb3/large-objects.persist,${storage_size_bigobj}G",
				default => "-s main1=persistent,/srv/sda3/varnish.main1,${storage_size_main}G -s main2=persistent,/srv/sdb3/varnish.main2,${storage_size_main}G -s bigobj1=file,/srv/sda3/varnish.bigobj1,${storage_size_bigobj}G -s bigobj2=file,/srv/sdb3/varnish.bigobj2,${storage_size_bigobj}G",
			},
			directors => $varnish_be_directors[$cluster_tier],
			director_type => $cluster_tier ? {
				1 => 'random',
				default => 'chash',
			},
			director_options => {
				'retries' => $director_retries,
			},
			vcl_config => {
				'default_backend' => $default_backend,
				'retry5xx' => 0,
				'cache4xx' => "1m",
				'purge_regex' => '^http://upload\.wikimedia\.org/',
				'cluster_tier' => $cluster_tier,
				'layer' => 'backend',
			},
			backend_options => [
				# FIXME: remove after migration
				{
					'backend_match' => '^dysprosium\.eqiad\.wmnet$',
					'weight' => 80,
					#'port' => 3128,
					#'probe' => "varnish",
				},
				{
					'backend_match' => '^cp10[23][0-9]\.eqiad\.wmnet$',
					'weight' => 20,
				},
				{
					'backend_match' => '^cp[0-9]+\.eqiad.wmnet$',
					'port' => 3128,
					'probe' => "varnish",
				},
				{
					'port' => 80,
					'connect_timeout' => "5s",
					'first_byte_timeout' => "35s",
					'between_bytes_timeout' => "4s",
					'max_connections' => 1000,
					'weight' => $backend_weight,
				}],
			wikimedia_networks => $wikimedia_networks,
			xff_sources => $network::constants::all_networks
		}

		varnish::instance { "upload-frontend":
			name => "frontend",
			vcl => "upload-frontend",
			port => 80,
			admin_port => 6082,
			storage => "-s malloc,${memory_storage_size}G",
			directors => { "backend" => $role::cache::configuration::active_nodes[$::realm]['upload']["${::site}${suffix}"] },
			director_type => "chash",
			vcl_config => {
				'retry5xx' => 0,
				'cache4xx' => "1m",
				'purge_regex' => '^http://upload\.wikimedia\.org/',
				'cluster_tier' => $cluster_tier,
				'layer' => 'frontend',
			},
			backend_options => [
				{
					'backend_match' => '^dysprosium\.eqiad\.wmnet$',
					'weight' => 80,
				},
				{
					'backend_match' => '^cp10[23][0-9]\.eqiad\.wmnet$',
					'weight' => 20,
				},
				{
					'port' => 3128,
					'connect_timeout' => "5s",
					'first_byte_timeout' => "35s",
					'between_bytes_timeout' => "2s",
					'max_connections' => 100000,
					'probe' => "varnish",
					'weight' => $backend_weight,
				}],
			xff_sources => $network::constants::all_networks,
		}

		include role::cache::varnish::logging

		# HTCP packet loss monitoring on the ganglia aggregators
		if $ganglia_aggregator and $::site != "esams" {
			include misc::monitoring::htcp-loss
		}
	}

	class text {
		if ($::hostname in ['cp1037', 'cp1038', 'cp1039', 'cp1040'] or $::hostname =~ /^amssq(4[7-9]|[56][0-9])$/) or ($::realm == "labs" and $::hostname =~ /^deployment-cache-text/) {
			# Varnish
			include role::cache::varnish::text
		}
		else {
			class { "role::cache::squid::common": role => "text" }
		}
	}

	class upload {
		# FIXME: remove this hack
		if $::site in ["eqiad","esams"] or $::realm == 'labs' {
			# Varnish
			include role::cache::varnish::upload
		}
		else {
			# Squid
			class { "role::cache::squid::common": role => "upload" }
		}
	}

	class bits inherits role::cache::varnish::1layer {
		$cluster = "cache_bits"
		$nagios_group = "cache_bits_${::site}"

		class { "lvs::realserver": realserver_ips => $lvs::configuration::lvs_service_ips[$::realm]['bits'][$::site] }

		$common_cluster_options = {
			'test_hostname' => "test.wikipedia.org",
			'enable_geoiplookup' => true,
		}

		$default_backend = "backend"
		$varnish_directors = {
			1 => {
				"backend" => $::role::cache::configuration::backends[$::realm]['bits_appservers'][$::mw_primary],
				"test_wikipedia" => $::role::cache::configuration::backends[$::realm]['test_appservers'][$::mw_primary],
			},
			2 => {
				"backend" => flatten(values($role::cache::configuration::backends[$::realm]['bits']))
			}
		}

		$probe = $cluster_tier ? { 1 => "bits", default => "varnish" }
		case $::realm {
			'labs': {
				$realm_cluster_options = {
					'top_domain' => 'beta.wmflabs.org',
					'bits_domain' => 'bits.beta.wmflabs.org',
				}
			}
			default: {
				$realm_cluster_options = {}
			}
		}
		$cluster_options = merge($common_cluster_options, $realm_cluster_options)

		if regsubst($::memorytotal, '^([0-9]+)\.[0-9]* GB$', '\1') > 96 {
			$memory_storage_size = 32
		} else {
			$memory_storage_size = 2
		}

		system_role { "role::cache::bits": description => "bits Varnish cache server" }

		require geoip

		include standard,
			nrpe

		varnish::instance { "bits":
			name => "",
			vcl => "bits",
			port => 80,
			admin_port => 6082,
			storage => "-s malloc,${memory_storage_size}G",
			directors => $varnish_directors[$cluster_tier],
			director_type => "random",
			vcl_config => {
				'default_backend' => $default_backend,
				'retry503' => 4,
				'retry5xx' => 1,
				'cache4xx' => "1m",
				'layer' => 'frontend',
			},
			backend_options => {
				'port' => 80,
				'connect_timeout' => "5s",
				'first_byte_timeout' => "35s",
				'between_bytes_timeout' => "4s",
				'max_connections' => 10000,
				'probe' => $probe,
			},
			cluster_options => $cluster_options,
			xff_sources => $network::constants::all_networks
		}

		include role::cache::varnish::logging::eventlistener
	}

	class mobile inherits role::cache::varnish::2layer {
		$cluster = "cache_mobile"
		$nagios_group = "cache_mobile_${::site}"

		class { "lvs::realserver": realserver_ips => $lvs::configuration::lvs_service_ips[$::realm]['mobile'][$::site] }

		system_role { "role::cache::mobile": description => "mobile Varnish cache server" }

		include standard,
			nrpe

		$varnish_be_directors = {
			1 => {
				"backend" => $role::cache::configuration::backends[$::realm]['appservers'][$::mw_primary],
				"api" => $role::cache::configuration::backends[$::realm]['api'][$::mw_primary],
				"test_wikipedia" => $role::cache::configuration::backends[$::realm]['test_appservers'][$::mw_primary],
			},
			2 => {
				"eqiad" => $role::cache::configuration::active_nodes[$::realm]['mobile']['eqiad']
			}
		}

		$storage_size_main = $::hostname ? {
			/^cp104[1-4]$/ => 100,
			default => 300,
		}
		
		if $cluster_tier == 1 {
			$director_retries = 2
		} else {
			$director_retries = $backend_weight * 4
		}

		varnish::setup_filesystem{ $storage_partitions:
			before => Varnish::Instance["mobile-backend"]
		}

		# TODO: remove after migration
		if $::hostname =~ /^cp104[1-4]$/ {
			class { "varnish::htcppurger": varnish_instances => [ "127.0.0.1:80", "127.0.0.1:81" ] }
		} else {
			class { "varnish::htcppurger": varnish_instances => [ "127.0.0.1:80", "127.0.0.1:3128" ] }
		}
		# FIXME: remove after migration
		$suffix = $::hostname ? {
			/^cp104[1-4]$/ => "-old",
			default => "",
		}

		varnish::instance { "mobile-backend":
			name => "",
			vcl => "mobile-backend",
			# TODO: remove after migration
			port => $::hostname ? {
				/^cp104[1-4]$/ => 81,
				default => 3128,
			},
			admin_port => 6083,
			storage => $::realm ? {
				'production' => "-s main1=persistent,/srv/sda3/varnish.main1,${storage_size_main}G -s main2=persistent,/srv/sdb3/varnish.main2,${storage_size_main}G",
				'labs' => "-s main1=persistent,/srv/vdb/varnish.main1,${storage_size_main}G -s main2=persistent,/srv/vdb/varnish.main2,${storage_size_main}G",
			},
			runtime_parameters => $::site ? {
				'esams' => ["prefer_ipv6=on"],
				default => [],
			},
			directors => $varnish_be_directors[$cluster_tier],
			director_type => $cluster_tier ? {
				1 => 'random',
				default => 'chash',
			},
			director_options => {
				'retries' => $director_retries,
			},
			vcl_config => {
				'default_backend' => $default_backend,
				'retry503' => 4,
				'retry5xx' => 1,
				'purge_regex' => '^http://(?!upload\.wikimedia\.org)',
				'cluster_tier' => $cluster_tier,
				'layer' => 'backend',
			},
			backend_options => [
				{
					'backend_match' => '^srv193\.pmtpa\.wmnet$',
					'max_connections' => 20,
				},
				{
					'backend_match' => '^cp[0-9]+\.eqiad\.wmnet$',
					'weight' => $backend_weight,
					'port' => 3128,
					'probe' => "varnish",
				},
				{
					'port' => 80,
					'connect_timeout' => "5s",
					'first_byte_timeout' => "35s",
					'between_bytes_timeout' => "4s",
					'max_connections' => 600,
				}],
			wikimedia_networks => $wikimedia_networks,
			xff_sources => $network::constants::all_networks
		}

		varnish::instance { "mobile-frontend":
			name => "frontend",
			vcl => "mobile-frontend",
			extra_vcl => ["zero"],
			port => 80,
			admin_port => 6082,
			storage => "-s malloc,${memory_storage_size}G",
			directors => {
				"backend" => $::role::cache::configuration::active_nodes[$::realm]['mobile']["${::site}${suffix}"],
			},
			director_options => {
				'retries' => $backend_weight * size($::role::cache::configuration::active_nodes[$::realm]['mobile'][$::site]),
			},
			director_type => "chash",
			vcl_config => {
				'retry5xx' => 0,
				'purge_regex' => '^http://(?!upload\.wikimedia\.org)',
				'cluster_tier' => $cluster_tier,
				'layer' => 'frontend',
			},
			backend_options => [
			# TODO: remove after migration
			{
				'backend_match' => '^cp104[1-4]\.',
				'port' => 81,
				'weight' => 10,
			},
			{
				'port' => 3128,
				'weight' => $backend_weight,
				'connect_timeout' => "5s",
				'first_byte_timeout' => "35s",
				'between_bytes_timeout' => "2s",
				'max_connections' => 100000,
				'probe' => "varnish",
			}],
			xff_sources => $network::constants::all_networks,
		}

		include role::cache::varnish::logging
	}

	class parsoid inherits role::cache::varnish::2layer {
		$cluster = "cache_parsoid"
		$nagios_group = "cache_parsoid_${::site}"

		if ( $::realm == 'production' ) {
			class { "lvs::realserver": realserver_ips => $lvs::configuration::lvs_service_ips[$::realm]['parsoidcache'][$::site] }
		}

		system_role { "role::cache::parsoid": description => "Parsoid Varnish cache server" }

		include standard,
			nrpe

		$storage_size_main = $::realm ? { 'labs' => 5, default => 300 }
		$storage_partitions = $::realm ? {
			'production' => $::hostname ? {
				# FIXME: Use consistent partitions on the new servers
				"titanium" => ["sdb1", "sdd1"],
				"cerium" => ["sda1", "sdb1"],
				default => ['sda3', 'sdb3'],
			},
			'labs' => ["vdb"],
		}
		varnish::setup_filesystem{ $storage_partitions:
			before => Varnish::Instance["parsoid-backend"]
		}

		# No HTCP daemon for Parsoid; the MediaWiki extension sends PURGE requests itself
		#class { "varnish::htcppurger": varnish_instances => [ "localhost:80", "localhost:3128" ] }

		varnish::instance { "parsoid-backend":
			name => "",
			vcl => "parsoid-backend",
			extra_vcl => ["parsoid-common"],
			port => 3128,
			admin_port => 6083,
			storage => $::realm ? {
				# FIXME: Use consistent partitions on the new servers
				'production' => $::hostname ? {
					"titanium" => "-s main1=persistent,/srv/sdb1/varnish.persist,139G -s main2=persistent,/srv/sdd1/varnish.persist,139G",
					"cerium" => "-s main1=persistent,/srv/sda1/varnish.persist,139G -s main2=persistent,/srv/sdb1/varnish.persist,139G",
					default => "-s main1=persistent,/srv/sda3/varnish.persist,${storage_size_main}G -s main2=persistent,/srv/sdb3/varnish.persist,${storage_size_main}G",
				},
				'labs' => "-s main1=persistent,/srv/vdb/varnish.main1,${storage_size_main}G -s main2=persistent,/srv/vdb/varnish.main2,${storage_size_main}G",
			},
			directors => {
				"backend" => $role::cache::configuration::backends[$::realm]['parsoid'][$::mw_primary],
			},
			director_options => {
				'retries' => 2,
			},
			vcl_config => {
				'retry5xx' => 1,
			},
			backend_options => [
				{
					'port' => 8000,
					'connect_timeout' => "5s",
					'first_byte_timeout' => "60s",
					'between_bytes_timeout' => "4s",
					'max_connections' => 600,
				}],
			xff_sources => $network::constants::all_networks
		}

		varnish::instance { "parsoid-frontend":
			name => "frontend",
			vcl => "parsoid-frontend",
			extra_vcl => ["parsoid-common"],
			port => 80,
			admin_port => 6082,
			directors => {
				"backend" => $::role::cache::configuration::active_nodes[$::realm]['parsoid'][$::site],
			},
			director_type => "chash",
			director_options => {
				'retries' => $backend_weight * size($::role::cache::configuration::active_nodes[$::realm]['parsoid'][$::site]),
			},
			vcl_config => {
				'retry5xx' => 0,
			},
			backend_options => {
				'port' => 3128,
				'weight' => $backend_weight,
				'connect_timeout' => "5s",
				'first_byte_timeout' => "60s",
				'between_bytes_timeout' => "2s",
				'max_connections' => 100000,
				'probe' => "varnish",
			},
			xff_sources => $network::constants::all_networks,
		}
	}
}
