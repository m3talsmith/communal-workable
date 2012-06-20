class Story
  include Mongoid::Document

  field :name
  field :description

  belongs_to :epic
  has_many   :tasks
end
