class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description
  field :completed, type: Boolean, default: false
  field :status, default: 'pending'

  belongs_to :story

  scope :denied, where(status: 'denied')
end
