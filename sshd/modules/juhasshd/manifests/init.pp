class juhasshd {
        package { 'ssh':
                ensure => 'installed',
		allowcdrom => 'true',
        }

        file { '/etc/ssh/sshd_config':
		content => template('juhasshd/sshd_config.erb'),
                require => Package['ssh'],
                notify => Service['ssh'],
        }

        service {'ssh':
                ensure => 'running',
                enable => 'true',
                require => Package['ssh'],
        }
}
