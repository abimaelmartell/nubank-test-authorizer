require "./lib/authorizer.rb"

describe Validations do
  let (:activate_account_data) {
    { "activeCard" => true, "availableLimit" => 100 }
  }

  let (:transaction_data) {
    { "merchant" => "Burger King", "amount" => 20, "time" => "2019-02-13T10:00:00.000Z" }
  }

  describe "is_account_initialized?" do
    it "should check for account initialized" do
      account = Account.new
      expect(account.is_account_initialized?).to be false

      account.initialize_account!(activate_account_data)
      expect(account.is_account_initialized?).to be true
    end
  end

  describe "is_card_not_active?" do
    it "should check for active_card" do
      account = Account.new
      expect(account.is_card_not_active?).to be true

      account.initialize_account!(activate_account_data)
      expect(account.is_card_not_active?).to be false
    end
  end

  describe "is_doubled_transaction?" do
    it "should check for similar transactions within two minutes" do
      transaction = Transaction.from_json(transaction_data)
      account = Account.new
      account.initialize_account!(activate_account_data)
      account.save_transaction!(transaction)

      expect(account.is_doubled_transaction?(transaction)).to be true
    end

    it "should return false for different amounts" do
      transaction = Transaction.from_json(transaction_data)
      account = Account.new
      account.initialize_account!(activate_account_data)
      account.save_transaction!(transaction)

      transaction = Transaction.from_json(transaction_data.merge("amount" => 30))
      expect(account.is_doubled_transaction?(transaction)).to be false
    end

    it "should return false for similar transactions not within two minutes" do
      transaction = Transaction.from_json(transaction_data)
      account = Account.new
      account.initialize_account!(activate_account_data)
      account.save_transaction!(transaction)

      transaction = Transaction.from_json(transaction_data.merge("time" => "2019-02-13T10:03:00.000Z"))
      expect(account.is_doubled_transaction?(transaction)).to be false
    end
  end

  describe "is_high_frequency?" do
    it "should check for transactions within three minutes" do
      transaction = Transaction.from_json(transaction_data)
      account = Account.new

      account.initialize_account!(activate_account_data)
      account.save_transaction!(transaction)

      transaction = Transaction.from_json(transaction_data.merge("amount" => 30))
      account.save_transaction!(transaction)

      transaction = Transaction.from_json(transaction_data.merge("amount" => 40))
      expect(account.is_high_frequency?(transaction)).to be true
    end
  end
end
