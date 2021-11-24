# Implementation spec for person

require 'spec_helper'

RSpec.describe PersonImplementation do

  it 'adds a row from the person table, on create' do
    expect { post "/1/Person", { name: 'Joe Smith' }.to_json, CONTENT_TYPE }.to change(Person, :count).by(1)
  end

  it 'deletes a row from the person table, on delete' do
    p = FactoryBot.create(:person_with_dob)
    expect { delete "/1/Person/#{p.id}", nil, CONTENT_TYPE }.to change(Person, :count).by(-1)
  end

end
