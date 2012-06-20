class Story
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :description

  belongs_to :epic
  has_many   :tasks
end
