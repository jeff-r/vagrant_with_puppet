node default {
  include apt
  include stdlib

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

  file{"/root/.vimrc":
    ensure  => link,
    target  => "/vagrant/puppet/files/.vimrc",
    force => true,
  }
}
