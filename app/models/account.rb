class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname
  belongs_to :user
  belongs_to :project
end
