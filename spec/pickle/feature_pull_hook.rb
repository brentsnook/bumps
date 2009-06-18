require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Pickle::FeaturePullHook, 'when registered on a class' do
  it 'should override the :load_plain_text_features method to perform a feature pull'
  it 'should call the original method after pulling features'
  it 'should register the feature directory with the configuration'
  it 'should fail if there is more than one feature directory specified'
end