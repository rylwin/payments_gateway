module PaymentsGateway
  
  class Client

    include PaymentsGateway::Attributes
  
    def initialize(client_record = nil)        
      @field_map = {}
      @data = {}
      
      setup_fields
      if client_record.is_a?(Hash)
        self.attributes = client_record
      elsif !client_record.nil?
        parse(client_record) 
      end
      
      nil
    end
    
    private
    
    def setup_fields
      pg_fields  = ['MerchantID',
                    'ClientID',
                    'FirstName',
                    'LastName',
                    'CompanyName',
                    'Address1',
                    'Address2',
                    'City',
                    'State',
                    'PostalCode',
                    'CountryCode',
                    'PhoneNumber',
                    'FaxNumber',
                    'EmailAddress',
                    'ShiptoFirstName',
                    'ShiptoLastName',
                    'ShiptoCompanyName',
                    'ShiptoAddress1',
                    'ShiptoAddress2',
                    'ShiptoCity',
                    'ShiptoState',
                    'ShiptoPostalCode',
                    'ShiptoCountryCode',
                    'ShiptoPhoneNumber',
                    'ShiptoFaxNumber',
                    'ConsumerID',
                    'Status']
                    
      pg_fields.each do |field|             
        m_name = field.underscore 
        @field_map[m_name] = field
        @data[m_name] = ''
        
        self.class.send(:define_method, m_name) do
          @data[m_name]
        end
        
        self.class.send(:define_method, "#{m_name}=") do |val|
          @data[m_name] = val
        end
      end          
    end
    
    def parse(client_record)
      client_record.__xmlele.each do |x| 
        m_name = x.first.name.underscore 
                
        # client_record[x.first.name] will contain the value "SOAP::Mapping::Object" if it is blank.
        @data[m_name] = client_record[x.first.name].class.to_s == "SOAP::Mapping::Object" ? '' : client_record[x.first.name]
      end
    end

  end
  
end
