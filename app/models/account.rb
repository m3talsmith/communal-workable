class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname
  belongs_to :user
  belongs_to :project
  has_many :transactions

  def add_funds amount
    transactions.create amount: amount
  end

  def balance
    transactions.map(&:amount).sum
  end

  def withdraw amount
    add_funds -amount
  end
end
