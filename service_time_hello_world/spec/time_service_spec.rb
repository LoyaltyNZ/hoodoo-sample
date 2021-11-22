require "rack/test"
require_relative '../time_service.rb'

class TimeService < Hoodoo::Services::Service
  comprised_of TimeInterface
end

describe 'Time Service' do
  include Rack::Test::Methods

  context "get /1/Time/now" do
    let(:app) {

      Rack::Builder.new do
        use( Hoodoo::Services::Middleware )
        run( TimeService.new )
      end
    }

    it "returns the status 200" do
      get "/1/Time/now",
          nil,
          { 'CONTENT_TYPE' => 'application/json; charset=utf-8' }
      expect(last_response.status).to eq 200
    end

    it "returns the correct time" do
      get "/1/Time/now",
          nil,
          { 'CONTENT_TYPE' => 'application/json; charset=utf-8' }
      # response JSON -> Hash
      parsed_body = JSON.parse(last_response.body)
      # Parse the 'time' field
      datetime = DateTime.parse(parsed_body['time'])
      # Converto seconds since epoc
      expect(datetime.to_time.to_i).to be_within(1).of Time.now.to_i
    end
  end
end