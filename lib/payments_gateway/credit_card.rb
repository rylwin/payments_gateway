module PaymentsGateway
  
  class CreditCard
  
    include PaymentsGateway::Attributes

    # Credit Card Transaction Codes
    SALE      = 10
    AUTH_ONLY = 11
    CAPTURE   = 12
    CREDIT    = 13
    VOID      = 14
    PRE_AUTH  = 15

    attr_accessor :transaction_password

    def initialize(account = nil, transaction_password = nil)
      @field_map = {}
      @data = {}
      @transaction_password = transaction_password
      
      setup_fields

      if account.is_a?(Hash)
        self.attributes = account
      elsif !account.nil?
        parse(account) 
      end
      
      nil
    end
    
    def debit_setup(attributes={})
      base_attributes = {
       :pg_merchant_id => self.merchant_id, 
       :pg_password => @transaction_password,       
       :pg_transaction_type => SALE,
       :pg_client_id => self.client_id,
       :pg_payment_method_id => self.payment_method_id,
      }

      base_attributes.merge(attributes)
    end
    
    private
    
    def setup_fields
      pg_fields  = ['MerchantID',
                    'ClientID',
                    'PaymentMethodID',
                    'AcctHolderName',
                    'CcCardNumber',
                    'CcExpirationDate',
                    'CcCardType',
                    'Note',
                    'IsDefault']
      
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
