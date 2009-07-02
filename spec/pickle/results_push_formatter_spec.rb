require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Pickle::ResultsPushFormatter do
  
  before do
    @step_mother = mock 'step_mother'
    @io = mock 'io'
    @captured_io = mock 'captured io', :null_object => true
    StringIO.stub!(:new).and_return @captured_io
    @options = mock 'options'
    
    @wrapped_formatter = mock 'wrapped formatter', :null_object => true
  end
  
  def stub_wrapped_formatter
    Cucumber::Formatter::Html.stub!(:new).and_return @wrapped_formatter
  end
  
  subject do
    Pickle::ResultsPushFormatter.new(
      @step_mother,
      @io,
      @options
    )
  end
  
  it 'should use a new HTML formatter as the wrapped formatter' do
    Cucumber::Formatter::Html.should_receive(:new).with(
      @step_mother, anything, @options
    ).and_return mock('formatter', :null_object => true)
    
    subject.visit_features mock('features')
  end
  
  it 'should capture io of wrapped formatter' do
    Cucumber::Formatter::Html.should_receive(:new).with(
      anything, @captured_io, anything
    ).and_return mock('formatter', :null_object => true)
    
    subject.visit_features mock('features')
  end
  
  it 'should visit features using wrapped formatter' do
    stub_wrapped_formatter
    features = mock 'features', :accept => nil
    
    @wrapped_formatter.should_receive(:visit_features).with features
    
    subject.visit_features features
  end
  
  it 'should close captured output stream after visiting features' do
    stub_wrapped_formatter
    
    @captured_io.should_receive :close
    
    subject.visit_features mock('features')
  end
  
  it 'should submit output of wrapped formatter after features are visited'
  
  it 'should output a success message if results were pushed successfully'
  
  it 'should output a failure message if results could not be pushed'
  
end