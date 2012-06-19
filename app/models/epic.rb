class Epic
  include Mongoid::Document
  
  field :name

  belongs_to :project
  has_many :stories
end
