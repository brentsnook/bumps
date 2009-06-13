require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Pickle::Feature do
  describe 'when pulling' do

    subject {Pickle::Feature}
    
    before do
      @configuration = mock 'configuration', :null_object => true
    end

    it 'should write fetched features to the feature directory' do
      @configuration.stub!(:feature_directory).and_return 'feature_directory'
      @configuration.stub!(:feature_location).and_return 'location'
  
      features = 3.times.collect do |index|
        feature = mock "feature #{index}"
        feature.should_receive(:write_to).with 'feature_directory'
        feature  
      end
     
      Pickle::RemoteFeature.stub!(:fetch).with('location').and_return features 
    
      @configuration.stub!(:feature_directory).and_return 'feature_directory'

      subject.pull @configuration
    end 
    
    it 'should display which location the features are being retrieved from' do
      Pickle::RemoteFeature.stub!(:fetch).and_return []
      output = mock 'output', :null_object => true
      @configuration.stub!(:feature_location).and_return 'feature_location'
      @configuration.stub!(:output_stream).and_return output
      
      output.should_receive(:<<).with "\nRetrieving features from feature_location ...\n"
      
      subject.pull @configuration
    end  
    
    it 'should display the total number of features retrieved and location they were written to' do
      features = 3.times.collect{|index| mock("feature #{index}", :null_object => true)}
      Pickle::RemoteFeature.stub!(:fetch).and_return features
      output = mock 'output', :null_object => true
      @configuration.stub!(:feature_directory).and_return 'feature_directory'
      @configuration.stub!(:output_stream).and_return output
      
      output.should_receive(:<<).with "Wrote 3 features to feature_directory\n\n"
      
      subject.pull @configuration
    end
  end

  describe 'when writing self to file' do
  
    before do
      @file = mock 'file', :null_object => true
    end  
  
    it 'should construct file name from expanded directory and feature name' do
      subject.stub!(:name).and_return 'name'
      File.stub!(:expand_path).with('directory/path/name').and_return 'expanded path'
      File.should_receive(:new).with('expanded path', anything).and_return @file
    
      subject.write_to 'directory/path'
    end
  
    it 'should overwrite existing files' do
      FileUtils.stub! :makedirs
      
      File.should_receive(:new).with(anything, 'w').and_return @file
     
      subject.write_to ''
    end
    
    it 'should force the creation of directories in the feature name' do
      File.stub!(:expand_path).and_return 'features_dir/subdir/featurename.feature'
      File.stub(:new).and_return mock('file', :null_object => true)
      
      FileUtils.should_receive(:makedirs).with 'features_dir/subdir'
      
      subject.write_to ''
    end
  
    it 'should write content to file' do
      FileUtils.stub! :makedirs
      File.stub!(:new).and_return @file
      subject.stub!(:content).and_return 'content'
    
      @file.should_receive(:write).with 'content' 
    
      subject.write_to ''
    end
    
  end
end