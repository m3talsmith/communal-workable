class Users::AccountsController < UsersController
  before_filter :force_user

  def index
    @accounts = @current_user.accounts
  end

end
