node default {
  notify{ "The default puppet configuration": }
}

node vagrant-ubuntu-trusty-64 {
  include apt

  notify{ "We're in Ubuntu": }
  file{"/root/test-file.txt":
    ensure  => "file",
    content => "This file is managed by puppet",
  }

  package{"nginx-full":
    ensure => present,
  }

  service{"nginx":
    ensure  => running,
    require => Package["nginx-full"],
  }

  file{"/root/nginx.foo":
    ensure  => file,
    content => "Woo hoo!",
    notify  => Service["nginx"],
  }

  file{"/etc/puppet/":
    ensure => link,
    target => "/vagrant/puppet/"
  }
}

node www {
  notify{ "We're in www": }
}

