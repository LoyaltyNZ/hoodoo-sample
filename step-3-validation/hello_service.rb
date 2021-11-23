require 'hoodoo'

#
# POST /1/Hello payload { "first_name": "Dave", "surname": "Oram" }
# Returns 200 { "message": "Hello Dave Oram" }
#      or 503 { "error" ....}
#
# Concepts:
# - Verify the input, spit out error
# - Transform input to Output
#
class HelloImplementation < Hoodoo::Services::Implementation
  def create( context )
    body = context.request.body
    errors =  HelloPresenter.validate(body)
    puts "Errors: #{errors.has_errors?} #{errors.inspect}"
    if !errors.has_errors?
      first_name = body['first_name']
      surname = body['surname']
      context.response.set_resource( { 'message' => "Hello #{first_name} #{surname}" } )
    else
      context.response.add_errors( errors )
    end
  end
end

class HelloPresenter < Hoodoo::Presenters::Base
  schema do
    text :first_name, :required => true
    text :surname,    :required => true
  end
end

class HelloInterface < Hoodoo::Services::Interface
  interface :Hello do
    endpoint :Hello, HelloImplementation
    public_actions :create
  end

  to_create do
    resource HelloPresenter
  end
end
