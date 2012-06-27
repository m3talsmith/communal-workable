class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description
  field :status, default: 'pending'

  belongs_to :story

  scope :denied,    where(status: 'denied')
  scope :completed, where(status: 'completed')
end
