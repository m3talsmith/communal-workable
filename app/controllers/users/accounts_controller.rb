class Users::AccountsController < UsersController
  before_filter :force_user

  def index
    @accounts = @current_user.accounts
  end

  def new
    @account = @current_user.accounts.new
  end

  def create
    @account = @current_user.accounts.create params[:account]
    redirect_to [@current_user, :accounts]
  end
end
