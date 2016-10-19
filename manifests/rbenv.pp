# Manage ruby versions with rbenv.
#
# Usage:
#
#     include ruby::rbenv
#
# Normally internal use only; will be automatically included by the `ruby` class
# if `ruby::provider` is set to "rbenv"

class ruby::rbenv(
  $ensure  = $ruby::rbenv::ensure,
  $prefix  = $ruby::rbenv::prefix,
  $user    = $ruby::rbenv::user,
  $plugins = {}
) {
  require ruby

  if $::osfamily == 'Darwin' {
    require homebrew
    package { 'rbenv': }

    $require = Package['rbenv']

    file { "${prefix}/versions":
      ensure  => directory,
      owner   => $user,
      require => $require,
    }
  } else {
    repository { $prefix:
      ensure => $ensure,
      force  => true,
      source => 'sstephenson/rbenv',
      user   => $user
    }

    $require = Repository[$prefix]

    file { "${prefix}/versions":
      ensure  => symlink,
      force   => true,
      backup  => false,
      target  => '/opt/rubies',
      require => $require,
    }
  }

  file { $prefix:
    ensure  => directory,
    owner   => $user,
    require => $require,
  }

  if !empty($plugins) and $ensure != 'absent' {

    file { "${prefix}/plugins":
      ensure  => directory,
      require => $require
    }

    create_resources('ruby::rbenv::plugin', $plugins)

  }
}
