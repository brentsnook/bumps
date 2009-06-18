$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'cucumber'

[
  'remote_feature',
  'feature',
  'configuration',
  'feature_pull_hook'
].each {|file| require "pickle/#{file}"}

module Pickle
  
  VERSION = '0.0.1'
  LOWEST_SUPPORTED_CUCUMBER_VERSION = '0.3.11'
  
  def self.configure &block
    configuration = Configuration.new STDOUT
    configuration.configure &block
  
    Pickle::FeaturePullHook.create Cucumber::Cli::Main, configuration
  end
  
  def self.add_feature_pull_hook_to clazz, configuration
    raise 'implement me'
  end  
end