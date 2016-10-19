require 'spec_helper'

describe 'ruby::definition' do
  let(:facts) { default_test_facts }
  let(:title) { '2.2.0' }

  let(:definition_path) do
    [
      '/test',
      'boxen',
      'ruby-build',
      'share',
      'ruby-build',
      title
    ].join('/')
  end

  it do
    should contain_class('ruby')
    should contain_class('ruby::build')
  end
end
