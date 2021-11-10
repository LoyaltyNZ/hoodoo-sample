class TimeImplementation < Hoodoo::Services::Implementation
    def show( context )
      context.response.set_resource( { 'time' => Time.now.utc.iso8601 } )
    end
  end

  class TimeInterface < Hoodoo::Services::Interface
    interface :Time do
      endpoint :time, TimeImplementation
      public_actions :show
    end
  end

  class TimeService < Hoodoo::Services::Service
    comprised_of TimeInterface
  end