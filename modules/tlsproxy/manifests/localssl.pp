# == Define: tlsproxy::localssl
#
# This definition creates a SSL proxy to localhost, using an Nginx site.
#
# === Parameters:
# [*server_name*]
#   Server name, used e.g. for SNI. Defaults to $::fqdn
#
# [*server_aliases*]
#   List of server aliases, host names also served.
#
# [*certs*]
#   Optional - specify either this or acme_subjects.
#   Array of certs, normally just one.  If more than one, special patched nginx
#   support is required.  This is intended to support duplicate keys with
#   differing crypto (e.g. ECDSA + RSA).
#
# [*certs_active*]
#   Optional - if "certs" above is used, this defines the subset of the certs to
#   actually configure on the server.  This allows for additional certs to be
#   fully deployed and OCSP stapled (ready for use), which aren't actually used
#   to serve traffic.  Defaults to the entire set from "certs".
#
# [*acme_subjects*]
#   Optional - specify either this or certs.
#   Array of certificate subjects, beginning with the canonical one - the rest
#   will be listed as Subject Alternative Names.
#   There should be no more than 100 entries in this.
#
# [*upstream_ports*]
#   TCP ports array to proxy to. Defaults to ['80']
#
# [*tls_port*]
#   TCP port to listen on as HTTPS.  This listener will proxy all traffic
#   to @upsteam_ports. Default is 443.
#
# [*redir_port*]
#   TCP port to listen on as plain HTTP.  This listener will redirect GET/HEAD
#   to HTTPS with 301 and deny all other methods with 403.  It does not proxy
#   any traffic. Default is undefined.
#
# [*default_server*]
#   Boolean. Adds the 'default_server' option to the listen statement.
#   Exactly one instance should have this set to true.
#
# [*do_ocsp*]
#   Boolean. Sets up OCSP Stapling for this server.  This both enables the
#   correct configuration directives in the site's nginx config file as well
#   as creates the OCSP data file itself and ensures a cron is running to
#   keep it up to date.  Does not work for ACME (letsencrypt) yet!
#
# [*access_log*]
#   Boolean. If true, sets up the access log for the localssl virtualhost.
#   Do NOT enable on the cache nodes. Defaults to false
#
# [*keepalive_timeout*]
#   Timeout (in seconds) for HTTP keepalive connections. The zero value disables
#   keep-alive client connections. Defaults to 60 seconds.
#
# [*read_timeout*]
#   Timeout (in seconds) for reading a response from the proxied server. The
#   timeout is set only between two successive read operations, not for the
#   transmission of the whole response. If the proxied server does not transmit
#   anything within this time, the connection is closed.  It should be set to
#   a value that corresponds to the backend timeout. Defaults to 180 seconds.

define tlsproxy::localssl(
    $certs          = [],
    $certs_active   = [],
    $acme_subjects  = [],
    $server_name    = $::fqdn,
    $server_aliases = [],
    $default_server = false,
    $upstream_ports = ['80'],
    $tls_port       = 443,
    $redir_port     = undef,
    $do_ocsp        = false,
    $skip_private   = false,
    $access_log     = false,
    Integer $keepalive_timeout = 60,
    Integer $read_timeout = 180,
) {
    if (!empty($certs) and !empty($acme_subjects)) or (empty($certs) and empty($acme_subjects)) {
        fail('Specify either certs or acme_subjects, not both and not neither.')
    }

    require tlsproxy::instance

    $websocket_support = hiera('cache::websocket_support', false)
    $nginx_proxy_request_buffering = hiera('tlsproxy::localssl::proxy_request_buffering', 'on')
    # Maximum number of pending TCP Fast Open requests before falling back to
    # regular 3WHS. https://tools.ietf.org/html/rfc7413#section-5.1
    $fastopen_pending_max = hiera('tlsproxy::localssl::fastopen_pending_max', 150)

    # Ensure that exactly one definition exists with default_server = true
    # if multiple defines have default_server set to true, this
    # resource will conflict.
    if $default_server {
        notify { 'tlsproxy localssl default_server':
            message => "tlsproxy::localssl instance ${title} with server name ${server_name} is the default server."
        }
    }

    if !empty($certs) and !empty($certs_active) {
        # Ideally, we'd sanity-check that active is a subset of certs, too
        $certs_nginx = $certs_active
    } else {
        $certs_nginx = $certs
    }

    if !empty($certs) {
        sslcert::certificate { $certs:
            skip_private => $skip_private,
            before       => Service['nginx'],
        }
    } elsif !empty($acme_subjects) {
        letsencrypt::cert::integrated { $server_name:
            subjects   => join($acme_subjects, ','),
            puppet_svc => 'nginx',
            system_svc => 'nginx',
        }
        # TODO: Maybe add monitoring to this in role::cache::ssl::unified
    }

    if $do_ocsp and !empty($certs) {
        include tlsproxy::ocsp

        sslcert::ocsp::conf { $certs:
            proxy  => "webproxy.${::site}.wmnet:8080",
            before => [Service['nginx'], Exec['nginx-reload']],
        }
    }

    # used in localssl.erb to template upstream definition name
    $basename = regsubst($title, '[\W_]', '-', 'G')

    nginx::site { $name:
        require => Notify['tlsproxy localssl default_server'],    # Ensure a default_server has been defined
        content => template('tlsproxy/localssl.erb')
    }
}
