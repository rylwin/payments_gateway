require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PaymentsGateway::BankAccount do

  before(:each) do
    @transaction_password = '1111111'
    account_attr = {
      :client_id => 0,
      :payment_method_id => 1,
      :merchant_id => 2
    }

    @bank_account = PaymentsGateway::BankAccount.new(account_attr, @transaction_password)
  end

  context "#debit_setup" do

    before(:each) do
      @attr = @bank_account.debit_setup(:pg_total_amount => 100)
    end

    it "should set the attributes correctly" do
      @attr[:pg_total_amount].should == 100
      @attr[:pg_merchant_id].should == 2
      @attr[:pg_password].should == @transaction_password
      @attr[:pg_transaction_type].should == PaymentsGateway::BankAccount::EFT_SALE
      @attr[:pg_client_id].should == 0
      @attr[:pg_payment_method_id].should == 1
    end

  end

end
