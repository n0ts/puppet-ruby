require 'rspec-puppet'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path  = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
  c.hiera_config = File.join(fixture_path, 'hiera/hiera.yaml')
end

def default_test_facts
  {
    :boxen_home                  => '/test/boxen',
    :boxen_user                  => 'testuser',
    :boxen_repodir               =>  File.join(File.dirname(__FILE__), 'fixtures'),
    :boxen_repo_url_template     => "https://github.com/%s",
    :boxen_srcdir                => '/test/boxen/src',
    :macosx_productversion_major => '10.13',
    :osfamily                    => 'Darwin',
  }
end
