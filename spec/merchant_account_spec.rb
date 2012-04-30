require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PaymentsGateway::MerchantAccount do

  before(:each) do
    # Test account data
    merchant_id = 144973
    api_login_id = 'wAOpu07K22'
    api_password = 'y87Aoa3gK7PJ7'
    transaction_password = 'y87Aoa3gK7PJ7'

    @ma = PaymentsGateway::MerchantAccount.new(merchant_id, api_login_id, api_password, transaction_password, false)
  end

  context "when I create a new client" do
    before(:each) do
      @client = PaymentsGateway::Client.new
      @client.first_name = "John"
      @client.last_name = "Smith"

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

      end

      it "can get the bank account" do
        pending
      end

      it "can update the bank account" do
        pending
      end

      it "can delete the bank account" do
        pending
      end

      it "can debit the bank account" do
        pending
      end

      it "can credit the bank account" do
        pending
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

    context "with a bank accout and a credit card" do
      it "can get a list of all payment methods" do
        pending
      end
    end

  end

end
