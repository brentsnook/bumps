require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Pickle::Configuration do
  
  before {@output_stream = mock('output stream').as_null_object}
  subject {Pickle::Configuration.new}

  it 'should provide access to the output stream' do
    out_stream = mock 'out stream'
    subject.output_stream = out_stream
    
    subject.output_stream.should == out_stream
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
  
  it 'should allow the pushed content formatter to be set' do
    formatter = mock 'formatter'
    subject.push_content_formatter = formatter
    
    subject.push_content_formatter.should == formatter
  end
  
  it 'should default the pushed content formatter to Cucumber HTML formatter' do
    subject.push_content_formatter.should == Cucumber::Formatter::Html
  end
  
  it 'should allow access to configuration via class' do
    singleton = mock 'singleton'
    Pickle::Configuration.stub!(:singleton).and_return singleton
    
    singleton.should_receive(:configuration_property=).with 'arg'
    
    Pickle::Configuration.configuration_property = 'arg'
  end
  
end