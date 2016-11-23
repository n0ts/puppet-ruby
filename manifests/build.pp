# (Internal) Installs ruby-build

class ruby::build(
  $ensure = $ruby::build::ensure,
  $prefix = $ruby::build::prefix,
  $user   = $ruby::build::user,
) {
  require ruby

  if $::osfamily == 'Darwin' {
      require homebrew
      package { 'ruby-build':
        ensure => latest,
      }
  } else {
    repository { $prefix:
      ensure => $ensure,
      force  => true,
      source => 'sstephenson/ruby-build',
      user   => $user,
    }
  }

  ensure_resource('file', "${::ruby::prefix}/cache/rubies", {
    'ensure' => 'directory',
    'owner'  => $user,
  })
}
