require "./lib/authorizer.rb"

describe Account do
  let (:activate_account_data) {
    { "account" => { "activeCard" => true, "availableLimit" => 100 } }
  }

  let (:transaction_data) {
    { "transaction" => { "merchant" => "Burger King", "amount" => 20, "time" => "2019-02-13T10:00:00.000Z" } }
  }

  let (:invalid_transaction_data) {
    { "transaction" => { "merchant" => "Burger King", "amount" => 120, "time" => "2019-02-13T10:00:00.000Z" } }
  }

  describe "process_operation" do
    describe "account operation" do
      it "should activate account on account operation" do
        account = Account.new
        account.process_operation activate_account_data

        expect(account.active_card).to be true
        expect(account.available_limit).to be 100
      end

      it "should return violation when account is already initialized" do
        account = Account.new
        account.process_operation activate_account_data

        result = account.process_operation activate_account_data
        expect(result["violations"]).not_to be_empty
        expect(result["violations"]).to include("account-already-initialized")
      end
    end

    describe "transaction operation" do
      it "should process valid operation" do
        account = Account.new
        account.process_operation activate_account_data

        expect(account.active_card).to be true
        expect(account.available_limit).to be 100

        result = account.process_operation transaction_data
        expect(account.available_limit).to be 80
        expect(result["violations"]).to be_empty
      end

      it "should not process invalid operation" do
        account = Account.new
        account.process_operation activate_account_data

        expect(account.active_card).to be true
        expect(account.available_limit).to be 100

        result = account.process_operation invalid_transaction_data
        expect(account.available_limit).to be 100
        expect(result["violations"]).not_to be_empty
        expect(result["violations"]).to include("insufficient-limit")
      end
    end
  end
end
