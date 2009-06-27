require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Pickle::PreFeatureLoadHook, 'when registered on a class' do
  
  before do
    class Clazz
      def load_plain_text_features;end
      def configuration;end  
    end
    
    Pickle::PreFeatureLoadHook.register_on Clazz
    
    @instance = Clazz.new
  end
  
  it 'should run all tasks within the context of that class' do
    FirstTask = lambda {first_method}
    SecondTask = lambda {second_method}
    Pickle::PreFeatureLoadHook.stub!(:tasks).and_return [FirstTask, SecondTask]
    
    @instance.should_receive :first_method
    @instance.should_receive :second_method
    
    @instance.load_plain_text_features
  end
  
  it 'should call the original method after running tasks' do
    Pickle::PreFeatureLoadHook.stub!(:tasks).and_return []
    
    @instance.should_receive :original_load_plain_text_features
    
    @instance.load_plain_text_features
  end
  
  it 'should complete tasks in correct order' do
    # how can this be better expressed with an example?
    Pickle::PreFeatureLoadHook.tasks.should == [
      Pickle::HookTasks::SetFeatureDirectoryTask,
      Pickle::HookTasks::PullFeaturesTask,
      Pickle::HookTasks::RegisterPushFormatterTask
    ]
  end
end