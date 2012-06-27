class Users::AccountsController < UsersController
  before_filter :force_user
  before_filter :find_account, except: [:new, :create, :index]

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

  def update
    @account.update_attributes params[:account]
    redirect_to [@current_user, :accounts]
  end

private
  def find_account
    @account = Account.find(params[:id])
  end
end
