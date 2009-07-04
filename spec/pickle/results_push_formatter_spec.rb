require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Pickle::ResultsPushFormatter do
  
  before do
    @step_mother = mock 'step_mother'
    @io = mock('io').as_null_object
    @options = mock 'options'
    
    @features = mock('features').as_null_object
  end
  
  subject do
    Pickle::ResultsPushFormatter.new(
      @step_mother,
      @io,
      @options
    )
  end
  
  it 'should capture results before pushing them' do
    results = mock 'results'
    
    subject.should_receive(:results_of_running).with(@features).and_return results
    subject.should_receive(:push).with results
    
    subject.visit_features @features
  end
  
  describe 'when capturing results' do
    
    before do
      @formatter_class = mock 'formatter class'
      Pickle::Configuration.stub!(:results_formatter).and_return @formatter_class
    end
    
    it 'should obtain the results formatter from the configuration' do
      @formatter_class.stub!(:new).and_return mock('formatter').as_null_object 
      
      Pickle::Configuration.should_receive(:results_formatter).and_return @formatter_class
      
      subject.results_of_running @features
    end
 
    it 'should construct the wrapped formatter using the step mother' do
      @formatter_class.should_receive(:new).with(
        @step_mother, anything, anything
      ).and_return mock('formatter').as_null_object
 
      subject.results_of_running @features
    end
    
    it 'should construct the wrapped formatter using the options' do
      @formatter_class.should_receive(:new).with(
        anything, anything, @options
      ).and_return mock('formatter').as_null_object
 
      subject.results_of_running @features
    end
    
    it 'should return results of visiting features with wrapped formatter' do
      
      class FormatterTestDouble  
        def initialize io
          @io = io
        end
        
        def visit_features features
          @io << 'results'
        end
      end
      
      @formatter_class.stub!(:new) do |step_mother, io, options|
        FormatterTestDouble.new(io)
      end
      
      subject.results_of_running(@features).should =='results'
    end

  end
  
  describe 'when pushing results' do
    
    before do
      @response = mock 'response'
      @response.stub!(:code_type).and_return Net::HTTPOK
      @push_url = 'http://push.com'
      Pickle::Configuration.stub!(:push_url).and_return @push_url
    end
  
    it 'should post results to configured push URL' do
      parsed_uri = mock 'parsed uri'
      URI.stub!(:parse).with(@push_url).and_return parsed_uri
      
      Net::HTTP.should_receive(:post_form).with(parsed_uri, anything).and_return([@response, ''])
      
      subject.push 'results'
    end
    
    it 'should send captured results in request' do
      Net::HTTP.should_receive(:post_form).with(anything, {:results => 'results'}).and_return([@response, ''])
      
      subject.push 'results'
    end
  
    it 'should output a success message if results were pushed successfully' do
      Net::HTTP.stub!(:post_form).and_return @response, ''
      
      @io.should_receive(:<<).with "Successfully pushed results to #{@push_url}\n\n"
      
      subject.push 'results'
    end
  
    it 'should output a failure message if results could not be pushed' do
      @response.stub!(:code_type).and_return Net::HTTPInternalServerError
      @response.stub!(:code).and_return 500
      @response.stub!(:body).and_return 'response body'

      Net::HTTP.stub!(:post_form).and_return @response, ''
    
      @io.should_receive(:<<).with "Failed to push results to #{@push_url} - HTTP 500: \nresponse body\n\n"
    
      subject.push 'results'
    end
  end
end
