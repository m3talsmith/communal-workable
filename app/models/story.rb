class Story
  include Mongoid::Document

  field :name
  field :description

  belongs_to :epic
end
