require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Pickle::Configuration do
  
  before {@output_stream = mock('output stream', :null_object => true)}
  subject {Pickle::Configuration}

  it 'should return STDOUT as the output stream' do
    subject.output_stream.should == STDOUT
  end  
  
  it 'should allow configuration using a block' do
    subject.should_receive(:configuration_call)
    
    subject.configure { configuration_call }
  end
  
  it 'should derive pull URL from server' do
    subject.use_server 'http://server'
    
    subject.feature_location.should == 'http://server/pull_features'
  end
  
  it 'should allow the feature directory to be set' do
    subject.feature_directory = 'feature_directory'
    
    subject.feature_directory.should == 'feature_directory'
  end
  
  # it 'should create a new configuration using STDOUT' do
  #   Pickle::FeaturePullHook.stub! :register_on
  #   Pickle::Configuration.should_receive(:new).with(STDOUT).and_return mock('configuration', :null_object => true)
  #   
  #   Pickle.configure {}
  # end  
  
end