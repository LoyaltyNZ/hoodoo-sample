require "rack/test"
require 'json'
require_relative '../hello_service.rb'

class HelloService < Hoodoo::Services::Service
  comprised_of HelloInterface
end

describe 'Hello Service' do
  include Rack::Test::Methods

  context "POST /1/Hello" do
    let(:app) {
      Rack::Builder.new do
        use( Hoodoo::Services::Middleware )
        run( HelloService.new )
      end
    }

    context "happy path" do

      it "returns the status 200" do
        post "/1/Hello",
            { first_name: "Bob", surname: 'Smith' }.to_json,
            { 'CONTENT_TYPE' => 'application/json; charset=utf-8' }
        expect(last_response.status).to eq 200
      end

      it "returns the correct response body" do
        post "/1/Hello",
            { first_name: "Bob", surname: 'Smith' }.to_json,
            { 'CONTENT_TYPE' => 'application/json; charset=utf-8' }
        msg = %(
                {
                  "message":"Hello Bob Smith"
                }
              )
        last_response.body.should be_json_eql(msg)
      end

    end

    context "invalid input" do

      it "returns the status 422" do
        post "/1/Hello",
            { first_name: "Bob" }.to_json,
            { 'CONTENT_TYPE' => 'application/json; charset=utf-8' }
        expect(last_response.status).to eq 422
      end

      it "returns the correct error response body" do
        post "/1/Hello",
            { surname: 'Smith' }.to_json,
            { 'CONTENT_TYPE' => 'application/json; charset=utf-8' }
        resp = %({
                  "errors": [
                    {
                      "code": "generic.required_field_missing",
                      "message": "Field `first_name` is required",
                      "reference": "first_name"
                    }
                  ],
                  "kind": "Errors"
                })
        # Note that json_spec by default excludes `id` and `created_at` fields.
        # See https://github.com/collectiveidea/json_spec#exclusions
        last_response.body.should be_json_eql(resp).excluding("interaction_id")
      end

    end

  end
end