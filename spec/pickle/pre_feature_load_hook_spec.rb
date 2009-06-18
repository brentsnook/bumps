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
  
  it 'should override the :load_plain_text_features method to perform a feature pull' do
    @instance.stub! :register_pickle_feature_directory
    Pickle::Feature.should_receive :pull
    
    @instance.load_plain_text_features
  end
  
  it 'should call the original method after pulling features' do
    @instance.stub! :register_pickle_feature_directory
    Pickle::Feature.stub! :pull
    
    @instance.should_receive :original_load_plain_text_features
    
    @instance.load_plain_text_features
  end
  
  it 'should register the feature directory with pickle' do
    Pickle::Feature.stub! :pull
  
    @instance.should_receive :register_pickle_feature_directory
    
    @instance.load_plain_text_features
  end
  
  describe 'registering feature directory' do
    it 'should set it in the pickle configuration' do
      cukes_config = mock 'cukes_config' 
      @instance.stub!(:configuration).and_return cukes_config
      cukes_config.stub!(:feature_dirs).and_return ['feature_directory']
      Pickle::Feature.stub! :pull
    
      Pickle::Configuration.should_receive(:feature_directory=).with 'feature_directory'
    
      @instance.load_plain_text_features
    end
  
    it 'should fail if there is more than one feature directory specified' do
      cukes_config = mock 'cukes_config' 
      @instance.stub!(:configuration).and_return cukes_config
      cukes_config.stub!(:feature_dirs).and_return ['one', 'two']

      lambda{ @instance.register_pickle_feature_directory }.should raise_error('More than one feature directory/file was specified. Please only specify a single feature directory when using pickle')
    end
  end
end