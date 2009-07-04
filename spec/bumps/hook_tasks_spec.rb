require File.dirname(__FILE__) + '/../spec_helper.rb'

class Target
  
  def out_stream= out
    @out_stream = out
  end
  
end

describe Bumps::HookTasks::SetFeatureDirectoryTask do

  before do
    @target = Target.new
  end

  subject {Bumps::HookTasks::SetFeatureDirectoryTask}

  it 'should set directory in the bumps configuration' do
    cukes_config = mock 'cukes_config' 
    @target.stub!(:configuration).and_return cukes_config
    cukes_config.stub!(:feature_dirs).and_return ['feature_directory']

    Bumps::Configuration.should_receive(:feature_directory=).with 'feature_directory'

    @target.instance_eval &subject
  end

  it 'should fail if there is more than one feature directory specified' do
    cukes_config = mock 'cukes_config' 
    @target.stub!(:configuration).and_return cukes_config
    cukes_config.stub!(:feature_dirs).and_return ['one', 'two']

    lambda{ @target.instance_eval &subject }.should raise_error('More than one feature directory/file was specified. Please only specify a single feature directory when using bumps')
  end
end

describe Bumps::HookTasks::PullFeaturesTask do

  before do
    @target = Target.new
  end

  subject {Bumps::HookTasks::PullFeaturesTask}

  it 'should pull features' do
    Bumps::Feature.should_receive :pull
  
    @target.instance_eval &subject
  end
end  
  
describe Bumps::HookTasks::RegisterPushFormatterTask do

  before do
    @output_stream = mock 'output stream'
    @target = Target.new
    
    # law of demeter seems like an even better idea after mocking a chain of three objects
    @formats = mock 'formats'
    options = mock 'options'
    options.stub!(:[]).with(:formats).and_return @formats
    @target.stub!(:configuration).and_return mock('cukes_config', :options => options)
  end

  subject {Bumps::HookTasks::RegisterPushFormatterTask}

  it 'should add the class name of the push formatter to the cucumber configuration' do
    @formats.should_receive(:[]=).with('Bumps::ResultsPushFormatter', anything)
          
    @target.instance_eval &subject
  end
      
  it 'should use the configured output stream for output' do
    Bumps::Configuration.stub!(:output_stream).and_return @output_stream

    @formats.should_receive(:[]=).with(anything, @output_stream)
          
    @target.instance_eval &subject
  end
end

describe Bumps::HookTasks::SetOutputStreamTask do

  before do
    @out_stream = mock 'out stream'
    @target = Target.new
    @target.out_stream = @out_stream
  end

  subject {Bumps::HookTasks::SetOutputStreamTask}

  it 'should use target class output stream' do
    Bumps::Configuration.should_receive(:output_stream=).with @out_stream
          
    @target.instance_eval &subject
  end
end