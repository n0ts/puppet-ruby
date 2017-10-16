require "spec_helper"

describe "ruby" do
  let(:facts) { default_test_facts }

  let(:default_params) do
    {
      :provider => "rbenv",
      :prefix   => "/test/boxen",
    }
  end

  let(:params) { default_params }

  it { should contain_class("ruby::build") }

  context "provider is rbenv" do
    let(:params) {
      default_params.merge(:provider => "rbenv")
    }

    it { should contain_class("ruby::rbenv") }
  end

  context "provider is chruby" do
    let(:params) {
      default_params.merge(:provider => "chruby")
    }

    it { should contain_class("ruby::chruby") }
  end

  context "osfamily is Darwin" do
    let(:facts) {
      default_test_facts.merge(:osfamily => "Darwin")
    }

    it { should contain_class("boxen::config") }
    it { should contain_boxen__env_script("ruby") }
  end
end
