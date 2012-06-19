require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PaymentsGateway::Authentication do

  before(:each) do
    @api_login_id = "test_id"
    @secure_transaction_key = "secure_key"
    @optioned_val = "weeee"
    @authentication = PaymentsGateway::Authentication.new(@api_login_id, @secure_transaction_key)
    @utc_time = '621355968420000000'
    DateTime.stub(:now).and_return(42) # this will give us a utc time of @utc_time
  end

  context "#login_hash=" do

    context "with default param" do
      before(:each) do
        @ts_hash = @authentication.send(:calculate_hash, "#{@api_login_id}|#{@utc_time}")
        @result = @authentication.login_hash
      end

      it "should contain the api login id" do
        @result.keys.size.should eq(3)

        @result[:APILoginID].should eq(@api_login_id)
        @result[:UTCTime].should eq(@utc_time)
        @result[:TSHash].should eq(@ts_hash)
      end
    end

    context "private helper methods" do
      it "#hash_string_from_args" do
        hash_string = "#{@api_login_id}|#{@utc_time}"
        hash_args = [:api_login_id, :utc_time]
        @authentication.send(:hash_string_from_args, hash_args, @utc_time).should eq(hash_string)
      end

      it "#hash_string_from_args for with an optional value" do
        hash_string = "#{@api_login_id}|#{@optioned_val}|#{@utc_time}"
        hash_args = [:api_login_id, @optioned_val, :utc_time]
        @authentication.send(:hash_string_from_args, hash_args, @utc_time).should eq(hash_string)
      end

      it "#calculate_hash" do
        hash_string = "#{@api_login_id}|#{@utc_time}"
        # constant hash is a precalculated hash value that shouldn't change unless some libraries do unexpectedly
        @authentication.send(:calculate_hash, hash_string).should eq("b09b00c3ced5a44d763d86f7250506f9")
      end
    end
  end

end
