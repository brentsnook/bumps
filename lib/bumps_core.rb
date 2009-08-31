$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'cucumber'

[
  'remote_feature',
  'feature',
  'configuration',
  'results_push_formatter',
  'cucumber_config'
].each {|file| require "bumps/#{file}"}

module Bumps
  
  VERSION = '0.0.2'
  
  def self.configure &block
    Configuration.configure(&block)
  end
end