class Transaction
  attr_reader :merchant, :amount, :time

  def initialize(merchant, amount, time)
    @merchant = merchant
    @amount = amount
    @raw_time = time
    @time = Time.parse(time)
  end

  def self.from_json(data)
    Transaction.new(
      data["merchant"],
      data["amount"],
      data["time"]
    )
  end
end
