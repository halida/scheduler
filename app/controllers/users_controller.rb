class UsersController < SimpleController

  def index
    @items = @items.paginate(page: params[:page])
  end

  private
  def resource_params
    params.require(:item).permit(
      :username, :email, :timezone, :status,
    )
  end

end

