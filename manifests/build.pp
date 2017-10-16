# (Internal) Installs ruby-build

class ruby::build(
  $ensure = $ruby::build::ensure,
  $prefix = $ruby::build::prefix,
  $user   = $ruby::build::user,
) {
  require ruby

  require homebrew
  package { 'ruby-build': }

  ensure_resource('file', "${::ruby::prefix}/cache/rubies", {
    'ensure' => 'directory',
    'owner'  => $user,
  })
}
