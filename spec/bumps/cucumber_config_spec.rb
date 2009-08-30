require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Bumps::CucumberConfig, 'processing' do
  before do
    @source_config = mock('source Cucumber config')
    @config = Bumps::CucumberConfig.new @source_config
  end
  
  describe 'processing' do

    it 'should validate cucumber configuration, update Bumps config then register formatter' do
      @config.should_receive(:validate).ordered
      @config.should_receive(:update_bumps_config).ordered
      @config.should_receive(:register_formatter).ordered
    
      @config.process!
    end
  
  end
  
  describe 'validation' do
    
    it 'should succeed if a single directory is specified' do
      @source_config.stub!(:feature_dirs).and_return ['one']

      lambda{ @config.validate }.should_not raise_error
    end
    
    it 'should fail if there is more than one feature directory specified' do
      @source_config.stub!(:feature_dirs).and_return ['one', 'two']

      lambda{ @config.validate }.should raise_error('More than one feature directory/file was specified. Please only specify a single feature directory when using bumps')
    end
    
  end
  
  describe 'updating Bumps configuration' do
    
    it 'should use fields from source Cucumber config' do
      @source_config.stub!(:feature_dirs).and_return ['dir']
      @source_config.stub!(:out_stream).and_return 'out stream'
      
      Bumps::Configuration.should_receive(:output_stream=).with 'out stream'
      Bumps::Configuration.should_receive(:feature_directory=).with 'dir' 
      
      @config.update_bumps_config   
    end
    
  end
  
  describe 'registering formatter' do
    
    before do
      # law of demeter seems like an even better idea after mocking a chain of three objects
      @formats = mock 'formats'
      options = mock 'options'
      options.stub!(:[]).with(:formats).and_return @formats
      @source_config.stub!(:options).and_return options
    end
    
    it 'should add the class name of the push formatter to the cucumber configuration' do
      @formats.should_receive(:[]=).with('Bumps::ResultsPushFormatter', anything)

      @config.register_formatter
    end
    
    it 'should use the configured output stream for output' do
      output_stream = mock 'output stream'
      Bumps::Configuration.stub!(:output_stream).and_return output_stream

      @formats.should_receive(:[]=).with(anything, output_stream)

      @config.register_formatter
    end
  end
  
end