require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Bumps::RemoteFeature do
  
  subject {Bumps::RemoteFeature}
  
  describe 'fetching' do
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
  
  describe 'parsing' do
    it 'extracts all features from XML' do
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
    
    it 'trims leading and trailing whitespace from content' do
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
    
    it 'returns an empty list when no features were found' do
      xml = <<-XML
<?xml version="1.0"?>
<features>
</features>
XML
      subject.parse(xml).should eql([])
    end

    it 'preserves CDATA in feature content' do
      xml = <<-XML
<?xml version="1.0"?>
<features>
  <feature name="feature 0">
    <![CDATA[content contains <b>CDATA</b> & it should be preserved]]>
  </feature>
</features>
XML
      
      subject.parse(xml).first.content.should match(%r{content contains <b>CDATA</b> & it should be preserved})
    end
         
  end
end