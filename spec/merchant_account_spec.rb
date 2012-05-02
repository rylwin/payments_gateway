require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PaymentsGateway::MerchantAccount do

  before(:each) do
    # Test account data
    merchant_id = 144973
    api_login_id = 'wAOpu07K22'
    api_password = 'y87Aoa3gK7PJ7'
    @transaction_password = '44e4XMhNG4c'

    @ma = PaymentsGateway::MerchantAccount.new(merchant_id, api_login_id, api_password, @transaction_password, false)
  end

  context "when I create a new client" do
    before(:each) do
      @client = PaymentsGateway::Client.new(
        :first_name => 'John', 
        :last_name => 'Smith',
        :email_address => 'john.smith@example.com')

      @client_id = @ma.create_client(@client).to_i
    end

    it "should respond with the client_id" do
      @client_id.should be > 0
    end

    it "should be updated with the ClientID" do
      @client.client_id.should == @client_id
    end

    it "should be updated with the MerchantID" do
      @client.merchant_id.should == @ma.merchant_id
    end

    it "should be updated with an active status" do
      @client.status.should == 'Active'
    end

    it "can get the client" do
      fetched_client = @ma.get_client(@client.client_id)
      
      fetched_client.first_name.should == @client.first_name
      fetched_client.last_name.should == @client.last_name
    end

    it "can update the client" do
      @client.first_name = "Ryan"
      response = @ma.update_client(@client)

      response.should be_true
      @ma.get_client(@client.client_id).first_name.should == "Ryan"
    end

    it "can delete the client" do
      deleted_id = @ma.delete_client(@client_id)

      deleted_id.should be_true
    end

    context "when I create a bank account" do

      before(:each) do
        @bank_account = PaymentsGateway::BankAccount.new(
          :client_id => @client.client_id,
          :acct_holder_name => 'Anna Banana',
          :ec_account_number => '123456789',
          :ec_account_trn => '122400724',
          :ec_account_type => PaymentsGateway::BankAccount::CHECKING,
          :note => 'Bank of America',
          :is_default => PaymentsGateway::BankAccount::YES)

        @bank_account_id = @ma.create_bank_account(@bank_account)
      end

      it "should respond with the payment_method_id" do
        @bank_account_id.should be > 0
      end

      it "should be updated with the PaymentMethodID" do
        @bank_account.payment_method_id.should == @bank_account_id
      end

      it "should be updated with the MerchantID" do
        @bank_account.merchant_id.should == @ma.merchant_id
      end

      it "should be updated with the TransactionPassword" do
        @bank_account.transaction_password.should == @transaction_password
      end

      it "can get the bank account" do
        fetched_bank_account = @ma.get_bank_account(@client.client_id, @bank_account.payment_method_id)
        
        fetched_bank_account.note.should == @bank_account.note
        fetched_bank_account.acct_holder_name.should == @bank_account.acct_holder_name
        fetched_bank_account.transaction_password.should == @transaction_password
      end

      it "can update the bank account" do
        pending 'Not planning on implementing this. I dont see a lot of value for this...thoughts?'
      end

      it "can delete the bank account" do
        deleted_id = @ma.delete_bank_account(@bank_account.payment_method_id)

        deleted_id.should be_true
      end

      context "when I debit the bank account the transaction response" do
        before(:each) do
          @transaction_response = @ma.debit_bank_account(@bank_account, :pg_total_amount => 100)
        end

        it "should be a successful transaction" do
          @transaction_response.success?.should be_true
        end

        it "should have a valid trace number" do
          @transaction_response.pg_trace_number.length.should == 36
        end
      end

      context "when I credit the bank account the transaction response" do
        before(:each) do
          @transaction_response = @ma.credit_bank_account(@bank_account, :pg_total_amount => 100)
        end

        it "should be a successful transaction" do
          @transaction_response.success?.should be_true
        end

        it "should have a valid trace number" do
          @transaction_response.pg_trace_number.length.should == 36
        end
      end

    end

    it "can create a credit card for the client" do
      pending
    end

    context "with a credit card" do

      it "can get the credit card" do
        pending
      end

      it "can update the credit card" do
        pending
      end

      it "can delete the credit card" do
        pending
      end

      it "can debit the credit card" do
        pending
      end

      it "can credit the credit card" do
        pending
      end

    end

  end

end
