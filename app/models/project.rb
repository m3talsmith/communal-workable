class Project
  include Mongoid::Document
  include Mongoid::Timestamps


  field :name

  has_and_belongs_to_many :users
  has_many :epics
  has_one :account

  after_create :init_account

  def remove_user user
    self.users = (users - users.drop(users.index(user)))
    save
  end

  def init_account
    self.account = Account.create nick_name: 'primary'
  end
end
