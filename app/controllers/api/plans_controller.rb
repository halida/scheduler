class Api::PlansController < ApiController

  def notify
    @item = Plan.find_by(token: params[:plan_id])

    @execution = @item.executions.where(status: :calling).first
    return render json: {status: :error, message: "no current execution"} unless @execution

    @execution.close(params[:status], params[:result])
    render json: {status: :succeeded, id: @item.id, execution_id: @execution.id}
  end

end
