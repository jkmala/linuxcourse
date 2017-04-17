class apassi {
	
	package {'apache2':
		ensure => 'installed',
		allowcdrom => 'true',
	}
	
	file {'/home/xubuntu/publicwebsite':
		ensure => 'directory',
		owner => 'xubuntu',
		group => 'xubuntu',
	}
	
	file {'/home/xubuntu/publicwebsite/index.html':
		content => "New life for Apache2!",
		owner => 'xubuntu',
		group => 'xubuntu',
	}
	
	file {'/etc/apache2/sites-available/xubuntu.conf':
		content => template("apassi/xubuntu.conf.erb"),
		require => Package['apache2'],
		notify => Service['apache2'],
	}
	
	file {'/etc/apache2/sites-enabled/xubuntu.conf':
		ensure => 'link',
		target => '/etc/apache2/sites-available/xubuntu.conf'
		#require => File['/etc/apache2/sites-available/xubuntu.conf'],
				
	}
	
	file {'/etc/apache2/sites-enabled/000-default.conf':
		ensure => 'absent',
	}
	
	service {'apache2':
		ensure => 'running',
		enable => 'true',
		require => Package["apache2"],
	}	
}
