class ApplicationsController < SimpleController
  set_tab :applications, :nav

  def index
    @items = @items.where("name like ?", "%#{params[:keyword]}%") if params[:keyword].present?
    @items = @items.paginate(page: params[:page])
  end

  def show
    @items = \
    @item.plans.
      preload(:execution_method, :routines, :application).
      paginate(page: params[:page])
  end

  private
  def resource_params
    params.require(:item).permit(
      :name,
    )
  end

end
