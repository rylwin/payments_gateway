module PaymentsGateway

  module Attributes

    # Allows you to set all the attributes at once by passing in a hash 
    # with keys matching the attribute names (which again 
    # matches the column names).
    def attributes=(hash)
      hash.each_pair do |k, v|
        setter = "#{k.to_s}="
        send(setter, v) if self.class.method_defined?(setter)
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

      @data.each { |key, value| retval[ @field_map[key] ] = cast_value_for_key(key, value) }

      retval
    end

    def cast_value_for_key(key, value)
      case key
      when 'cc_expiration_date'
        value.strftime('%Y%m')
      when 'is_default'
        value.blank? ? 'false' : value.to_s
      when 'cc_card_type'
        value.to_s.upcase
      else
        value
      end
    end

    private

    def parse(account)
      account.__xmlele.each do |x|
        m_name = x.first.name.underscore 
        if @field_map[m_name]                
          # client_record[x.first.name] will contain the value "SOAP::Mapping::Object" if it is blank.
          @data[m_name] = account[x.first.name].class.to_s == "SOAP::Mapping::Object" ? '' : account[x.first.name]
        end
      end
    end

  end

end
