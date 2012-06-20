class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description
  field :completed, type: Boolean, default: false

  belongs_to :story
end
