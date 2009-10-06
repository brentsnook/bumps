require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Bumps::ResultsPushFormatter do
  
  before do
    @step_mother = mock 'step_mother'
    @io = mock('io').as_null_object
    @options = mock 'options'
    
    @features = mock('features').as_null_object
  end
  
  subject do
    Bumps::ResultsPushFormatter.new(
      @step_mother,
      @io,
      @options
    )
  end
  
  describe 'when capturing results' do
 
    before do
      @formatter_class = mock 'formatter class'
      @formatter = mock('formatter').as_null_object
      Bumps::Configuration.stub!(:results_formatter).and_return @formatter_class
    end
    
    describe 'responding to events' do
      
      before do
        @formatter_class.stub!(:new).and_return @formatter
        Bumps::Configuration.stub!(:results_formatter).and_return @formatter_class
      end
      
      it 'should recognise events that the wrapped formatter handles' do
        @formatter.stub!(:respond_to?).with('event', anything).and_return true
       
        subject.before_features @features
        subject.respond_to?('event').should == true
      end
      
      it 'should recognise events that it handles on its own' do
        @formatter.stub!(:respond_to?).with('after_features', anything).and_return false
    
        subject.before_features @features
        subject.respond_to?('after_features').should == true
      end
    end
       
    describe 'before the running of features' do
      
      it 'should construct the wrapped formatter using the step mother' do
        @formatter_class.should_receive(:new).with(
          @step_mother, anything, anything
        ).and_return @formatter

        subject.before_features @features
      end   
      
      it 'should construct the wrapped formatter using the options' do
        @formatter_class.should_receive(:new).with(
          anything, anything, @options
        ).and_return @formatter

        subject.before_features @features
      end
      
      it 'should obtain the results formatter from the configuration' do
        @formatter_class.stub!(:new).and_return @formatter

        Bumps::Configuration.should_receive(:results_formatter).and_return @formatter_class

        subject.before_features @features
      end
      
      it 'should notify the wrapped formatter of the before_features event' do
        Bumps::Configuration.stub!(:results_formatter).and_return @formatter_class
        @formatter_class.stub!(:new).and_return @formatter

        @formatter.should_receive(:before_features).with @features

        subject.before_features @features
      end
         
    end
    
    describe 'during the running of features' do

      it 'should notify the wrapped formatter of all events' do
        @formatter_class.stub!(:new).and_return @formatter
        Bumps::Configuration.stub!(:results_formatter).and_return @formatter_class
        events = [
          :before_feature, :after_feature, :before_comment, :after_comment,
          :comment_line, :after_tags, :before_background, :after_background,
          # there are more, add as needed
        ]
        
        events.each { |event| @formatter.should_receive(event).with('arguments')}
     
        subject.before_features @features
        events.each { |event| subject.send(event, 'arguments')}
      end
      
    end
    
    describe 'after the running of features' do
      before do
        @results = mock('results').as_null_object
        subject.stub!(:results).and_return @results
        subject.stub!(:formatter).and_return @formatter
        subject.stub!(:push)
      end
    
      it 'should notify the wrapped formatter after all features have been run' do
        @formatter.should_receive(:after_features).with @features
      
        subject.after_features @features
      end
    
      it 'should ready the captured results for pushing' do     
        @results.should_receive :close
      
        subject.after_features @features  
      end
    end
    
    describe 'over the entire run' do
      it 'should capture then push results' do
        class FormatterTestDouble
          def initialize(step_mother, io, options)
            @io = io
          end
          
          def before_features features
          end
          
          def after_features features
          end

          def after_feature feature
            @io << "After feature: #{feature}"
          end
        end
        Bumps::Configuration.stub(:results_formatter).and_return FormatterTestDouble

        subject.should_receive(:push).with 'After feature: walk the dog' 

        subject.before_features @features
        subject.after_feature 'walk the dog'
        subject.after_features @features
      end
    end
  end
  
  describe 'when pushing results' do
    
    before do
      @response = mock 'response'
      @response.stub!(:code_type).and_return Net::HTTPOK
      @push_url = 'http://push.com'
      Bumps::Configuration.stub!(:push_url).and_return @push_url
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
      
      @io.should_receive(:<<).with "Successfully pushed results to #{@push_url}\n"
      
      subject.push 'results'
    end
  
    it "should output a failure message if push server doesn't respond with OK" do
      @response.stub!(:code_type).and_return Net::HTTPInternalServerError
      @response.stub!(:code).and_return 500
      @response.stub!(:body).and_return 'response body'

      Net::HTTP.stub!(:post_form).and_return @response, ''
    
      @io.should_receive(:<<).with "Failed to push results to #{@push_url} - HTTP 500: \nresponse body\n"
    
      subject.push 'results'
    end
    
    it "should output a failure message if request to push server fails" do
      Net::HTTP.stub!(:post_form).and_raise 'exception message'
    
      @io.should_receive(:<<).with "Failed to push results to #{@push_url} - exception message\n"
    
      subject.push 'results'
    end
  end
end
