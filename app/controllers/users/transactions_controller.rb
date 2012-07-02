class Users::TransactionsController < UsersController
  before_filter :force_user

  def new
    @from_accounts = @current_user.accounts
    @to_accounts = (@current_user.accounts + @current_user.projects.map(&:account).flatten.compact)
  end

  def create
    from_account = @current_user.accounts.find(params[:from_account])
    from_account.transfer(amount: params[:amount].to_f, account: params[:to_account])
    redirect_to [@current_user, :accounts]
  end
end
