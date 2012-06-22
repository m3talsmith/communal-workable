class Story
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :description
  field :estimate, type: Float, default: 0.00

  belongs_to :epic
  has_many   :tasks
end
