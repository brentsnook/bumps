require File.dirname(__FILE__) + '/../spec_helper.rb'
require 'json'

describe Bumps::RemoteFeature do
  
  subject {Bumps::RemoteFeature}
  
  describe 'fetch' do
    it 'uses the given location' do
      subject.should_receive(:open).with('location')
      subject.stub! :parse
      
      subject.fetch 'location'
    end
    
    it 'parses the given document to obtain features' do
      subject.stub!(:open).and_return 'document'
      
      subject.should_receive(:parse).with 'document'
      
      subject.fetch ''
    end  
  end
  
  describe 'parse' do
    it 'reads all features' do
      features = (0..1).collect do |idx|
        Bumps::Feature.new("feature #{idx}", "I am the content for feature #{idx}")
      end
      
      document = {
        "features" => {
          "0" => {
            "content" => "I am the content for feature 0", 
            "version" => "3",
            "name" => "feature 0"
          },
          "1" => {
            "content" => "I am the content for feature 1", 
            "version" => "3",
            "name" => "feature 1"
          },
        }
      }

      subject.parse(json_from(document)).should eql(features)
    end
    
    it 'reads all content for a single feature'
    it 'embeds metadata about a feature'
    
    def json_from document
      JSON.generate document
    end
  end
end