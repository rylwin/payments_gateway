module PaymentsGateway
  
  class Authentication
  
    def initialize(api_login_id, secure_transaction_key)
      @api_login_id = api_login_id
      @secure_transaction_key = secure_transaction_key
    end
    
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
      hash_string = "" 

      hash_args.each do |arg|
        hash_string += "|" unless hash_string.empty?
        if (arg.is_a?(Symbol)) then
          hash_string += @api_login_id.to_s if arg == :api_login_id
          hash_string += utc_time.to_s if arg == :utc_time
        else
          hash_string += arg
        end
      end

      hash_string
    end
    
  end
  
end
    
