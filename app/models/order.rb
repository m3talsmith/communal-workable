class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status,                  default: 'pending'
  field :amount,     type: Float, default: 0.0

  field :cc_number,  type: Integer
  field :cc_expires
  field :cvv,        type: Integer
  field :postal_code
  field :name
  
  belongs_to :account
end
