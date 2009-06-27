require File.dirname(__FILE__) + '/../spec_helper.rb'

class Target
  
  def run task
    instance_eval &(task.block)
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

    @target.run subject
  end

  it 'should fail if there is more than one feature directory specified' do
    cukes_config = mock 'cukes_config' 
    @target.stub!(:configuration).and_return cukes_config
    cukes_config.stub!(:feature_dirs).and_return ['one', 'two']

    lambda{ @target.run subject }.should raise_error('More than one feature directory/file was specified. Please only specify a single feature directory when using pickle')
  end
end

describe Pickle::HookTasks::PullFeaturesTask do

  before do
    @target = Target.new
  end

  subject {Pickle::HookTasks::PullFeaturesTask}

  before do
    @target = Target.new
  end

  it 'should pull features' do
    Pickle::Feature.should_receive :pull
  
    @target.run subject
  end
end  
  
describe Pickle::HookTasks::RegisterPushFormatterTask do

  before do
    @target = Target.new
    
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
          
    @target.run subject
  end
      
  it 'should use the output stream of the first existing formatter' do
    output = mock 'output'
    @formats.stub!(:values).and_return [output, '']
  
    @formats.should_receive(:[]=).with(anything, output)
          
    @target.run subject
  end
end