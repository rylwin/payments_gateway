module PaymentsGateway

  # Builds a URL for accessing the EmbeddedCaptureTemplate
  #
  # http://www.paymentsgateway.com/developerDocumentation/Integration/securewebpay/embedded/embeddedCaptureTemplate.aspx
  class EmbeddedCaptureTemplate

    attr_accessor :options

    def initialize(merchant_account, options={})
      @ma = merchant_account
      self.options = options
    end

    def url
      params = options.merge(@ma.authentication.login_hash)

      url = base_url + '?'
      url += parameterize(params)
      url
    end

    def base_url
      if @ma.production?
        'https://swp.paymentsgateway.net/co/capture.aspx'
      else
        'https://sandbox.paymentsgateway.net/SWP/co/capture.aspx'
      end
    end

    private

    def parameterize(params)
      URI.escape(params.collect{|k,v| "#{k}=#{v}"}.join('&'))
    end

  end

end
