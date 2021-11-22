require 'rack'
require 'hoodoo'
require_relative 'time_service.rb'
require_relative 'hello_service.rb'


# This is a hack for the example and needed if you have Active Record present,
# else Hoodoo will expect a database connection.
#
Object.send( :remove_const, :ActiveRecord ) rescue nil

class SampleService < Hoodoo::Services::Service
    comprised_of TimeInterface
    comprised_of HelloInterface
end

builder = Rack::Builder.new do
  use( Hoodoo::Services::Middleware )
  run( SampleService.new )
end

Rack::Handler::Thin.run( builder, :Port => 8080 )