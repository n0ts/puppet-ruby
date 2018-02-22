# Public: specify the global ruby version (only for rbenv)
#
# Usage:
#
#   class { 'ruby::global': version => '2.4.2' }
#
class ruby::global($version = '2.4.2') {
  require ruby

  if $ruby::provider == 'rbenv' {
    if $version != 'system' {
      ensure_resource('ruby::version', $version)
      $require = Ruby::Version[$version]
    } else {
      $require = undef
    }

    file { "${ruby::rbenv::prefix}/version":
      ensure  => present,
      owner   => $ruby::user,
      mode    => '0644',
      content => "${version}\n",
      require => $require,
    }
  }
}
