require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PaymentsGateway::Authentication do

  before(:each) do
    @api_login_id = "test_id"
    @secure_transaction_key = "secure_key"
    @optioned_val = "weeee"
    @authentication = PaymentsGateway::Authentication.new(@api_login_id, @secure_transaction_key)
    @utc_time = 42
    DateTime.stub(:now).and_return(@utc_time)
  end

  context "#login_hash=" do
    it "should calculate default hash_string correctly" do
      hash_string = "#{@api_login_id}|#{@utc_time}"
      hash_args = [:api_login_id, :utc_time]
      @authentication.send(:hash_string_from_args, hash_args, @utc_time).should eq(hash_string)
    end

    it "should calculate optioned hash_string correctly" do
      hash_string = "#{@api_login_id}|#{@optioned_val}|#{@utc_time}"
      hash_args = [:api_login_id, @optioned_val, :utc_time]
      @authentication.send(:hash_string_from_args, hash_args, @utc_time).should eq(hash_string)
    end

    it "should calculate hash correctly" do
      hash_string = "#{@api_login_id}|#{@utc_time}"
      # constant hash is a precalculated hash value that shouldn't change unless some libraries do unexpectedly
      @authentication.send(:calculate_hash, hash_string).should eq("37a0aec79b370901b8fa469be4b8aee8")
    end

  end

end
