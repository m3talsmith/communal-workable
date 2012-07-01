class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname, default: 'primary'

  belongs_to :user
  belongs_to :project
  has_many :transactions
  has_many :orders

  def balance
    transactions.select do |trans|
      trans.validated?
    end.map(&:amount).sum
  end

  def deposit amount, pin=nil
    transactions.create amount: amount, pin: pin
  end

  def withdraw amount, pin
    deposit -amount, pin
  end

  def fund amount
    transactions.create amount: amount, kind: 'funding'
  end

  def payout amount
    transactions.create amount: -amount, kind: 'payout'
  end

  def transfer details
    pin = generate_pin

    to_account = Account.find(details[:account])
    to_account.deposit details[:amount], pin
    self.withdraw details[:amount], pin
  end

private
  def generate_pin
    "#{self.id}-#{Time.now.to_i}-#{self.transactions.count}"
  end
end
