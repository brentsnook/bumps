require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Pickle::Feature, 'when pulling' do

  before do
    @configuration = mock 'configuration'
  end

  it 'should write fetched features to the feature directory' do
    @configuration.stub!(:feature_directory).and_return 'feature_directory'
    @configuration.stub!(:feature_location).and_return 'location'
  
    feature = mock 'feature' 
    Pickle::Feature.stub!(:fetch).with('location').and_return feature 
    @configuration.stub!(:feature_directory).and_return 'feature_directory'

    feature.should_receive(:write_to).with 'feature_directory'
  
    Pickle::Feature.pull @configuration
  end 
end  

describe Pickle::Feature, 'when writing self to file' do
  
  before do
    @file = mock 'file', :null_object => true
  end  
  
  it 'should construct file name from expanded directory and feature name' do
    subject.stub!(:name).and_return 'name'
    File.stub!(:expand_path).with('directory/path', 'name').and_return 'expanded path'
    File.should_receive(:new).with('expanded path', anything).and_return @file
    
    subject.write_to 'directory/path'
  end
  
  it 'should overwrite existing files' do
    File.should_receive(:new).with(anything, 'w').and_return @file
    
    subject.write_to ''
  end

  it 'should first force creation of feature file path'
  
  it 'should write content to file' do
    File.stub!(:new).and_return @file
    subject.stub!(:content).and_return 'content'
    
    @file.should_receive(:write).with 'content' 
    
    subject.write_to ''
  end
end  

describe Pickle::Feature, 'when fetching' do
  it 'should retrieve the document from the given location' do
    
  end  
  
  it 'should parse the document'
  
  it 'should fail if the document could not be retrieved'
end
