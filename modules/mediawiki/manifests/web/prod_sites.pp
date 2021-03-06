class mediawiki::web::prod_sites {
    tag 'mediawiki', 'mw-apache-config'

    apache::site { 'redirects':
        content  => compile_redirects('puppet:///modules/mediawiki/apache/sites/redirects/redirects.dat'),
        priority => 2,
    }

    # Search vhost
    apache::site { 'search.wikimedia':
        source   => 'puppet:///modules/mediawiki/apache/sites/search.wikimedia.conf',
        priority => 5,
    }

    # Old secure redirects
    apache::site { 'secure.wikimedia':
        source   => 'puppet:///modules/mediawiki/apache/sites/secure.wikimedia.conf',
        priority => 6,
    }

    ### BEGIN main
    apache::site { 'main':
        source   => 'puppet:///modules/mediawiki/apache/sites/main.conf',
        priority => 3,
    }


    # Included in main.conf
    $main_conf_sites = [
        'mediawiki.org',
        'test.wikidata.org',
        'wikidata.org',
        'wiktionary.org',
        'wikiquote.org',
        'donate.wikimedia.org',
        'vote.wikimedia.org',
        'wikipedia.org',
        'wikibooks.org',
        'wikisource.org',
        'wikinews.org',
        'wikiversity.org',
    ]
    mediawiki::web::site { $main_conf_sites:
        before => Apache::Site['main']
    }

    mediawiki::web::vhost{
        'wikivoyage.org':
            ensure          => present,
            server_name     => 'wikivoyage',
            server_aliases  => ['*.wikivoyage.org'],
            docroot         => '/srv/mediawiki/docroot/wikivoyage.org',
            public_rewrites => true,
            variant_aliases => [
                'zh', 'zh-hans', 'zh-hant',
                'zh-cn', 'zh-hk', 'zh-mo',
                'zh-my', 'zh-sg', 'zh-tw'
            ],
            legacy_rewrites => false,
            declare_site    => false,
            before          => Apache::Site['main']

    }
    ### END main

    ### BEGIN remnant
    # Other wikis
    apache::site { 'remnant':
        source   => 'puppet:///modules/mediawiki/apache/sites/remnant.conf',
        priority => 4,
    }

    $remnant_simple_wikis = [
        'outreach.wikimedia.org',
        'advisory.wikimedia.org',
        'quality.wikimedia.org',
        'strategy.wikimedia.org',
        'incubator.wikimedia.org',
    ]

    mediawiki::web::vhost {
        default:
            ensure          => present,
            short_urls      => false,
            docroot         => '/srv/mediawiki/docroot/wikimedia.org',
            legacy_rewrites => true,
            declare_site    => false,
            public_rewrites => true,
            before          => Apache::Site['remnant'],
            ;
        $remnant_simple_wikis:
            short_urls => true,
            ;
        'usability.wikimedia.org':
            short_urls      => false,
            ;
        'species.wikimedia.org':
            additional_rewrites => {
                'early' => [],
                'late'  => [
                    '# Uploads are offsite',
                    '    RewriteRule ^/upload/(.*)$ %{ENV:RW_PROTO}://upload.wikimedia.org/wikipedia/species/$1 [R=302]'
                ]
            }
            ;
        'commons.wikimedia.org':
            legacy_rewrites     => true,
            additional_rewrites => {
                'early' => [],
                'late'  => [
                    '# Uploads are offsite',
                    '    RewriteRule ^/upload/(.*)$ %{ENV:RW_PROTO}://upload.wikimedia.org/wikipedia/commons/$1 [R=302]',
                    '    # /data/ path T163922',
                    '    RewriteRule ^/data/(.*)/(.*)$ %{ENV:RW_PROTO}://commons.wikimedia.org/wiki/Special:PageData/$1/$2 [R=301,QSA]'
                ],
            }
            ;
        'meta.wikimedia.org':
            short_urls          => true,
            legacy_rewrites     => true,
            additional_rewrites => {
                'early' => [],
                'late'  => [
                    '    # Uploads are offsite',
                    '    RewriteRule ^/upload/(.*)$ %{ENV:RW_PROTO}://upload.wikimedia.org/wikipedia/meta/$1 [R=302]',
                    '    # Used for Firefox OS web application manifest living on meta.wikimedia.org',
                    '    AddType application/x-web-app-manifest+json .webapp'
                ],
            }
            ;
        '_wikisource.org':
            docroot             => '/srv/mediawiki/docroot/wikisource.org',
            server_name         => 'wikisource.org',
            additional_rewrites => {
                'early' => [],
                'late'  => [
                    '    # Uploads are offsite',
                    '    RewriteRule ^/upload/(.*)$ %{ENV:RW_PROTO}://upload.wikimedia.org/wikipedia/sources/$1 [R=302]'
                ]
            }
    }
    # private wikis in remnant.conf; they all change just by ServerName
    $small_private_wikis = [
        'internal.wikimedia.org', 'grants.wikimedia.org', 'fdc.wikimedia.org',
        'board.wikimedia.org', 'boardgovcom.wikimedia.org', 'spcom.wikimedia.org',
        'affcom.wikimedia.org', 'searchcom.wikimedia.org',
        'office.wikimedia.org', 'chair.wikimedia.org',
        'auditcom.wikimedia.org', 'otrs-wiki.wikimedia.org',
        'exec.wikimedia.org', 'collab.wikimedia.org',
        'movementroles.wikimedia.org', 'checkuser.wikimedia.org',
        'steward.wikimedia.org', 'ombudsmen.wikimedia.org',
        'projectcom.wikimedia.org', 'techconduct.wikimedia.org',
        'electcom.wikimedia.org', 'advisors.wikimedia.org'
    ]
    mediawiki::web::vhost { $small_private_wikis:
        ensure          => present,
        docroot         => '/srv/mediawiki/docroot/wikimedia.org',
        legacy_rewrites => false,
        https_only      => true,
        declare_site    => false,
        short_urls      => true,
        before          => Apache::Site['remnant'],
    }

    ### END remnant

    ### BEGIN wikimania
    # Wikimania sites, plus one wiki for wikimaniateam
    apache::site { 'wikimania':
        source   => 'puppet:///modules/mediawiki/apache/sites/wikimania.conf',
        priority => 7,
    }

    ## Configuration for wikimania.conf
    mediawiki::web::vhost { 'wikimaniateam.wikimedia.org':
        ensure          => present,
        docroot         => '/srv/mediawiki/docroot/wikimedia.org',
        legacy_rewrites => false,
        https_only      => true,
        declare_site    => false,
        short_urls      => true,
        before          => Apache::Site['wikimania'],
    }
    ### END wikimania

    ### BEGIN foundation
    # wikimediafoundation wiki, already a single wiki
    mediawiki::web::vhost { 'foundation':
        server_name         => 'foundation.wikimedia.org',
        server_aliases      => ['wikimediafoundation.org'],
        canonical_name      => 'On',
        docroot             => '/srv/mediawiki/docroot/wikimediafoundation.org',
        declare_site        => true,
        priority            => 8,

        additional_rewrites => {
            'early' => [
                '# extract.php pages redirected to new pages',
                '    RewriteRule ^/fundraising(\.html)?$ %{ENV:RW_PROTO}://%{SERVER_NAME}/wiki/Fundraising [R=301,L]',
                '    RewriteRule ^/index(\.html)?$ %{ENV:RW_PROTO}://%{SERVER_NAME}/wiki/Home [R=301,L]',
                '    RewriteRule ^/GNU_FDL(\.html)?$ %{ENV:RW_PROTO}://%{SERVER_NAME}/wiki/GNU_Free_Documentation_License [R=301,L]',
                '    # Obsolete PDF redirected to current wiki page',
                '    RewriteRule ^/bylaws\.pdf %{ENV:RW_PROTO}://%{SERVER_NAME}/wiki/Wikimedia_Foundation_bylaws [R,L]',
                '    RewriteRule ^/wiki/Donate$ https://donate.wikimedia.org/ [R=301,L]'
            ],
            'late'  => [],
        },
    }

    ### END foundation

    #### BEGIN wikimedia
    # Some other wikis, plus loginwiki, and www.wikimedia.org
    apache::site { 'wikimedia':
        source   => 'puppet:///modules/mediawiki/apache/sites/wikimedia.conf',
        priority => 9,
    }


    mediawiki::web::site { 'www.wikimedia.org':
        before => Apache::Site['wikimedia']
    }

    $other_wikis = [
        'transitionteam.wikimedia.org', 'iegcom.wikimedia.org',
        'legalteam.wikimedia.org', 'zero.wikimedia.org',
        'fixcopyright.wikimedia.org'
    ]
    mediawiki::web::vhost {
        default:
            ensure          => present,
            docroot         => '/srv/mediawiki/docroot/wikimedia.org',
            legacy_rewrites => false,
            declare_site    => false,
            short_urls      => true,
            before          => Apache::Site['wikimedia'],
            ;
        $other_wikis:
            https_only => true,
            short_urls => true,
            ;
        'login.wikimedia.org':
            ;
        'wikimedia-chapter':
            server_aliases      => [
                'ar.wikimedia.org',
                'am.wikimedia.org',
                'bd.wikimedia.org',
                'be.wikimedia.org',
                'br.wikimedia.org',
                'ca.wikimedia.org',
                'cn.wikimedia.org',
                'co.wikimedia.org',
                'dk.wikimedia.org',
                'ec.wikimedia.org',
                'ee.wikimedia.org',
                'fi.wikimedia.org',
                'hi.wikimedia.org',
                'id.wikimedia.org',
                'id-internal.wikimedia.org',
                'il.wikimedia.org',
                'mai.wikimedia.org',
                'mk.wikimedia.org',
                'mx.wikimedia.org',
                'nl.wikimedia.org',
                'no.wikimedia.org',
                'noboard-chapters.wikimedia.org',
                'nyc.wikimedia.org',
                'nz.wikimedia.org',
                'pa-us.wikimedia.org',
                'pl.wikimedia.org',
                'pt.wikimedia.org',
                'romd.wikimedia.org',
                'rs.wikimedia.org',
                'ru.wikimedia.org',
                'se.wikimedia.org',
                'tr.wikimedia.org',
                'ua.wikimedia.org',
                'us.wikimedia.org',
                'wb.wikimedia.org',
            ],
            legacy_rewrites     => true,
            upload_rewrite      => 'wikimedia.org',
            additional_rewrites => {
                'early' => [
                    '# www. prefix',
                    'RewriteCond %{HTTP_HOST} ^www.([a-z\-]+)\.wikimedia\.org$',
                    'RewriteRule ^(.*)$ %{ENV:RW_PROTO}://%1.wikimedia.org$1 [R=301,L]'
                ],
                'late'  => []
            }
    }

    ### END wikimedia
}
