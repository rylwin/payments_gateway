require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PaymentsGateway::MerchantAccount do
  it "can create a new client" do
    pending "need to implement"
  end

  context "with an existing client" do

    it "can get a list of all clients" do
      pending
    end

    it "can get the client" do
      pending
    end

    it "can update the client" do
      pending "need to implement"
    end

    it "can delete the client" do
      pending "need to implement"
    end

    it "can create a bank account for the client" do
      pending
    end

    context "with a bank account" do

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
