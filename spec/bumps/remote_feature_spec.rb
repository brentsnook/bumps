require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Bumps::RemoteFeature do
  
  subject {Bumps::RemoteFeature}
  
  describe 'when fetching' do
    it 'should retrieve features from the given location' do
      subject.should_receive(:open).with('location')
      subject.stub! :parse
      
      subject.fetch 'location'
    end
    
    it 'should parse the given document to obtain features' do
      subject.stub!(:open).and_return 'document'
      
      subject.should_receive(:parse).with 'document'
      
      subject.fetch ''
    end  
  end
  
  describe 'when parsing' do
    it 'should extract all features from XML' do
      features = (0..1).collect do |idx|
        feature = Bumps::Feature.new
        feature.name = "feature #{idx}"
        feature.content = "I am the content for feature #{idx}"
        feature
      end
      
      xml = <<-XML
<?xml version="1.0"?>
<features>
  <feature name="feature 0">I am the content for feature 0</feature>
  <feature name="feature 1">I am the content for feature 1</feature>
</features>
XML

      subject.parse(xml).should eql(features)
    end 
    
    it 'should trim leading and trailing whitespace from content' do
      xml = <<-XML
<?xml version="1.0"?>
<features>
  <feature name="feature 0">
  
  
  I am the content for feature 0
  
  </feature>
</features>
XML

      subject.parse(xml).first.content.should == 'I am the content for feature 0'
    end  
    
    it 'should return an empty feature list when none were found' do
      xml = <<-XML
<?xml version="1.0"?>
<features>
</features>
XML
      subject.parse(xml).should eql([])
    end
 
  end
end