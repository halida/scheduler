class PlansController < SimpleController
  set_tab :plans, :nav

  def index
    @items = Scheduler::Searcher.plans(@items, params)
  end

  def show
    set_tab :schedules, :plan
    self.check_during([Date.today-1.day, Date.today+4.day])
  end

  def executions
    set_tab :executions, :plan
    self.check_during([Date.today-1.day, Date.today+4.day])
    @executions = search_executions(@item.executions)
  end

  def op
    result = @item.workflow.op(params[:type])
    redirect_to(result[:target], notice: result[:msg])
  end

  private
  def resource_params
    params.require(:item).permit(
      :title, :description,
      :application_id, :execution_method_id,
      :parameters_text, :waiting, :enabled, :review_only
    )
  end

end
