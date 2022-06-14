class Api::ApplicationsController < ApiController

  def notify_plan
    @item = Application.where.not(token: nil).
              where(enabled: true, token: params[:application_id]).first
    return render json: {status: :error, message: "no such application"}, status: 404 unless @item

    @plan = @item.plans.where(enabled: true, title: params[:plan_title]).first
    return render json: {status: :error, message: "no such plan"} unless @plan

    @execution = @plan.executions.where(status: :calling).first
    return render json: {status: :error, message: "no current execution"} unless @execution

    @execution.close(params[:status], params[:result])
    render json: {status: :succeeded, id: @item.id, plan_id: @plan.id, execution_id: @execution.id}
  end

end
