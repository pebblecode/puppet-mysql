# == Class: motd
#
# Sets motd
#
# === Parameters
#
# none
#
# === Variables
#
# [mysql_password]
#   The root MySQL password
#
# === Examples
#
# include motd
#
# === Authors
#
# George Ornbo <george@shapeshed.com>
#
# === Copyright
#
# Copyright 2012 George Ornbo, unless otherwise noted.
#
class mysql::server {
  package { "mysql-server": ensure => installed }
  service { "mysql":
    enable => true,
    ensure => running,
    require => Package["mysql-server"],
  }
  file { "/etc/mysql/my.cnf":
    owner   => "mysql", group => "mysql",
    source  => "puppet:///mysql/my.cnf",
    notify  => Service["mysql"],
    require => Package["mysql-server"],
  }
  exec { "set-mysql-password":
    unless => "/usr/bin/mysqladmin -uroot -p${mysql_password} status",
    command => "/usr/bin/mysqladmin -uroot password ${mysql_password}",
    require => Service["mysql"],
  } 
}
