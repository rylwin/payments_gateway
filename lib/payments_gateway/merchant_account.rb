module PaymentsGateway
  
  class MerchantAccount

    attr_accessor :merchant_id
  
    def initialize(merchant_id, api_login_id, api_password, transaction_password, production = true)
      if @production = production
        @payments_gateway_client_wsdl = 'https://ws.paymentsgateway.net/Service/v1/Client.wsdl'
        @payments_gateway_transaction_wsdl = 'https://ws.paymentsgateway.net/Service/v1/Transaction.wsdl'
        @payments_gateway_merchant_wsdl = 'https://ws.paymentsgateway.net/Service/v1/Merchant.wsdl'        
        @payments_gateway_socket_wsdl = 'https://ws.paymentsgateway.net/pg/paymentsgateway.asmx?WSDL'
      else
        @payments_gateway_client_wsdl = 'https://sandbox.paymentsgateway.net/WS/Client.wsdl'
        @payments_gateway_transaction_wsdl = 'https://sandbox.paymentsgateway.net/WS/Transaction.wsdl'
        @payments_gateway_merchant_wsdl = 'https://sandbox.paymentsgateway.net/WS/Merchant.wsdl'        
        @payments_gateway_socket_wsdl = 'https://ws.paymentsgateway.net/pgtest/paymentsgateway.asmx?WSDL'
      end
      
      @merchant_id = merchant_id
      @api_login_id = api_login_id
      @api_password = api_password
      @transaction_password = transaction_password

      nil
    end

    def swp_redirect_url
      @production ? 'https://swp.paymentsgateway.net/Redirect/default.aspx' : 'https://sandbox.paymentsgateway.net/SWP/Redirect/default.aspx'
    end

    def production?
      @production
    end

    def authentication
      Authentication.new(@api_login_id, @api_password)
    end
  
    ###################################
    # Embedded Capture Template 
    ###################################
    
    def embedded_capture_template(options={})
      PaymentsGateway::EmbeddedCaptureTemplate.new(self, options)
    end

    ###################################
    # Client
    ###################################
    
    def get_client(client_id)
      params = {:MerchantID => @merchant_id, :ClientID => client_id}    
      response = client_driver.getClient(login_credentials.merge(params))      
      PaymentsGateway::Client.new(response.getClientResult['ClientRecord'])
    end
    
    def create_client(client)
      client.merchant_id = @merchant_id
      client.status = 'Active'

      params = {'client' => client.to_pg_hash.merge({'MerchantID' => @merchant_id, 'ClientID' => 0})} 
      response = client_driver.createClient(login_credentials.merge(params)) 
      client_id = response.createClientResult.to_i

      client.client_id = client_id.to_i
    end
    
    def update_client(client)
      params = {'client' => client.to_pg_hash} 
      response = client_driver.updateClient(login_credentials.merge(params)) 
      response.updateClientResult.to_i == client.client_id.to_i ? true : false     
    end
    
    
    def delete_client(client_id)
      params = {'ClientID' => client_id, 'MerchantID' => @merchant_id}

      response = client_driver.deleteClient(login_credentials.merge(params)) 
      response.deleteClientResult.to_i == client_id.to_i ? true : false     
    end
    
    ###################################
    # Bank Account
    ###################################
    
    def get_bank_account(client_id, account_id)
      params = {'MerchantID' => @merchant_id, 'ClientID' => client_id, 'PaymentMethodID' => account_id}    
      response = client_driver.getPaymentMethod(login_credentials.merge(params)) 
      ba = PaymentsGateway::BankAccount.new(response.getPaymentMethodResult['PaymentMethod'], @transaction_password)
      return ba
    end
    
    def create_bank_account(bank_account)
      create_payment_method(bank_account)
    end
    
    def update_bank_account
      raise 'update_bank_account method not implemented yet'
    end
    
    def delete_bank_account(payment_method_id)
      delete_payment_method(payment_method_id)
    end
    
    def debit_bank_account(bank_account, amount)
      params = bank_account.debit_setup(amount)
      response = socket_driver.ExecuteSocketQuery(login_credentials.merge(params)) 
      transaction_response = PaymentsGateway::TransactionResponse.new(response['ExecuteSocketQueryResult'])
    end
    
    def credit_bank_account(bank_account, amount)
      params = bank_account.credit_setup(amount)
      response = socket_driver.ExecuteSocketQuery(login_credentials.merge(params)) 
      transaction_response = PaymentsGateway::TransactionResponse.new(response['ExecuteSocketQueryResult'])
    end
      
    ###################################
    # Credit Card
    ###################################
    
    def get_credit_card(client_id, account_id)
      params = {'MerchantID' => @merchant_id, 'ClientID' => client_id, 'PaymentMethodID' => account_id}    
      response = client_driver.getPaymentMethod(login_credentials.merge(params)) 
      ba = PaymentsGateway::CreditCard.new(response.getPaymentMethodResult['PaymentMethod'], @transaction_password)
      return ba
    end
    
    def create_credit_card(payment_method)
      create_payment_method(payment_method)
    end
    
    def update_credit_card
      raise 'update_credit_card method not implemented yet'
    end
    
    def delete_credit_card(payment_method_id)
      delete_payment_method(payment_method_id)
    end

    def debit_credit_card(credit_card, amount)
      params = credit_card.debit_setup(amount)
      response = socket_driver.ExecuteSocketQuery(login_credentials.merge(params)) 
      transaction_response = PaymentsGateway::TransactionResponse.new(response['ExecuteSocketQueryResult'])
    end
    
    def credit_credit_card(credit_card, amount)
      params = credit_card.credit_setup(amount)
      response = socket_driver.ExecuteSocketQuery(login_credentials.merge(params)) 
      transaction_response = PaymentsGateway::TransactionResponse.new(response['ExecuteSocketQueryResult'])
    end
      
    ###################################
    # PaymentMethod
    ###################################

    def create_payment_method(payment_method)
      payment_method.merchant_id = @merchant_id
      payment_method.transaction_password = @transaction_password

      #other_fields = {'AcctHolderName' => '0', 'CcCardNumber' => '0', 'CcExpirationDate' => '0', 'CcCardType' => 'VISA'}
      # TODO: Where do we define ACH type if this is a bank account? (e.g., WEB)
      other_fields = {'CcCardType' => 'VISA', 'CcProcurementCard' => 'false', 'EcAccountType' => 'CHECKING'}
      params = {'payment' => payment_method.to_pg_hash.merge({'PaymentMethodID' => 0}.reverse_merge(other_fields))}       

      response = client_driver.createPaymentMethod(login_credentials.merge(params)) 
      payment_method_id = response.createPaymentMethodResult.to_i

      payment_method.payment_method_id = payment_method_id

      payment_method_id
    end

    def delete_payment_method(payment_method_id)
      params = {'MerchantID' => @merchant_id, 'PaymentMethodID' => payment_method_id}

      response = client_driver.deletePaymentMethod(login_credentials.merge(params)) 
      response.deletePaymentMethodResult.to_i == payment_method_id.to_i ? true : false     
    end
    
    private

    def client_driver
      @client_driver ||= SOAP::WSDLDriverFactory.new(@payments_gateway_client_wsdl).create_rpc_driver
    end

    def transaction_driver
      @transaction_driver ||= SOAP::WSDLDriverFactory.new(@payments_gateway_transaction_wsdl).create_rpc_driver
    end

    def merchant_driver
      @merchant_driver ||= SOAP::WSDLDriverFactory.new(@payments_gateway_merchant_wsdl).create_rpc_driver
    end

    def socket_driver
      @socket_driver ||= SOAP::WSDLDriverFactory.new(@payments_gateway_socket_wsdl).create_rpc_driver
    end
    
    def login_credentials
      {:ticket => authentication.login_hash}
    end

  end
  
end
