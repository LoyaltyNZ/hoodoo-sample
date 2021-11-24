require "rack/test"
require 'json'
require_relative '../hello_service.rb'

describe HelloPresenter do

  context "#validate" do
    it "returns no errors when valid" do
      data = {
        'first_name' => "Bob",
        'surname' => 'Smith'
      }
      rendered = HelloPresenter.render( data )
      validation_errors = HelloPresenter.validate( rendered )
      # Returns a Hoodoo::Errors object, not an Array
      expect(validation_errors.has_errors?).to eq(false)
    end

    it "returns errors when missing surname" do
      data = { 'first_name' => "Bob" }
      rendered = HelloPresenter.render( data )
      validation_errors = HelloPresenter.validate( rendered )
      expect(validation_errors.errors.size).to eq(1)

      expected = {
        "code"=>"generic.required_field_missing",
        "message"=>"Field `surname` is required",
        "reference"=>"surname"
      }
      expect(validation_errors.errors.first).to eq(expected)
    end
  end

end