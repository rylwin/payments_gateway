require 'openssl'
require 'soap/wsdlDriver'
require 'active_support/all'
require 'savon'

module Builder
  class XmlBase
    if !::String.method_defined?(:encode)
      def _escape(test)
        begin
          # original code from method
          text.to_xs((@encoding != 'utf-8' or $KCODE != 'UTF8'))
        rescue
          text.to_xs
        end
      end
    end
  end
end

module PaymentsGateway
  dir = File.dirname(__FILE__) + '/payments_gateway'
  $LOAD_PATH.unshift(dir)
  require dir + '/attributes.rb' # must be required first
  Dir[File.join(dir, "*.rb")].each {|file| require File.basename(file) }
end

