require 'spec_helper'
require 'aws-sdk'
require 'ostruct'

RSpec.describe 'module Redshift' do

  before(:each) do
    yamlContent = 'access_key_id: blah'
    allow(File).to receive(:read).with('your_credentials.yml').and_return(yamlContent)

    load "#{Dir.pwd}/SdkCredentials.rb"
    sdkDouble = instance_double(SdkCredentials, :getCreds => {:region => 'region1'}, :getAccId => 'acc id')
    allow(SdkCredentials).to receive(:new).and_return(sdkDouble)

    @redshiftClientDouble = instance_double(Aws::Redshift::Client)
    allow(Aws::Redshift::Client).to receive(:new).and_return(@redshiftClientDouble)
  end

  after(:each) do
    RSpec::Mocks.space.proxy_for(Aws::Redshift::Client).reset
    RSpec::Mocks.space.proxy_for(Object).reset
  end

  context 'Redshift Deploy' do
    it 'should always load Redshift.rb' do
      load "#{Dir.pwd}/Redshift.rb"
    end
  end

end
