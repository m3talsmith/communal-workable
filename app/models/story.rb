class Story
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :description
  field :estimate, type: Float, default: 0.00
  field :story_owner_id
  field :status, default: 'waiting'
  field :deny_description

  belongs_to :epic
  has_many   :tasks

  STEPS = %w(waiting start finish deliver accept)

  def story_owner= user
    self.story_owner_id = user.id
  end

  def story_owner
    User.find(story_owner_id)
  end

  def start user
    update_attributes status: 'started', story_owner: user
  end

  def accept
    update_attribute :status, 'accepted'
    epic.project.account.transfer amount: estimate, account: story_owner.primary_account.id
  end

  def deny story_details
    binding.pry
    update_attribute :status, 'denied'
  end

  def next_step
    STEPS[STEPS.index(status.gsub(/ed/, '')) + 1]
  end
end
