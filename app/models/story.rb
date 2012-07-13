class Story
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :description
  field :estimate, type: Float, default: 0.00
  field :story_owner_id
  field :status, default: 'waiting'
  field :deny_description
  field :points, type: Integer

  belongs_to :epic
  has_many   :tasks
  has_one    :account

  after_create :init_account

  STEPS = %w(waiting start finish deliver accept)

  def init_account
    self.account = Account.create nickname: 'primary'
  end

  def story_owner= user
    self.story_owner_id = user.id
  end

  def story_owner
    User.find(story_owner_id)
  end

  def start user
    update_attributes status: 'started', story_owner: user
  end

  def finish
    update_attribute :status, 'finished'
  end

  def deliver
    update_attribute :status, 'delivered'
  end

  def accept
    update_attribute :status, 'accepted'
    epic.project.account.transfer amount: estimate, account: story_owner.primary_account.id
  end

  def deny story_details
    tasks = story_details.delete('tasks')
    tasks.each do |task|
      failed_task = Task.find(task[1]['id'])
      failed_task.update_attribute :status, 'denied' if task[1]['status']
    end

    update_attributes story_details
  end

  def next_step
    STEPS[STEPS.index(status.gsub(/ed/, '')) + 1]
  end
end
