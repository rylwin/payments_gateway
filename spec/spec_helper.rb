$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'vcr'
require 'payments_gateway'

VCR.configure do |c|
  c.cassette_library_dir       = 'spec/cassettes'
  c.hook_into                  :webmock
  c.default_cassette_options = {:record => :all}
  c.configure_rspec_metadata!
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
  config.treat_symbols_as_metadata_keys_with_true_values = true
  #config.backtrace_clean_patterns = []
end
