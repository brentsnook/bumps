$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'cucumber'

[
  'remote_feature',
  'feature',
  'configuration',
  'pre_feature_load_hook'
].each {|file| require "pickle/#{file}"}

module Pickle
  
  VERSION = '0.0.1'
  LOWEST_SUPPORTED_CUCUMBER_VERSION = '0.3.11'
  
  def self.configure &block
    Configuration.configure(&block)
    PreFeatureLoadHook.register_on Cucumber::Cli::Main
  end
end