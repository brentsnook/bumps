$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Pickle
  VERSION = '0.0.1'
  LOWEST_SUPPORTED_CUCUMBER_VERSION = '0.3.11'
end

require 'rubygems'

[
  'remote_feature',
  'feature',
  'configuration'
].each {|file| require "pickle/#{file}"}