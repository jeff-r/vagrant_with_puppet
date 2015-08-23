Vagrant and puppet files to bring up a new Ubuntu VM for development.

 * Uses a snapshot of the vim and bash files from ez-dotfiles.
 * For fun, installs nginx, and puts the site config file in this repository

Usage:

    gem install bundler
    bundle
    librarian-puppet install
    vagrant up
