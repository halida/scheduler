class Api::PlansController < ApiController

  def notify
    @item = Plan.where.not(token: nil).where(token: params[:plan_id]).first
    return render json: {status: :error, message: "no such plan"}, status: 404 unless @item

    @execution = @item.executions.where(status: :calling).first
    return render json: {status: :error, message: "no current execution"} unless @execution

    @execution.close(params[:status], params[:result])
    render json: {status: :succeeded, id: @item.id, execution_id: @execution.id}
  end

end
