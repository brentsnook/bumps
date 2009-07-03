require File.dirname(__FILE__) + '/../spec_helper.rb'

class Target
  
  def out_stream= out
    @out_stream = out
  end
  
end

describe Pickle::HookTasks::SetFeatureDirectoryTask do

  before do
    @target = Target.new
  end

  subject {Pickle::HookTasks::SetFeatureDirectoryTask}

  it 'should set directory in the pickle configuration' do
    cukes_config = mock 'cukes_config' 
    @target.stub!(:configuration).and_return cukes_config
    cukes_config.stub!(:feature_dirs).and_return ['feature_directory']

    Pickle::Configuration.should_receive(:feature_directory=).with 'feature_directory'

    @target.instance_eval &subject
  end

  it 'should fail if there is more than one feature directory specified' do
    cukes_config = mock 'cukes_config' 
    @target.stub!(:configuration).and_return cukes_config
    cukes_config.stub!(:feature_dirs).and_return ['one', 'two']

    lambda{ @target.instance_eval &subject }.should raise_error('More than one feature directory/file was specified. Please only specify a single feature directory when using pickle')
  end
end

describe Pickle::HookTasks::PullFeaturesTask do

  before do
    @target = Target.new
  end

  subject {Pickle::HookTasks::PullFeaturesTask}

  it 'should pull features' do
    Pickle::Feature.should_receive :pull
  
    @target.instance_eval &subject
  end
end  
  
describe Pickle::HookTasks::RegisterPushFormatterTask do

  before do
    @out_stream = mock 'out stream'
    @target = Target.new
    @target.out_stream = @out_stream
    
    # law of demeter seems like an even better idea after mocking a chain of three objects
    @formats = mock 'formats'
    options = mock 'options'
    options.stub!(:[]).with(:formats).and_return @formats
    @target.stub!(:configuration).and_return mock('cukes_config', :options => options)
  end

  subject {Pickle::HookTasks::RegisterPushFormatterTask}

  it 'should add the class name of the push formatter to the cucumber configuration' do
    @formats.stub!(:values).and_return []
    
    @formats.should_receive(:[]=).with('Pickle::ResultsPushFormatter', anything)
          
    @target.instance_eval &subject
  end
      
  it 'should use the main output stream member for output' do
    # this is also stomping over encapsulation but the member isn't otherwise available
    
    output = mock 'output'
    @formats.stub!(:values).and_return [output, '']
  
    @formats.should_receive(:[]=).with(anything, @out_stream)
          
    @target.instance_eval &subject
  end
end

describe Pickle::HookTasks::SetOutputStreamTask do

  before do
    @out_stream = mock 'out stream'
    @target = Target.new
    @target.out_stream = @out_stream
  end

  subject {Pickle::HookTasks::SetOutputStreamTask}

  it 'should use target class output stream' do
    Pickle::Configuration.should_receive(:output_stream=).with @out_stream
          
    @target.instance_eval &subject
  end
end