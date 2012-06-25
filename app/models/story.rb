class Story
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :description
  field :estimate, type: Float, default: 0.00
  field :story_owner_id

  belongs_to :epic
  has_many   :tasks

  def story_owner= user
    self.story_owner_id = user.id
  end

  def story_owner
    User.find(story_owner_id)
  end

  def accept
    update_attribute :status, 'accepted'
    epic.project.account.transfer amount: estimate, account: story_owner.primary_account.id
  end
end
