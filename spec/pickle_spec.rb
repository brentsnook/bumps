require File.dirname(__FILE__) + '/spec_helper.rb'

describe Pickle, 'configuration' do
  it 'should create a new configuration using STDOUT' do
    Pickle::FeaturePullHook.stub! :create
    Pickle::Configuration.should_receive(:new).with(STDOUT).and_return mock('configuration', :null_object => true)
    
    Pickle.configure {}
  end  
  
  it 'should configure the new configuration using the given directives' do
    Pickle::FeaturePullHook.stub! :create
    config = mock 'configuration'
    Pickle::Configuration.stub!(:new).and_return config
    
    # how can we specify that it should be passed a reference to a block?
    config.should_receive(:configure)
    
    Pickle.configure {}
  end

  it 'should register a feature pull hook using the main Cucumber class and newly created configuration' do
    configuration = mock :configuration, :null_object => true
    Pickle::Configuration.stub!(:new).and_return configuration
    
    Pickle::FeaturePullHook.should_receive(:create).with Cucumber::Cli::Main, configuration
    
    Pickle.configure {}
  end
end