class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount

  belongs_to :account
end
