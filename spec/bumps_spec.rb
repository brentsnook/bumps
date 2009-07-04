require File.dirname(__FILE__) + '/spec_helper.rb'

describe Bumps, 'configuration' do

  it 'should configure the new configuration using the given directives' do
    Bumps::PreFeatureLoadHook.stub! :register_on
    
    # how can we specify that it should be passed a reference to a block?
    Bumps::Configuration.should_receive(:configure)
    
    Bumps.configure {}
  end

  it 'should register a pre feature load hook on the main Cucumber class' do
    Bumps::PreFeatureLoadHook.should_receive(:register_on).with Cucumber::Cli::Main
    
    Bumps.configure {}
  end

end