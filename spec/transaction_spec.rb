require "./lib/transaction"

describe Transaction do
  let (:transaction_data) {
    { "merchant" => "Burger King", "amount" => 20, "time" => "2019-02-13T10:00:00.000Z" }
  }

  it "should parse time into Time object" do
    transaction = Transaction.from_json(transaction_data)

    expect(transaction.time).to be_a Time
  end
end
