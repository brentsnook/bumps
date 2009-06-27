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
    
    subject.pull_url.should == 'http://server/features/content'
  end
  
  it 'should derive push URL from server' do
    subject.use_server 'http://server'
    
    subject.push_url.should == 'http://server/features/results'
  end
  
  it 'should be able to handle a server URL with a trailing slash' do
    subject.use_server 'http://server/'
    
    subject.pull_url.should match(/^http:\/\/server\/[a-z]/)
  end
  
  it 'should allow the feature directory to be set' do
    subject.feature_directory = 'feature_directory'
    
    subject.feature_directory.should == 'feature_directory'
  end
  
end