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

  file{"/root/ez-dotfiles":
    ensure  => link,
    target  => "/vagrant/puppet/files/ez-dotfiles",
  }
  file{"/root/scripts":
    ensure  => link,
    target  => "/vagrant/puppet/files/ez-dotfiles/scripts",
  }
  file{"/root/.vim":
    ensure  => link,
    target  => "/vagrant/puppet/files/ez-dotfiles/vim/vim",
  }
  file{"/root/.vimrc":
    ensure  => link,
    target  => "/vagrant/puppet/files/ez-dotfiles/vim/vimrc",
  }

  file{"/root/.bashrc":
    ensure  => link,
    target  => "/vagrant/puppet/files/ez-dotfiles/bash/bashrc"
  }
  file{"/root/.bash_profile":
    ensure  => link,
    target  => "/vagrant/puppet/files/ez-dotfiles/bash/bash_profile"
  }
  file{"/root/.bash_aliases":
    ensure  => link,
    target  => "/vagrant/puppet/files/ez-dotfiles/bash/bash_aliases"
  }
  file{"/root/.bash_functions":
    ensure  => link,
    target  => "/vagrant/puppet/files/ez-dotfiles/bash/bash_functions"
  }
  file{"/root/.bash_path":
    ensure  => link,
    target  => "/vagrant/puppet/files/ez-dotfiles/bash/bash_path"
  }

  file{"/root/.gitconfig":
    ensure  => link,
    target  => "/vagrant/puppet/files/ez-dotfiles/git/gitconfig"
  }

  file{"/root/.tmux.conf":
    ensure  => link,
    target  => "/vagrant/puppet/files/ez-dotfiles/tmux/tmux.conf"
  }
}
