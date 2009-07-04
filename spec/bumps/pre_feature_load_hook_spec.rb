require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Bumps::PreFeatureLoadHook, 'when registered on a class' do
  
  before do
    class Clazz
      def load_plain_text_features;end
      def configuration;end  
    end
    
    Bumps::PreFeatureLoadHook.register_on Clazz
    
    @instance = Clazz.new
  end
  
  it 'should run all tasks within the context of that class' do
    FirstTask = lambda {first_method}
    SecondTask = lambda {second_method}
    Bumps::PreFeatureLoadHook.stub!(:tasks).and_return [FirstTask, SecondTask]
    
    @instance.should_receive :first_method
    @instance.should_receive :second_method
    
    @instance.load_plain_text_features
  end
  
  it 'should call the original method after running tasks' do
    Bumps::PreFeatureLoadHook.stub!(:tasks).and_return []
    
    @instance.should_receive :original_load_plain_text_features
    
    @instance.load_plain_text_features
  end
  
  it 'should complete tasks in correct order' do
    # how can this be better expressed with an example?
    Bumps::PreFeatureLoadHook.tasks.should == [
      Bumps::HookTasks::SetFeatureDirectoryTask,
      Bumps::HookTasks::SetOutputStreamTask,
      Bumps::HookTasks::PullFeaturesTask,
      Bumps::HookTasks::RegisterPushFormatterTask
    ]
  end
end