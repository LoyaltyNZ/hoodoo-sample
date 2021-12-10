class PersonImplementation < Hoodoo::Services::Implementation

  def show( context )
    person = Person.acquire_in!( context )
    return if context.response.halt_processing?

    context.response.set_resource( render_in( context, person ) )
  end

  def list( context )

    # Parse and validate the date search parameters
    dob        = validate_date_field( context, 'date_of_birth' )
    dob_after  = validate_date_field( context, 'date_of_birth_after' )
    dob_before = validate_date_field( context, 'date_of_birth_before' )
    validate_date_range( context, dob_after, dob_before )
    return if context.response.halt_processing?

    # Find the right data
    finder = Person.list_in( context )
    finder = where_dob_exactly( finder, dob )
    finder = where_dob_before( finder, dob_before )
    finder = where_dob_after( finder, dob_after )
    list = finder.all.map { | person | render_in( context, person ) }

    context.response.set_resources( list, finder.dataset_size )
  end

  def create( context )
    person = Person.new_in( context, context.request.body )

    unless person.persist_in( context ) === :success
      context.response.add_errors( person.platform_errors )
      return
    end

    context.response.set_resource( render_in( context, person ) )
  end

  def update( context )
    person = Person.acquire_in( context )

    if person.nil?
      context.response.not_found( context.request.ident )
      return
    end

    person.assign_attributes( context.request.body )

    unless person.persist_in( context ) === :success
      context.response.add_errors( person.platform_errors )
      return
    end

    context.response.set_resource( render_in( context, person.reload ) )
  end

  def delete( context )
    person = Person.acquire_in( context )

    if person.nil?
      context.response.not_found( context.request.ident )
      return
    end

    rendered = render_in( context, person )
    person.delete()

    context.response.set_resource( rendered )
  end

  private

  # Look for a value 'key' in the context.request.list.search_data
  # Parse it as a date (not datetime)
  #
  # Returns either:
  # - Date object
  # - false if not a valid date, and an error added to the context
  # - nil if the key not found
  #
  def validate_date_field(context, key)
    date = nil
    if context.request.list.search_data.has_key?(key)
      date = Hoodoo::Utilities.valid_iso8601_subset_date?( context.request.list.search_data[ key ] )
      if date == false
        context.response.add_error(
          "generic.invalid_parameters",
          message: "Invalid date",
          reference: { field_names: "date_of_birth" }
        )
      end
    end
    return date
  end

  def validate_date_range(context, date1, date2)
    return if date1.nil? || date2.nil?
    if date2 < date1
      # TODO - See Hoodoo source code for standardised error messages
      context.response.add_error(
        "generic.invalid_parameters",
        message: "Invalid date range"
      )
    end
  end

  def where_dob_exactly( finder, date )
    return finder if date.nil?
    # https://www.postgresql.org/docs/13/functions-datetime.html
    finder.where( 'date_of_birth::TIMESTAMP::DATE = ?::TIMESTAMP::DATE', date)
  end

  def where_dob_before( finder, date )
    return finder if date.nil?
    finder.where( 'date_of_birth::TIMESTAMP::DATE <= ?::TIMESTAMP::DATE', date)
  end

  def where_dob_after( finder, date )
    return finder if date.nil?
    finder.where( 'date_of_birth::TIMESTAMP::DATE >= ?::TIMESTAMP::DATE', date)
  end

  # This avoids code duplication between the action methods,
  # concentrating the call to Hoodoo's presenter layer and
  # the database-to-resource mapping into one place.
  #
  def render_in( context, person )
    resource_fields = {
      'name' => person.name
    }

    if person.date_of_birth.present?
      resource_fields[ 'date_of_birth' ] = person.date_of_birth.iso8601()
    end

    options = {
      :uuid       => person.id,
      :created_at => person.created_at
    }

    Resources::Person.render_in(
      context,
      resource_fields,
      options
    )
  end

end