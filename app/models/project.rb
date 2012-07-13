class Project
  include Mongoid::Document
  include Mongoid::Timestamps


  field :name
  field :budget, type: Float, default: 0.0

  has_and_belongs_to_many :users
  has_many :epics
  has_one :account

  after_create :init_account

  def remove_user user
    self.users = (users - users.drop(users.index(user)))
    save
  end

  def init_account
    self.account = Account.create nickname: 'primary'
  end

  def stories
    epics.map(&:stories).
    flatten.
    compact
  end

  def estimated
    stories.map(&:estimate).
    flatten.
    compact.
    sum
  end

  def allotted
    stories.select {|story| story.status != 'completed'}.
    flatten.
    compact.
    map(&:estimate).
    sum
  end

  def spent
    stories.select {|story| story.status == 'completed'}.
    flatten.
    compact.
    map(&:estimate).
    sum
  end

  def funded
    account.transactions.map(&:amount).sum
  end

  def funded_balance
    funded - (allotted + spent)
  end

  def balance
    budget - (allotted + spent)
  end

  def points
    epics.map(&:points).compact.sum
  end
end
