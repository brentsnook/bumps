require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Pickle::Configuration do
  
  before {@output_stream = mock('output stream', :null_object => true)}
  subject {Pickle::Configuration.new @output_stream}
  
  it 'should load configuration from pickle.yml' do
    File.stub!(:exist?).and_return true
    IO.stub!(:read).with('pickle.yml').and_return (file_contents = mock('file'))
    subject.stub! :assert_required_present
    YAML.should_receive(:load).with(file_contents).and_return({'feature_directory' => ''})
    
    subject.feature_directory
  end
  
  it 'should fail if yaml file could not be found' do
    File.stub!(:exist?).with('pickle.yml').and_return false
    
    lambda{ subject.feature_directory }.should raise_error(RuntimeError, 'Pickle configuration file (pickle.yml) was not found')
  end
  
  it 'should retrieve feature_location property' do
    File.stub!(:exist?).and_return true
    IO.stub!(:read).and_return 'feature_location: location'
    subject.stub! :assert_required_present
    
    subject.feature_location.should == 'location'
  end  
    
  it 'should fail if feature location property could not be found' do
    File.stub!(:exist?).and_return true
    IO.stub! :read
    YAML.stub!(:load).and_return({'feature_directory' => ''})
    
    lambda{ subject.feature_location }.should raise_error(RuntimeError, 'Required property feature_location not found in pickle.yml')
  end
  
  it 'should fail if feature directory property could not be found' do
    File.stub!(:exist?).and_return true
    IO.stub! :read
    YAML.stub!(:load).and_return({'feature_location' => ''})
    
    lambda{ subject.feature_directory }.should raise_error(RuntimeError, 'Required property feature_directory not found in pickle.yml')
  end
  
  it 'should return the output stream it was created with' do
    subject.output_stream.should == @output_stream
  end  
end