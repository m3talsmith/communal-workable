class Task
  include Mongoid::Document

  field :description
  field :completed, type: Boolean, default: false

  belongs_to :story
end
