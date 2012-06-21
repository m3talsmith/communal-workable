class Project
  include Mongoid::Document
  include Mongoid::Timestamps


  field :name

  has_and_belongs_to_many :users
  has_many :epics

  def remove_user user
    self.users = (users - users.drop(users.index(user)))
    save
  end
end
