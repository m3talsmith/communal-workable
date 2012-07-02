class Projects::TransactionsController < ProjectsController
  before_filter :force_user
  before_filter :find_project

  def new
    @transaction = @project.account.transactions.new
  end

  def create
    from_account = @current_user.accounts.find(params[:from_account])
    from_account.transfer amount: params[:amount].to_f, account: @project.account.id
    redirect_to @project
  end
end
