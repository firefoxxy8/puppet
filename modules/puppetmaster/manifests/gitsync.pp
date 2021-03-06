# == Class: puppetmaster::gitsync
#
# Sync local operations/puppet.git checkout with upstream.
class puppetmaster::gitsync(
    $run_every_minutes = '10',
) {

    ensure_packages([
        'python3-git',
        ])


    file { '/usr/local/bin/git-sync-upstream':
        ensure => present,
        source => 'puppet:///modules/puppetmaster/git-sync-upstream',
        owner  => 'root',
        group  => 'root',
        mode   => '0555',
    }

    cron { 'rebase_operations_puppet':
        ensure  => present,
        user    => 'root',
        minute  => "*/${run_every_minutes}",
        command => '/usr/local/bin/git-sync-upstream >>/var/log/git-sync-upstream.log 2>&1',
        require => File['/usr/local/bin/git-sync-upstream'],
    }

    logrotate::conf { 'git-sync-upstream':
        ensure => present,
        source => 'puppet:///modules/puppetmaster/git-sync-upstream.logrotate',
    }

    sudo::user { 'cherry_pick_count':
        ensure     => present,
        user       => 'diamond',
        privileges => [ 'ALL = (root) NOPASSWD: /usr/bin/git --git-dir=/var/lib/git/operations/puppet/.git log --pretty=oneline --abbrev-commit origin/HEAD..HEAD' ],
    }

    diamond::collector { 'CherryPickCounter':
        ensure  => present,
        source  => 'puppet:///modules/puppetmaster/cherry-pick-counter-collector.py',
        require => Sudo::User['cherry_pick_count'],
    }
}
