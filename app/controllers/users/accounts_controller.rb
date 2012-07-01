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

  def destroy
    if @current_user.accounts.count == 1
      redirect_to :back, flash: {error: "This is your last account and can't be deleted"} and return
    else
      @account.destroy
      redirect_to [@current_user, :accounts] and return
    end
  end

private
  def find_account
    account_id = params[:account_id] ? params[:account_id] : params[:id]
    @account = @current_user.accounts.find(account_id)
  end
end
