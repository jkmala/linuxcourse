class setup {
	package{'ssh':
		ensure => 'installed',
		allowcdrom => 'true',
	}
        package{'tree':
                ensure => 'installed',
                allowcdrom => 'true',
        }
        package{'curl':
                ensure => 'installed',
                allowcdrom => 'true',
        }
        package{'gimp':
                ensure => 'installed',
                allowcdrom => 'true',
        }
        package{'lighttable':
                ensure => 'installed',
                allowcdrom => 'true',
        }

}
