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

Init.pp -tiedoston sisällöksi kopioin Karvisen tekemän esimerkin omilla muokkaukselle (allowcdrom, koska liveUsb:

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

Tree -komento antoi
    
    $ tree
    .
    ├── homework3.md
    └── modules
        └── juhasshd
            ├── manifests
            │   └── init.pp
            └── templates
                └── sshd_config.erb

Tässä vaiheessa halusin kokeilla Puppetin ajoa komennolla:

    $ puppet apply --modulepath modules/ -e 'class {"juhasshd":}'
    Error: Could not match “juhasshd/sshd_config.erb”), at /home/xubuntu/linuxcourse/sshd/modules/juhasshd/manifests/init.pp:8 on node xubuntu.elisa
    Error: Could not match “juhasshd/sshd_config.erb”), at /home/xubuntu/linuxcourse/sshd/modules/juhasshd/manifests/init.pp:8 on node xubuntu.elisa

Tarviko tähän sudoa?

    sudo puppet apply --modulepath modules/ -e 'class {"juhasshd":}'
    Error: Could not match “juhasshd/sshd_config.erb”), at /home/xubuntu/linuxcourse/sshd/modules/juhasshd/manifests/init.pp:8 on node xubuntu.elisa
    Error: Could not match “juhasshd/sshd_config.erb”), at /home/xubuntu/linuxcourse/sshd/modules/juhasshd/manifests/init.pp:8 on node xubuntu.elisa
    
Ei auttanut, muokkasin template -rivin pois init.pp tiedostosta ja ajoin uudelleen komennon:

    xubuntu@xubuntu:~/linuxcourse/sshd$ sudo puppet apply --modulepath modules/ -e 'class {"juhasshd":}'
    Notice: Compiled catalog for xubuntu.elisa in environment production in 0.36 seconds
    Notice: /Stage[main]/Juhasshd/Package[ssh]/ensure: ensure changed 'purged' to 'present'
    Notice: Finished catalog run in 1.95 seconds
Ainakin lähti toimimaan ja käytän komentoa service sshd status -todistaakseni että ssh-daemon on päällä portissa 22. Template tiedostoni pitäisi muuttaa nimenomaan portin joksikin toiseksi.

    xubuntu@xubuntu:~/linuxcourse/sshd$ service sshd status
    ● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2017-04-17 18:46:40 UTC; 1h 25min ago
    Main PID: 12155 (sshd)
     CGroup: /system.slice/ssh.service
             └─12155 /usr/sbin/sshd -D

    Apr 17 18:46:40 xubuntu systemd[1]: Starting OpenBSD Secure Shell server...
    Apr 17 18:46:40 xubuntu sshd[12155]: Server listening on 0.0.0.0 port 22.
    Apr 17 18:46:40 xubuntu sshd[12155]: Server listening on :: port 22.
    Apr 17 18:46:40 xubuntu systemd[1]: Started OpenBSD Secure Shell server.

Muokkaan taas init.pp tiedostoa ja lisään sinne aikaisemmin poistamani rivin. Tällä kertaa kirjoitan sen itse käsin, jonka jälkeen se näyttää tältä:

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

Mielestäni se näyttää ihan samalta, kuin aiemmin. Ajan Puppetin uudelleen ja tarkistan ssh-daemonin portin:

    xubuntu@xubuntu:~/linuxcourse/sshd$ sudo puppet apply --modulepath modules/ -e 'class {"juhasshd":}'
    Notice: Compiled catalog for xubuntu.elisa in environment production in 0.37 seconds
    Notice: /Stage[main]/Juhasshd/File[/etc/ssh/sshd_config]/content: content changed '{md5}bd3a2b95f8b4b180eed707794ad81e4d' to '{md5}13f1e619e91b82c8e80c01e12462b3f3'
    Notice: /Stage[main]/Juhasshd/Service[ssh]: Triggered 'refresh' from 1 events
    Notice: Finished catalog run in 0.12 seconds
    xubuntu@xubuntu:~/linuxcourse/sshd$ service sshd status
    ● ssh.service - OpenBSD Secure Shell server
       Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
       Active: active (running) since Mon 2017-04-17 20:15:27 UTC; 24s ago
     Main PID: 13649 (sshd)
       CGroup: /system.slice/ssh.service
               └─13649 /usr/sbin/sshd -D

    Apr 17 20:15:27 xubuntu systemd[1]: Starting OpenBSD Secure Shell server...
    Apr 17 20:15:27 xubuntu sshd[13649]: Server listening on 0.0.0.0 port 52222.
    Apr 17 20:15:27 xubuntu sshd[13649]: Server listening on :: port 52222.
    Apr 17 20:15:27 xubuntu systemd[1]: Started OpenBSD Secure Shell server.
    
Kuten statuksesta näkyy portti on muutettu nyt 52222.

B) Yritän löytää tietoa ja esimerkkejä, mikä olisi paras keino siirtää Gitistä modulit suoraan uuteen koneeseen. Luulen, että ensin pitäisi asentaa: Git ja Puppet. Sitten voisi ensin kloonata gitistä puppet modulin omassa kansiossaan paikalliseen koneeseen ja sitten ajaa puppet. Aika monimutkaista, varmaan joku on keksinyt suoraviivaisemmankin keinon, esimerkiksi librarian-puppet. Mutta kokeilemaan seuraavia komentoja:
   
    $ sudo apt-get install -y puppet
    $ sudo apt-get install -y git
    $ git clone https://github.com/...
    $ sudo puppet apply --modulepath folder/modules/ -e 'class {"name":}'
    

