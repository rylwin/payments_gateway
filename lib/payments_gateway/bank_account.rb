module PaymentsGateway
  
  class BankAccount

    include PaymentsGateway::Attributes
    
    CHECKING = 'CHECKING'
    SAVINGS = 'SAVINGS'
    
    YES = 'true'
    NO = 'false'
    
    # EFT TRANSACTION_CODES
    EFT_SALE = 20
    EFT_AUTH_ONLY = 21
    EFT_CAPTURE = 22
    EFT_CREDIT = 23
    EFT_VOID = 24
    EFT_FORCE = 25
    EFT_VERIFY_ONLY = 26
  
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
       :pg_transaction_type => EFT_SALE,
       :pg_client_id => self.client_id,
       :pg_payment_method_id => self.payment_method_id,
      }

      base_attributes.merge(attributes)
    end
    
    
    def credit_setup(attributes={})
      base_attributes = {
       :pg_merchant_id => self.merchant_id, 
       :pg_password => @transaction_password,       
       :pg_transaction_type => EFT_CREDIT,
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
                    'EcAccountNumber',
                    'EcAccountTRN',
                    'EcAccountType',
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
    
  end
  
end
