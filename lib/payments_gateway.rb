require 'openssl'
require 'soap/wsdlDriver'
require 'active_support/all'

module XSD
  class NS
    def parse_local(elem)
      ParseRegexp =~ elem
      if $2
        ns = @tag2ns[$1]
        name = $2
        if !ns
          # Don't raies error just because we don't recongize namespace qualifier
          #raise FormatError.new("unknown namespace qualifier: #{$1}")
        end
      elsif $1
        ns = nil
        name = $1
      else
        raise FormatError.new("illegal element format: #{elem}")
      end
      XSD::QName.new(ns, name)
    end
  end
end

module PaymentsGateway
  dir = File.dirname(__FILE__) + '/payments_gateway'
  $LOAD_PATH.unshift(dir)
  require dir + '/attributes.rb' # must be required first
  Dir[File.join(dir, "*.rb")].each {|file| require File.basename(file) }
end

