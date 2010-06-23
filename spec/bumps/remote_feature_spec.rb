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
    
    it 'reads the name of a feature' do
      document = { "features" => {
        "" => {
          "content" => "Feature: do stuff", 
          "version" => "",
          "name" => "Feature name"
        }
      }}

      subject.parse(json_from(document)).first.name.should == 'Feature name'
    end
    
    it 'reads the content of a feature' do
      document = { "features" => {
        "" => {
          "content" => "Feature: do stuff", 
          "version" => "",
          "name" => "feature 0"
        }
      }}

      subject.parse(json_from(document)).first.content.should match(/Feature: do stuff/)
    end
    
    it 'reads all features' do      
      document = { "features" => {
        "0" => {
          "content" => "Feature: 0\nI am the content for feature 0", 
          "version" => "3",
          "name" => "feature 0"
        },
        "1" => {
          "content" => "Feature: 1\nI am the content for feature 1", 
          "version" => "3",
          "name" => "feature 1"
        }
      }}

      subject.parse(json_from(document)).size.should == 2
    end
    
    it 'returns an empty list when no features are found' do
      subject.parse(json_from({ "features" => {}})).size.should == 0          
    end
 
    it 'embeds metadata about a feature within its content' do
      document = { "features" => {
        "123" => {
          "content" => "Feature: do stuff", 
          "version" => "3",
          "name" => "feature 0"
        }
      }}

      subject.parse(json_from(document)).first.content.should == "@id:123 @version:3\nFeature: do stuff"
    end

    def json_from document
      JSON.generate document
    end
  end
end