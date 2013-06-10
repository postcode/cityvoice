require 'spec_helper'

describe "V&A SMS App" do

  def twilio_body_from(response)
    parsed_response_body = Nokogiri::XML(response.body)
    returned_text = parsed_response_body.xpath('//Response/Sms').text
  end

  before(:each) do
    @property_number = "1234"
    @property_address = "1234 Lincoln Way West"
    @choice_code = "D"
    @choice_text = "Demolish"
    @success_message = "Thanks! We recorded your response '#{@choice_text}' for #{@property_address}. Reply with your comments and visit 1000in1000.com/#{@property_number} to learn more." 
    @successful_comment_message = "Thanks for your comment! City staff will review your feedback. Please tell your neighbors about this program."
    @fail1_message = "Sorry, we didn't understand your response. Please text back one of the exact choices on the sign, like '1234O' or '1234R'."
    @fail2_message = "We're very sorry, but we still don't understand your response. Please visit 1000in1000.com or call 123-456-7890 to submit your feedback."
  end

  it "responds to good input with success message" do
    post 'vacant', :Body => "#{@property_number+@choice_code}"
    twilio_body_from(response).should eq(@success_message)
  end

  it "responds to lower-case code input with success message" do
    post 'vacant', :Body => "#{@property_number}d"
    twilio_body_from(response).should eq(@success_message)
  end

  it "responds to '0' code input with success message" do
    post 'vacant', :Body => "#{@property_number}0"
    @success_message = "Thanks! We recorded your response 'Other' for #{@property_address}. Reply with your comments and visit 1000in1000.com/#{@property_number} to learn more." 
    twilio_body_from(response).should eq(@success_message)
  end

  it "responds to comment with successful comment message" do
    post 'vacant', :Body => "#{@property_number+@choice_code}"
    twilio_body_from(response).should eq(@success_message)
    post 'vacant', :Body => "tear down this wall"
    twilio_body_from(response).should eq(@successful_comment_message)
  end

  it "correctly deals with wrong-then-correct" do
    # Still need to refine language
    post '/vacant', Body: @property_number
    twilio_body_from(response).should eq(@fail1_message)
    post '/vacant', Body: "#{@property_number+@choice_code}"
    twilio_body_from(response).should eq(@success_message)
  end

  it "correctly deals with wrong-then-wrong" do
    post '/vacant', Body: "wat"
    twilio_body_from(response).should eq(@fail1_message)
    post '/vacant', Body: "WAT"
    twilio_body_from(response).should eq(@fail2_message)
  end

end
