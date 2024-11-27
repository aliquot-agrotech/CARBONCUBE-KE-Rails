def index
  if params[:search_query].present?
    @orders = Order.joins(:purchaser)
                  .where("vendors.phone_number = :query OR purchasers.phone_number = :query OR orders.id = :query", query: params[:search_query])
                  .includes(:purchaser, order_items: { product: :vendor })
  else
    @orders = Order.includes(:purchaser, order_items: { product: :vendor }).all
  end

  render json: @orders, each_serializer: OrderSerializer
end
