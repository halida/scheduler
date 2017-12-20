class PlansController < SimpleController
  before_action :check_during, on: [:show]
  set_tab :plans, :nav

  def index
    @items = @items.
               preload(:execution_method, :routines).
               paginate(page: params[:page])
  end

  def show
    set_tab :schedules, :plan
  end

  def executions
    set_tab :executions, :plan
    @executions = ExecutionsController.search_executions(params, @item.executions, @begin_date, @finish_date)
  end

  def op
    case params[:type]
    when "execute"
      e = @item.executions.create!
      e.perform
      redirect_to e, notice: "Executing: ##{e.id}"
    when "expand"
      Scheduler::Lib.plan_expend_executions(@item, Time.now)
      redirect_to @item, notice: "Expanded"
    when "assign_token"
      @item.update_attributes!(token: Scheduler::Lib.get_token)
    end
  end

  private
  def resource_params
    params.require(:item).permit(
      :title, :description,
      :execution_method_id, :parameters_text, :waiting, :enabled)
  end

end
