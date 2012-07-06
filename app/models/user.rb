class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname

  embeds_many :providers

  has_many :accounts
  has_and_belongs_to_many :projects

  after_create :init_account

  class << self
    
    def from_provider(omniauth_hash)
      provider = omniauth_hash['provider']
      uid      = omniauth_hash['uid']

      user_query = User.where('providers.name' => provider, 'providers.uid' => uid).first
      return user_query if user_query

      user = create(providers: [Provider.new(name: provider, uid: uid)])
      return user
    end

  end

  def add_provider(omniauth_hash)
    provider = omniauth_hash['provider']
    uid      = omniauth_hash['uid']

    providers.create name: provider, uid: uid
    save
  end

  def init_account
    accounts.create nickname: 'primary', primary: true
  end

  def primary_account
    accounts.where(primary: true).first
  end
end
