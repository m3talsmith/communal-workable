class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname
  belongs_to :user
  belongs_to :project
  has_many :transactions

  def balance
    transactions.map(&:amount).sum
  end

  def add_funds amount
    transactions.create amount: amount
  end

  def withdraw amount
    add_funds -amount
  end

  def transfer details
    to_account = Account.find(details[:account])
    to_account.add_funds details[:amount]
    self.withdraw details[:amount] 
  end
end
