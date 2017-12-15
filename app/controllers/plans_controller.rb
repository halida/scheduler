class PlansController < SimpleController

  private
  def resource_params
    params.require(:item).permit(:title, :description)
  end

end
