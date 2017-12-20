class Api::ExecutionsController < ApiController

  def notify
    @item = Execution.where(status: :calling).find_by(token: params[:execution_id])
    @item.close(params[:status], params[:result])
    render json: {status: :succeeded, id: @item.id}
  end

end
