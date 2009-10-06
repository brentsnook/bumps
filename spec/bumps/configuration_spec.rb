require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Bumps::Configuration do
  
  before {@output_stream = mock('output stream').as_null_object}
  subject {Bumps::Configuration.new}

  it 'provides an output stream for writing messages' do
    out_stream = mock 'out stream'
    subject.output_stream = out_stream
    
    subject.output_stream.should == out_stream
  end  
  
  it 'is configured using a block' do
    subject.should_receive(:configuration_call)
    
    subject.configure { configuration_call }
  end
  
  it 'derives pull URL from server' do
    subject.use_server 'http://server'
    
    subject.pull_url.should == 'http://server/features/content'
  end
  
  it 'derives push URL from server' do
    subject.use_server 'http://server'
    
    subject.push_url.should == 'http://server/features/results'
  end
  
  it 'recognises a server URL with a trailing slash' do
    subject.use_server 'http://server/'
    
    subject.pull_url.should match(/^http:\/\/server\/[a-z]/)
  end
  
  it 'allows a non-default push URL to be specified' do
    subject.push_to 'http://url.com'
    
    subject.push_url.should == 'http://url.com'    
  end

  it 'allows a non-default pull URL to be specified' do
    subject.pull_from 'http://url.com'
    
    subject.pull_url.should == 'http://url.com'    
  end
    
  it 'allows the feature directory to be set' do
    subject.feature_directory = 'feature_directory'
    
    subject.feature_directory.should == 'feature_directory'
  end
  
  it 'allows results formatter to be specified' do
    formatter_class = mock 'formatter class'
    
    subject.format_results_with formatter_class
    
    subject.results_formatter.should == formatter_class
  end
  
  it 'defaults the results formatter to Cucumber HTML formatter' do
    subject.results_formatter.should == Cucumber::Formatter::Html
  end
  
  it 'can have only one instance' do
    singleton = mock 'singleton'
    Bumps::Configuration.stub!(:singleton).and_return singleton
    
    singleton.should_receive(:configuration_property=).with 'arg'
    
    Bumps::Configuration.configuration_property = 'arg'
  end
  
end