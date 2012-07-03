class Projects::Epics::Stories::Accounts::TransactionsController < Projects::Epics::Stories::AccountsController
  before_filter :force_user
  before_filter :find_project
  before_filter :find_epic
  before_filter :find_story

  def new
    @transaction = @story.account.transactions.new
  end

  def create
    from_account = @current_user.accounts.find(params[:from_account])
    from_account.transfer amount: params[:amount].to_f, account: @story.account.id
    redirect_to [@project, @epic, @story]
  end
end
