require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PaymentsGateway::EmbeddedCaptureTemplate do

  before(:each) do
    @ma = PaymentsGateway::MerchantAccount.new(
      MERCHANT_ACCT_AUTH[:merchant_id], 
      MERCHANT_ACCT_AUTH[:api_login_id], 
      MERCHANT_ACCT_AUTH[:api_password], 
      MERCHANT_ACCT_AUTH[:transaction_password], 
      false)

    @ect = @ma.embedded_capture_template(:client_id => 1)
  end

  context "#url" do
    it "generates the correct url" do
      url = @ect.url
      url.should match(/^https:\/\/sandbox\.paymentsgateway\.net/)
      url.should match(/client_id=1&/)
      url.should match(/UTCTime=[\d]{18}&/)
    end
  end

  context "in production" do
    before(:each) do
      @ma.stub(:production? => true)
    end
    it "uses the production base url" do
      @ect.base_url.should == 'https://swp.paymentsgateway.net/co/capture.aspx' 
      @ect.url.should match(/swp/)
    end
  end

end
