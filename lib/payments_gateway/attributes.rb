module PaymentsGateway

  module Attributes

    # Allows you to set all the attributes at once by passing in a hash 
    # with keys matching the attribute names (which again 
    # matches the column names).
    def attributes=(hash)
      hash.each_pair do |k, v|
        send("#{k.to_s}=", v)
      end
    end

    # Converts the data attributes of the class to a hash that can be
    # sent to PaymentsGateway Webservices via SOAP/XML.
    #
    # This method requires that the object has properly initialized 
    # @field_map and @data hashes. See PaymentsGateway::Client for
    # an example.
    def to_pg_hash
      retval = {}

      @data.each { |key, value| retval[ @field_map[key] ] = value }

      retval
    end

  end

end
