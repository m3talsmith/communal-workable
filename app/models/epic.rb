class Epic
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name

  belongs_to :project
  has_many :stories

  def points
    stories.map(&:points).compact.sum
  end
end
