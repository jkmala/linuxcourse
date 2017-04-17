# Linuxin keskitetty hallinta

## Läksy 3:

Tehtävänanto löytyi [opettajan sivuilta](http://terokarvinen.com/2017/aikataulu-%E2%80%93-linuxin-keskitetty-hallinta-%E2%80%93-ict4tn011-11-%E2%80%93-loppukevat-2017-p2#comment-22379).

Käytin tehtävän tekemiseen Live-USB muistitikkua, joten aloitin ihan alkutekijöistä. Käyttämäni tietokoneen Biosiin oli laitettu asetukseksi Ultra Fast Boot, jolloin en pääse Boot menu -valikkoon mitenkään, vaan käyttöjärjestelmä Windows 10 latautui valmiiksi. Kirjoitin hakutoimintoon "käynnistys", jolla löysin valikon, josta löytyi muistitikulta käynnistys. Eli latasin Windows 10 puolelta suoraan käyttöjärjestelmän USB-tikulta.

Linuxin käynnistyttyä, suoritin peruskomennot:

    $ setxkbmap fi
    $ uname -a
    Linux xubuntu 4.4.0-31-generic #50-Ubuntu SMP Wed Jul 13 00:07:12 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
    $ lsb_release -a
    No LSB modules are available.
    Distributor ID:	Ubuntu
    Description:	Ubuntu 16.04.1 LTS
    Release:	16.04
    Codename:	xenial

Yllä olevilla komennoilla selvitin koneen perustiedot.

    $ sudo apt-get update
    $ sudo apt-get install tree
    $ sudo apt-get install curl
    $ sudo apt-get install puppet
    $ sudo apt-get install git

Halusin käyttää jo aikaisemmin perustamaani Git -projektia, joten kloonasin sen paikalliselle koneelle käskyllä:

    $ git clone https://github.com/jkmala/linuxcourse

Perustin kansion tätä kotitehtävää varten komennolla:

    $ mkdir sshd
    
Lisäksi perustin tämän raportointisivun komennolla:

    $ nano sshd/homework3.md
    
Tässä vaiheessa kertasin itselleni, miten SSHD asennetaan koneelle käsin. Asensin sen, tarkistin kansion /etc/ssh/ ja sieltä löysin tiedoston sshd_config, jolla pystyy määrittelemään SSH daemonin käyttämän portin. Tein siitä template -tiedoston Puppetille komennoilla:
    
    $ mkdir -p ~/linuxcourse/sshd/modules/juhasshd/templates
    $ cp sshd_config ~/linuxcourse/sshd/modules/juhasshd/templates/sshd_config.erb

Parametri -p mkdir -komennossa tarkoittaa, että kaikki polkua varten tarvittavat kansiot perustetaan myös.
Tässä vaiheessa kävin muokkaamassa templates -kansiosta löytyvää sshd_config.erb tiedostoa riviltä, jossa luki "Port 22" muotoon "Port 52222". Poistin myös juuri asentamani SSHD-daemonin koneeltani komennolla:

    $ sudo apt-get purge ssh
    
Seuraavaksi kirjoitin manifestin [Tero Karvisen sivuilta](http://terokarvinen.com/2013/ssh-server-puppet-module-for-ubuntu-12-04) löytyvän ohjeen avulla.

    $ mkdir -p /modules/juhasshd/manifests
    $ nano modules/juhasshd/manifests/init.pp
    
    class juhasshd {
        package { 'ssh':
                ensure => 'installed',
		allowcdrom => 'true',
        }

        file { '/etc/ssh/sshd_config':
                content => template(“juhasshd/sshd_config”),
                require => Package['ssh'],
                notify => Service['ssh'],
        }

        service {'ssh':
                ensure => 'running',
                enable => 'true',
                require => Package['ssh'],
        }
    }

    
    
    $ tree
    .
    ├── homework3.md
    └── modules
        └── juhasshd
            ├── manifests
            │   └── init.pp
            └── templates
                └── sshd_config.erb

