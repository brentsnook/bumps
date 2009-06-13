require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Pickle::Configuration do
  
  before {@output_stream = mock('output stream', :null_object => true)}
  subject {Pickle::Configuration.new @output_stream}
  
  describe 'when determining file' do
    it 'should use argument specified on command line' do
      ARGV.stub!(:[]).with(0).and_return 'someother.yml'
      File.stub!(:exist?).and_return true
  
      subject.file.should == 'someother.yml'
    end
  
    it 'should use pickle.yml when no command line argument specified' do
      ARGV.stub!(:[]).with(0)
      File.stub!(:exist?).and_return true
      
      subject.file.should == 'pickle.yml'
    end
    
    it 'should fail if file could not be found' do
      ARGV.stub!(:[]).with(0)
      File.stub!(:exist?).and_return false

      lambda{ subject.file }.should raise_error(RuntimeError, 'Pickle configuration file (pickle.yml) was not found')
    end
  end
  
  it 'should retrieve feature_location property' do
    File.stub!(:exist?).and_return true
    IO.stub!(:read).and_return 'feature_location: location'
    subject.stub! :assert_required_present
    
    subject.feature_location.should == 'location'
  end  
    
  it 'should fail if feature location property could not be found' do
    subject.stub!(:file).and_return 'file.yml'
    IO.stub! :read
    YAML.stub!(:load).and_return({'feature_directory' => ''})
    
    lambda{ subject.feature_location }.should raise_error(RuntimeError, 'Required property feature_location not found in file.yml')
  end
  
  it 'should fail if feature directory property could not be found' do
    subject.stub!(:file).and_return 'file.yml'
    IO.stub! :read
    YAML.stub!(:load).and_return({'feature_location' => ''})
    
    lambda{ subject.feature_directory }.should raise_error(RuntimeError, 'Required property feature_directory not found in file.yml')
  end
  
  it 'should return the output stream it was created with' do
    subject.output_stream.should == @output_stream
  end  
end