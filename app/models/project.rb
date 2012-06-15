class Project
  include Mongoid::Document

  field :name

  has_and_belongs_to_many :users
  has_many :epics
end
