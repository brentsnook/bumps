require File.dirname(__FILE__) + '/../spec_helper.rb'
require 'json'
require 'time'
require 'cucumber/cli/main'

describe Bumps::JSONFormatter do
  
  FEATURES_DIR = File.expand_path File.join(File.dirname(__FILE__), '..', '..', 'test_features', 'json_formatter_spec')
    
  before(:all) { run_cucumber }
    
  it 'includes all features mapped by id' do
    [
      'describing_a_feature',
      'describing_a_scenario',
      'describing_a_step',
      'propagating_status_from_step_to_scenario'
    ].each do |id|
      @all_features.keys.should include(id)
    end 
  end
  
  describe 'propagating status from step to scenario' do
    before(:all) do
      @scenarios = @all_features['propagating_status_from_step_to_scenario']['scenarios']
    end
    
    it 'propagates passed, failed, pending and undefined statuses' do
      ['passed', 'failed', 'pending', 'undefined'].each_with_index do |status, index|
        @scenarios[index]['status'].should == status
      end 
    end
    
    it "doesn't propagate a skipped status" do
      @scenarios.last['status'].should == 'failed'
    end
  end
  
  describe 'describing a feature' do
    
    before(:all) do
      @feature = @all_features['describing_a_feature']
    end
    
    it 'includes version' do
      @feature['version'].should == '456' 
    end
    
    describe 'timing' do
      
      before(:all) do
        start = Time.now
        finish = start + 10
        Bumps::JSONFormatter.stub!(:now).and_return start, finish

        run_cucumber
        
        @feature = @all_features['describing_a_feature']  
      end
      
      it 'includes the time it started and stopped running in ISO8601 format' do
        iso8601_format = /[\d]{4}-[\d]{2}-[\d]{2}T[\d]{2}:[\d]{2}:[\d]{2}[+-][\d]{2}:[\d]{2}/
        @feature['started'].should match(iso8601_format)
        @feature['finished'].should match(iso8601_format)
      end
      
      it 'should include a finish time equal or greater than the start time' do
        # may be equal due to second only precision
        Time.parse(@feature['started']).should be <= Time.parse(@feature['finished'])
      end
    end
    
    it 'includes all scenarios' do
      @feature['scenarios'].size.should == 3
    end
  end
  
  describe 'describing a scenario' do
    
    before(:all) do
      @scenario = @all_features['describing_a_scenario']['scenarios'].first
    end
    
    it 'includes the line that it starts on (ignoring the first tag)' do
      @scenario['line'] = 3
    end
    
    it 'includes all steps' do
      @scenario['steps'].size == 3
    end
    
  end
  
  describe 'describing a step' do
    
    before(:all) do
      @step = @all_features['describing_a_step']['scenarios'].first['steps'].first
    end
    
    it 'includes the line (ignoring the first tag)' do
      @step['line'].should == 4
    end
    
    it 'includes the status' do
      @step['status'].should == 'undefined'  
    end
    
  end
  
  def run_cucumber
    args = ['-f', 'Bumps::JSONFormatter', FEATURES_DIR]
    output = `cucumber #{args.join(' ')}`
    @all_features = JSON.parse(output)['features']
  end
  
end