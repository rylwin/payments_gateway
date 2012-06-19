module PaymentsGateway
  
  class Authentication
  
    def initialize(api_login_id, secure_transaction_key)
      @api_login_id = api_login_id
      @secure_transaction_key = secure_transaction_key
    end
    
    # Generates a hash containing authentication data.
    #
    # For the PaymentsGateway web services, the ts_hash is generated using
    # the api_login_id and the utc_time. Other services, however, require
    # additional information to be included in the ts_hash. 
    # Use the hash_args param to include additional data in the computed ts_hash.
    # For example:
    #
    #   #login_hash([:api_login_id, "some other value", :utc_time])
    #
    # This example calculates the ts_hash with the "some other value" included in 
    # the string to be hashed. :api_login_id and :utc_time are special symbols that
    # are automatically interpolated with the api_login_id and utc_time, respectively.
    def login_hash(hash_args=[:api_login_id, :utc_time])
      # Time diff from 1/1/0001 00:00:00 to 1/1/1970 00:00:00
      utc_time = (DateTime.now.to_i + 62135596800).to_s + '0000000'

      ts_hash = calculate_hash(hash_string_from_args(hash_args, utc_time))

      {:APILoginID => @api_login_id, :TSHash => ts_hash, :UTCTime => utc_time}
    end

    private 

    def calculate_hash(hash_string)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('md5'), @secure_transaction_key, hash_string)
    end

    def hash_string_from_args(hash_args, utc_time)
      values = []

      hash_args.each do |arg|
        if arg == :api_login_id
          values << @api_login_id
        elsif arg == :utc_time
          values << utc_time
        else
          values << arg
        end
      end

      values.join '|'
    end
    
  end
  
end
    
