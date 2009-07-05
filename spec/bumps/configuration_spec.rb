require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Bumps::Configuration do
  
  before {@output_stream = mock('output stream').as_null_object}
  subject {Bumps::Configuration.new}

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
  
  it 'should allow a non-default push URL to be specified' do
    subject.push_to 'http://url.com'
    
    subject.push_url.should == 'http://url.com'    
  end

  it 'should allow a non-default pull URL to be specified' do
    subject.pull_from 'http://url.com'
    
    subject.pull_url.should == 'http://url.com'    
  end
    
  it 'should allow the feature directory to be set' do
    subject.feature_directory = 'feature_directory'
    
    subject.feature_directory.should == 'feature_directory'
  end
  
  it 'should allow results formatter to be specified' do
    formatter_class = mock 'formatter class'
    
    subject.format_results_with formatter_class
    
    subject.results_formatter.should == formatter_class
  end
  
  it 'should default the results formatter to Cucumber HTML formatter' do
    subject.results_formatter.should == Cucumber::Formatter::Html
  end
  
  it 'should allow access to configuration via class' do
    singleton = mock 'singleton'
    Bumps::Configuration.stub!(:singleton).and_return singleton
    
    singleton.should_receive(:configuration_property=).with 'arg'
    
    Bumps::Configuration.configuration_property = 'arg'
  end
  
end