# Example integration test that shows how you might do an index-like ("#list")
# test - only no service is configured in the empty service shell, so we expect
# an exception. You'd obviously delete this test in a real service!
#
# IMPORTANT:
#
# * You must always "require 'spec_helper'" in each ..._spec.rb file
#
# * Use "Rspec.describe" at the top level, since RSpec monkey patching is
#   fully disabled.
#
# * See "log/test.log" for results. It'll just contain the test run dates and
#   nothing else in this simple test case.
#
# * Open "coverage/rcov/index.html" for a code coverage report. The fact that
#   code ran doesn't mean it would've handled all possible input/execution
#   cases, so 100% code coverage doesn't mean 100% effective testing; but less
#   than 100% certainly does mean you have a test omission.

require 'spec_helper'

CONTENT_TYPE = { 'CONTENT_TYPE' => 'application/json; charset=utf-8' }

RSpec.describe '1/Person' do

  context 'show' do

    context 'person found' do

      let(:p) { FactoryBot.create(:person) }

      it 'returns 200' do
        get "/1/Person/#{p.id}", nil, CONTENT_TYPE
        expect(last_response.status).to eq 200
      end

      it 'renders the response correctly' do
        get "/1/Person/#{p.id}", nil, CONTENT_TYPE
        msg = %(
          {
            "kind": "Person",
            "name":"#{p.name}"
          }
        )
        expect(last_response.body).to be_json_eql(msg)
      end

    end

    context 'person not found' do

      let(:id) { Hoodoo::UUID.generate}

      it 'returns 404' do
        get "/1/Person/#{id}", nil, CONTENT_TYPE
        expect(last_response.status).to eq 404
      end

      it 'renders the response correctly' do
        get "/1/Person/#{id}", nil, CONTENT_TYPE
        msg = %(
          {
            "errors": [
              {
                "code": "generic.not_found",
                "message": "Resource not found",
                "reference": "#{id}"
              }
            ],
            "kind": "Errors"
          }
        )
        expect(last_response.body).to be_json_eql(msg).excluding("interaction_id")
      end

    end

  end

  context 'list' do

    context 'have no people in the db' do

      it 'returns 200' do
        get "/1/Person", nil, CONTENT_TYPE
        expect(last_response.status).to eq 200
      end

      it 'renders the response correctly' do
        get "/1/Person", nil, CONTENT_TYPE
        msg = %({ "_dataset_size": 0 })
        expect(last_response.body).to be_json_eql(msg).excluding("_data")
        expect(last_response.body).to have_json_size(0).at_path("_data")
      end

    end

    context 'have some people in the db' do

      before(:each) do
        10.times do
          FactoryBot.create(:person)
        end
      end

      it 'returns 200' do
        get "/1/Person", nil, CONTENT_TYPE
        expect(last_response.status).to eq 200
      end

      it 'renders the response correctly' do
        get "/1/Person", nil, CONTENT_TYPE
        msg = %({ "_dataset_size": 10 })
        expect(last_response.body).to be_json_eql(msg).excluding("_data")
        expect(last_response.body).to have_json_size(10).at_path("_data")
        # TODO check the _data elements
      end

    end

  end

  context 'create' do

    context 'valid input' do

      it 'returns 200' do
        post "/1/Person", { name: 'Joe Smith' }.to_json, CONTENT_TYPE
        expect(last_response.status).to eq 200
      end

      it 'renders the response correctly' do
        post "/1/Person", { name: 'Joe Smith' }.to_json, CONTENT_TYPE
        msg = %({ "kind": "Person", "name": "Joe Smith" })
        expect(last_response.body).to be_json_eql(msg)
      end

      it 'renders the response correctly, when date_of_birth supplied' do
        post "/1/Person", { name: 'Joe Smith', date_of_birth: '1980-11-03' }.to_json, CONTENT_TYPE
        msg = %({ "kind": "Person", "name": "Joe Smith", "date_of_birth": "1980-11-03" })
        expect(last_response.body).to be_json_eql(msg)
      end

    end

    context 'invalid input' do

      it 'returns 422' do
        post "/1/Person", { }.to_json, CONTENT_TYPE
        expect(last_response.status).to eq 422
      end

      it 'renders the response correctly' do
        post "/1/Person", {  }.to_json, CONTENT_TYPE
        msg = %(
          {
            "errors": [
              {
                "code": "generic.required_field_missing",
                "message": "Field `name` is required",
                "reference": "name"
              }
            ],
            "kind": "Errors"
          }
        )
        expect(last_response.body).to be_json_eql(msg).excluding("interaction_id")
      end

    end

  end

  context 'update' do

  end

  context 'delete' do

  end
end
