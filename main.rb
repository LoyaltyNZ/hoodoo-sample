require 'rack'
require 'hoodoo'
require_relative 'time_service.rb'


# This is a hack for the example and needed if you have Active Record present,
# else Hoodoo will expect a database connection.
#
Object.send( :remove_const, :ActiveRecord ) rescue nil

builder = Rack::Builder.new do
  use( Hoodoo::Services::Middleware )
  run( TimeService.new )
end

Rack::Handler::Thin.run( builder, :Port => 8080 )