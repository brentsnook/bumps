$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'cucumber'

[
  'xml_remote_feature',
  'feature',
  'configuration',
  'results_push_formatter',
  'cucumber_config'
].each {|file| require "bumps/#{file}"}

module Bumps
  
  VERSION = '0.0.4'
  
  def self.configure &block
    Configuration.configure(&block)
  end
end