require 'spec_helper'

describe 'ruby::rbenv' do
  let(:facts) { default_test_facts }

  let(:default_params) do
    {
      :ensure   => '1.1.1',
      :prefix   => '/test/boxen/rbenv',
      :user     => 'testuser',
      :plugins  => {}
    }
  end

  let(:params) { default_params }

  context 'ensure => present' do
    context 'default params' do
      it do
        should contain_class('ruby')
        should contain_file('/test/boxen/rbenv').with({
          :ensure  => 'directory',
          :owner   => 'testuser',
        }).that_requires('Package[rbenv]')
      end
    end

    context 'osfamily is Darwin' do
      let(:facts) {
        default_test_facts.merge(:osfamily => 'Darwin')
      }

      it do
        should contain_class('homebrew')
        should contain_package('rbenv')

        should contain_file('/test/boxen/rbenv/versions').with({
          :ensure  => 'directory',
          :owner   => 'testuser',
          :require => 'Package[rbenv]',
        })
      end
    end

    context 'osfamily is not Darwin' do
      let(:facts) {
        default_test_facts.merge(:osfamily => 'Linux', :id => 'root')
      }

      it do
        should_not contain_class('homebrew')
        should_not contain_package('rbenv')

        should contain_repository('/test/boxen/rbenv').with({
          :ensure => default_params[:ensure],
          :force  => true,
          :source => 'sstephenson/rbenv',
          :user   => 'testuser',
        })

        should contain_file('/test/boxen/rbenv/versions').with({
          :ensure  => 'symlink',
          :force   => true,
          :backup  => false,
          :target  => '/opt/rubies',
          :require => 'Repository[/test/boxen/rbenv]',
        })
      end
    end

    context 'when plugins is default or empty' do
      it do
        should_not contain_file('/test/boxen/rbenv/plugins')
        should_not contain_ruby__rbenv__plugin('rbenv-vars')
      end
    end

    context 'when plugins is not empty' do
      let(:params) {
        default_params.merge(:plugins => {
                               'rbenv-vars' => {
                                 'ensure' => 'v1.2.0',
                                 'source' => 'sstephenson/rbenv-vars'
                               }
                             }
        )
      }

      it do
        should contain_file('/test/boxen/rbenv/plugins')
        should contain_ruby__rbenv__plugin('rbenv-vars').with({
          :ensure => params[:plugins]['rbenv-vars']['ensure'],
          :source => 'sstephenson/rbenv-vars'
        })
      end
    end
  end

  context 'ensure => absent' do
    let(:params) {
      default_params.merge(:ensure => 'absent',
                           :plugins => {
                             'rbenv-vars' => {
                               'ensure' => params[:plugins]['rbenv-vars']['ensure'],
                               'source' => 'sstephenson/rbenv-vars'
                             }
                           }
      )
    }

    it do
      should_not contain_file('/test/boxen/rbenv/plugins')
      should_not contain_ruby__rbenv__plugin('rbenv-vars')
    end
  end
end
