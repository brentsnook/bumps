require File.dirname(__FILE__) + '/spec_helper.rb'

describe Pickle, 'configuration' do

  it 'should configure the new configuration using the given directives' do
    Pickle::PreFeatureLoadHook.stub! :register_on
    
    # how can we specify that it should be passed a reference to a block?
    Pickle::Configuration.should_receive(:configure)
    
    Pickle.configure {}
  end

  it 'should register a pre feature load hook on the main Cucumber class' do
    Pickle::PreFeatureLoadHook.should_receive(:register_on).with Cucumber::Cli::Main
    
    Pickle.configure {}
  end

end