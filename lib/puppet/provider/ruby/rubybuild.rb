require "fileutils"

require 'puppet/util/execution'

Puppet::Type.type(:ruby).provide(:rubybuild) do
  include Puppet::Util::Execution

  def self.rubylist
    rbenv_root = if Facter.value(:boxen_home)
      "#{Facter.value(:boxen_home)}/rbenv"
    else
      "/opt/rubies"
    end
    @rubylist ||= Dir["#{rbenv_root}/versions/*"].map do |ruby|
      if File.directory?(ruby) && File.executable?("#{ruby}/bin/ruby")
        File.basename(ruby)
      end
    end.compact
  end

  def self.instances
    rubylist.map do |ruby|
      new({
        :name     => ruby,
        :version  => ruby,
        :ensure   => :present,
        :provider => "rubybuild",
      })
    end
  end

  def query
    if self.class.rubylist.member?(version)
      { :ensure => :present, :name => version, :version => version}
    else
      { :ensure => :absent,  :name => version, :version => version}
    end
  end

  def create
    build_ruby
  rescue => e
    raise Puppet::Error, "install failed with a crazy error: #{e.message} #{e.backtrace}"
  end

  def destroy
    FileUtils.rm_rf prefix
  end

private
  def build_ruby
    execute "rbenv install #{version}", command_options.merge(:failonfail => true)
    execute "rbenv install #{version}", command_options.merge(:failonfail => true)
  end

  def ruby_build
    @resource[:ruby_build]
  end

  def command_options
    {
      :combine            => true,
      :custom_environment => environment,
      :uid                => @resource[:user],
      :failonfail         => true,
    }
  end

  def environment
    return @environment if defined?(@environment)

    @environment = Hash.new

    @environment["RUBY_BUILD_CACHE_PATH"] = cache_path
    @environment["RBENV_ROOT"] = rbenv_root

    @environment.merge!(@resource[:environment])
  end

  def cache_path
    @cache_path ||= if Facter.value(:boxen_home)
      "#{Facter.value(:boxen_home)}/cache/rubies"
    else
      "/tmp/rubies"
    end
  end

  def version
    @resource[:version]
  end

  def rbenv_root
    if Facter.value(:boxen_home)
      "#{Facter.value(:boxen_home)}/rbenv"
    else
      "/opt/rubies"
    end
  end
end
