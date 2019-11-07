module Validations
  THREE_MINUTES = 3 * 60
  TWO_MINUTES   = 2 * 60

  def is_account_initialized?
    @account_initialized
  end

  def is_card_not_active?
    !@active_card
  end

  def is_doubled_transaction? transaction
    max_time = transaction.time + TWO_MINUTES
    min_time = transaction.time - TWO_MINUTES

    @transactions
      .select { |e| e.merchant == transaction.merchant && e.amount == transaction.amount }
      .select { |e| e.time.between?(min_time, max_time) }
      .length >= 1
  end

  def is_high_frequency? transaction
    max_time = transaction.time + THREE_MINUTES
    min_time = transaction.time - THREE_MINUTES

    @transactions
      .select { |e| e.time.between?(min_time, max_time) }
      .length >= 2
  end

  def is_insufficient_limit? transaction
    transaction.amount > @available_limit
  end
end
