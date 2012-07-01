class Users::Accounts::OrdersController < Users::AccountsController
  before_filter :force_user
  before_filter :find_account
  before_filter :find_order, except: [:new, :create, :index]

  def new
    @order = @account.orders.new
  end

  def create
    @order = @account.orders.create params[:order]
    redirect_to [:process, @current_user, @account, @order]
  end

  def transfer
    #TODO: finish braintree integration
    result = Braintree::Transaction.sale(
      order_id: @order.id,
      amount:            @order.amount,
      credit_card: {
        number:          @order.cc_number,
        expiration_date: @order.cc_expires,
        cvv:             @order.cvv
      },
      billing: {
        postal_code:     @order.postal_code
      }
    )
    binding.pry
  end

private
  def find_order
    @order = @account.orders.find(params[:id])
  end
end
