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

  package{"git":
    ensure => present,
  }

  file{"/etc/nginx/sites-enabled/default":
    ensure => link,
    target => "/vagrant/files/nginx/default",
    force  => true
  }

  service{"nginx":
    ensure  => running,
    require => [ Package["nginx-full"], File["/etc/nginx/sites-enabled/default"] ]
  }

  # dotfiles
  file{"/root/ez-dotfiles":
    ensure  => link,
    target  => "/vagrant/files/ez-dotfiles",
  }
  file{"/root/scripts":
    ensure  => link,
    target  => "/vagrant/files/ez-dotfiles/scripts",
  }
  file{"/root/.vim":
    ensure  => link,
    target  => "/vagrant/files/ez-dotfiles/vim/vim",
  }
  file{"/root/.vimrc":
    ensure  => link,
    target  => "/vagrant/files/ez-dotfiles/vim/vimrc",
  }
  file{"/root/.bashrc":
    ensure  => link,
    target  => "/vagrant/files/ez-dotfiles/bash/bashrc"
  }
  file{"/root/.bash_profile":
    ensure  => link,
    target  => "/vagrant/files/ez-dotfiles/bash/bash_profile"
  }
  file{"/root/.bash_aliases":
    ensure  => link,
    target  => "/vagrant/files/ez-dotfiles/bash/bash_aliases"
  }
  file{"/root/.bash_functions":
    ensure  => link,
    target  => "/vagrant/files/ez-dotfiles/bash/bash_functions"
  }
  file{"/root/.bash_path":
    ensure  => link,
    target  => "/vagrant/files/ez-dotfiles/bash/bash_path"
  }
  file{"/root/.gitconfig":
    ensure  => link,
    target  => "/vagrant/files/ez-dotfiles/git/gitconfig"
  }
  file{"/root/.tmux.conf":
    ensure  => link,
    target  => "/vagrant/files/ez-dotfiles/tmux/tmux.conf"
  }
}
