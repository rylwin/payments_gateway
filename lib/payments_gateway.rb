require 'openssl'
require 'soap/wsdlDriver'
require 'active_support/all'

module PaymentsGateway
  dir = File.dirname(__FILE__) + '/payments_gateway'
  $LOAD_PATH.unshift(dir)
  require dir + '/attributes.rb' # must be required first
  Dir[File.join(dir, "*.rb")].each {|file| require File.basename(file) }
end

