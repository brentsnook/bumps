require File.dirname(__FILE__) + '/spec_helper.rb'

# required for test of Cucumber hook
def AfterConfiguration &block
  block.call 'source config'
end

describe Bumps do
    
  describe 'execution of Cucumber AfterConfiguration hook' do

    it 'should process Cucumber config then perform a feature pull' do
      Bumps::CucumberConfig.stub!(:new).with('source config').and_return(cukes_config = mock('Cukes config'))
      cukes_config.should_receive(:process!).ordered
      Bumps::Feature.should_receive(:pull).ordered

      load File.expand_path(File.dirname(__FILE__) + '/../lib/bumps.rb')
    end

  end
    
  describe 'configuration' do

    it 'should configure the new configuration using the given directives' do

      # how can we specify that it should be passed a reference to a block?
      Bumps::Configuration.should_receive(:configure)
    
      Bumps.configure {}
    end

  end

end