require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Bumps::CucumberConfig do
  before do
    @source_config = mock('source Cucumber config')
    @config = Bumps::CucumberConfig.new @source_config
  end
  
  describe 'processing' do

    it 'validates cucumber configuration, updates Bumps config then registers formatter' do
      @config.should_receive(:validate).ordered
      @config.should_receive(:update_bumps_config).ordered
      @config.should_receive(:register_formatter).ordered
    
      @config.process!
    end
  
  end
  
  describe 'validation' do
    
    it 'passes when a single directory is specified' do
      @source_config.stub!(:feature_dirs).and_return ['one']

      lambda{ @config.validate }.should_not raise_error
    end
    
    it 'fails when there is more than one feature directory specified' do
      @source_config.stub!(:feature_dirs).and_return ['one', 'two']

      lambda{ @config.validate }.should raise_error('More than one feature directory/file was specified. Please only specify a single feature directory when using bumps')
    end
    
  end
  
  describe 'update' do
    
    it 'uses fields from source Cucumber config' do
      @source_config.stub!(:feature_dirs).and_return ['dir']
      @source_config.stub!(:out_stream).and_return 'out stream'
      
      Bumps::Configuration.should_receive(:output_stream=).with 'out stream'
      Bumps::Configuration.should_receive(:feature_directory=).with 'dir' 
      
      @config.update_bumps_config   
    end
    
  end
  
  describe 'registering a formatter' do
    
    before do
      # law of demeter seems like an even better idea after mocking a chain of three objects
      @formats = mock 'formats'
      options = mock 'options'
      options.stub!(:[]).with(:formats).and_return @formats
      @source_config.stub!(:options).and_return options
    end
    
    it 'adds the class name of the push formatter to the Cucumber configuration' do
      @formats.should_receive(:<<).with ['Bumps::ResultsPushFormatter', anything]

      @config.register_formatter
    end
    
    it 'uses the configured output stream to write messages' do
      output_stream = mock 'output stream'
      Bumps::Configuration.stub!(:output_stream).and_return output_stream

      @formats.should_receive(:<<).with [anything, output_stream]

      @config.register_formatter
    end
  end
  
end