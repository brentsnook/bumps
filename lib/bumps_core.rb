$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'cucumber'

[
  'remote_feature',
  'feature',
  'configuration',
  'json_formatter',
  'results_push_formatter',
  'cucumber_config'
].each {|file| require "bumps/#{file}"}

module Bumps
  
  VERSION = '0.1.1'
  
  def self.configure &block
    Configuration.configure(&block)
  end
end