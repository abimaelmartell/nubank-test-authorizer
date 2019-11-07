require "json"
require "time"

require_relative "validations"
require_relative "transaction"
require_relative "account"

class Authorizer
  def initialize
    @account_state = Account.new
  end

  def process_json_operation(line)
    data = JSON.parse(line)

    @account_state.process_operation(data).to_json
  end
end
