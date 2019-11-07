class Account
  include Validations

  attr_accessor :active_card, :available_limit, :transactions

  def initialize
    @transactions = []
    @active_card = false
    @available_limit = 0
    @account_initialized = false
  end

  def process_operation(data)
    violations = []

    if data["account"]
      account_data = data["account"]

      violations = get_account_violations(account_data)
      if violations.empty?
        initialize_account!(account_data)
      end
    elsif data["transaction"]
      transaction = Transaction.from_json(data["transaction"])

      violations = get_transaction_violations(transaction)
      if violations.empty?
        save_transaction!(transaction)
      end
    end

    to_json(violations)
  end

  def initialize_account!(data)
    @available_limit = data["availableLimit"]
    @active_card = data["activeCard"]
    @account_initialized = true
  end

  def save_transaction!(transaction)
    @available_limit -= transaction.amount
    @transactions << transaction
  end

  def get_transaction_violations(transaction)
    violations = []

    if is_card_not_active?
      violations << "card-not-active"
    end

    if is_insufficient_limit? transaction
      violations << "insufficient-limit"
    end

    if is_doubled_transaction? transaction
      violations << "doubled-transaction"
    end

    if is_high_frequency? transaction
      violations << "high-frequency-small-interval"
    end

    violations
  end

  def get_account_violations(account_data)
    violations = []

    if is_account_initialized?
      violations << "account-already-initialized"
    end

    violations
  end

  def to_json(violations = [])
    {
      "account" => {
        "activeCard" => @active_card,
        "availableLimit" => @available_limit
      },
      "violations" => violations
    }
  end
end
