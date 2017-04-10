class apassi {
	package {apache2:
		ensure => 'installed',
		allowcdrom => 'true',
	}

	file {'/var/www/html/index.html':
		content => 'Hello everybody!',
		require => Package["apache2"],
	}
	
	service {apache2:
		ensure => 'running',
		enable => 'true',
		subscribe => File ['/var/www/html/index.html'],
	}
}
