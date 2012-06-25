class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount
  field :pin

  # Valid transaction kinds are [funding, transfer, payout]
  field :kind, default: 'transfer'

  belongs_to :account

  def validated?
    %w(funding payout).each do |transaction_kind|
      return true if kind == transaction_kind
    end

    (
      Transaction.where(pin: self.pin, amount: self.amount) +
      Transaction.where(pin: self.pin, amount: -amount)
    ).count == 2
  end
end
