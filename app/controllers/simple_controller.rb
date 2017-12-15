class SimpleController < ApplicationController
  load_and_authorize_resource param_method: :resource_params, instance_name: :item

  def index
    @items = @items.paginate(page: params[:page])
  end

end
